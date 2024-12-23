import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import LabelEncoder
from imblearn.over_sampling import SMOTE  # Usando SMOTE
from xgboost import XGBClassifier
from sklearn.metrics import accuracy_score, confusion_matrix
import joblib

# Carregar os dados
file_path = 'tipos_de_solo_analise_agricola.csv'
df = pd.read_csv(file_path)

# Codificar variáveis categóricas
le_tipo_solo = LabelEncoder()
df['Tipo_Solo'] = le_tipo_solo.fit_transform(df['Tipo_Solo'])

le_drenagem = LabelEncoder()
df['Drenagem'] = le_drenagem.fit_transform(df['Drenagem'])

le_cultura = LabelEncoder()
df['Culturas_Indicadas'] = le_cultura.fit_transform(df['Culturas_Indicadas'])

# Verificar pH: Caso seja um intervalo (ex: '5.0-5.5'), calcular a média
df['pH'] = df['pH'].apply(lambda x: sum(map(float, x.split('-'))) / 2 if isinstance(x, str) else x)

# Remover colunas irrelevantes (a, b, c)
df = df.drop(columns=['a', 'b', 'c'])

# Definir X (características) e y (rótulo)
X = df[['Tipo_Solo', 'pH', 'Drenagem']]  # Variáveis de entrada
y = df['Culturas_Indicadas']  # Variável alvo (culturas)

# Balanceamento de classes com SMOTE (ajustando o número de vizinhos)
smote = SMOTE(random_state=42, k_neighbors=2)  # Reduzir os vizinhos para 2
X_res, y_res = smote.fit_resample(X, y)

# Dividir os dados em conjunto de treinamento e teste
X_train, X_test, y_train, y_test = train_test_split(X_res, y_res, test_size=0.2, random_state=42)

# Usar o modelo XGBoost
model = XGBClassifier(random_state=42, objective='multi:softmax', num_class=13, eval_metric='mlogloss')

# Ajuste de hiperparâmetros com GridSearchCV
param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [6, 10, 12],
    'learning_rate': [0.01, 0.1, 0.2],
    'subsample': [0.8, 1.0],
    'colsample_bytree': [0.8, 1.0]
}

# Usando GridSearchCV para ajuste de hiperparâmetros
grid_search = GridSearchCV(estimator=model, param_grid=param_grid, cv=3, n_jobs=-1, verbose=2)
grid_search.fit(X_train, y_train)

# Usar o melhor modelo encontrado
best_model = grid_search.best_estimator_

# Avaliar a acurácia do modelo
y_pred = best_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f'Acurácia do modelo: {accuracy:.4f}')

# Matriz de Confusão
conf_matrix = confusion_matrix(y_test, y_pred)

# Salvar o modelo treinado e os codificadores
joblib.dump(best_model, 'modelo_recomendacao_solo.pkl')
joblib.dump(le_tipo_solo, 'le_tipo_solo.pkl')
joblib.dump(le_drenagem, 'le_drenagem.pkl')
joblib.dump(le_cultura, 'le_cultura.pkl')

# Testar o modelo com várias entradas e imprimir todas as saídas da API
entradas_teste = [
    {'Tipo_Solo': 'Arenoso', 'pH': 6.0, 'Drenagem': 'Boa'},
    {'Tipo_Solo': 'Argiloso', 'pH': 5.5, 'Drenagem': 'Moderada'},
    {'Tipo_Solo': 'Arenoso', 'pH': 6.2, 'Drenagem': 'Boa'}
   
]

# Iterar sobre as entradas de teste
for entrada in entradas_teste:
    entrada_df = pd.DataFrame([entrada])

    # Verificar se o Tipo_Solo da entrada de teste está no LabelEncoder, senão adicionar um valor padrão
    if entrada_df['Tipo_Solo'].iloc[0] not in le_tipo_solo.classes_:
        print(f"Valor desconhecido para Tipo_Solo: {entrada_df['Tipo_Solo'].iloc[0]}, usando 'Arenoso' como valor padrão.")
        entrada_df['Tipo_Solo'] = 'Arenoso'

    # Codificar os valores da entrada de teste
    entrada_df['Tipo_Solo'] = le_tipo_solo.transform(entrada_df['Tipo_Solo'])
    entrada_df['Drenagem'] = le_drenagem.transform(entrada_df['Drenagem'])

    # Fazer a previsão para a entrada de teste
    predicao = best_model.predict(entrada_df)
    cultura_recomendada = le_cultura.inverse_transform(predicao)[0]

    # Encontrar as informações adicionais no CSV
    resultado = df[df['Culturas_Indicadas'] == le_cultura.transform([cultura_recomendada])[0]]

    # Obter os detalhes do CSV
    if not resultado.empty:
        detalhes = resultado.iloc[0]
        # Imprimir as saídas da API
        print(f"\nEntrada: {entrada}")
        print(f"Cultura recomendada: {cultura_recomendada}")
        print(f"Comentários adicionais: {detalhes['Comentarios_Adicionais']}")
        print(f"Insumos recomendados: {detalhes['Insumos_Recomendados']}")
        print(f"Quantidade de insumos: {detalhes['Quantidade_Insumos_kg_ha']} kg/ha")
        print(f"Produtividade estimada: {detalhes['Produtividade_Estimada_ton_ha']} ton/ha")
    else:
        print(f"\nNenhuma informação adicional encontrada para a entrada: {entrada}")

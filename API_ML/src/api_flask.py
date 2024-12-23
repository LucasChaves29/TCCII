from flask import Flask, request, jsonify
import joblib
import pandas as pd
from sklearn.preprocessing import LabelEncoder

# Inicializa o Flask
app = Flask(__name__)

# Carrega o modelo treinado e os codificadores
model = joblib.load('modelo_recomendacao_solo.pkl')
le_tipo_solo = joblib.load('le_tipo_solo.pkl')
le_drenagem = joblib.load('le_drenagem.pkl')
le_cultura = joblib.load('le_cultura.pkl')

# Carrega a tabela de solos (tipos_de_solo_analise_agricola.csv)
df = pd.read_csv('tipos_de_solo_analise_agricola.csv')

# Função de predição de cultura
def predict_soil_culture(tipo_solo, ph, drenagem):
    try:
        entrada = pd.DataFrame([{
            'Tipo_Solo': tipo_solo,
            'pH': ph,
            'Drenagem': drenagem
        }])

        entrada['Tipo_Solo'] = le_tipo_solo.transform(entrada['Tipo_Solo'])
        entrada['Drenagem'] = le_drenagem.transform(entrada['Drenagem'])

        predicao = model.predict(entrada)
        cultura_recomendada = le_cultura.inverse_transform(predicao)[0]

        resultado = df[(df['Culturas_Indicadas'] == cultura_recomendada) & 
                       (df['pH'] == ph) & 
                       (df['Drenagem'] == drenagem)]

        if not resultado.empty:
            detalhes = resultado.iloc[0]
            
            # Conversão de tipos de dados para tipos compatíveis com JSON
            return {
                "success": True,
                "recommended_culture": str(detalhes['Culturas_Indicadas']),  # Garantir que seja string
                "comentarios_adicionais": str(detalhes['Comentarios_Adicionais']),
                "insumos_recomendados": str(detalhes['Insumos_Recomendados']),
                "quantidade_insumos": float(detalhes['Quantidade_Insumos_kg_ha']),  # Garantir que seja float
                "produtividade_estimada": float(detalhes['Produtividade_Estimada_ton_ha'])  # Garantir que seja float
            }
        else:
            return {"error": "Nenhuma informação encontrada para essa entrada."}

    except Exception as e:
        return {"error": str(e)}

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data_input = request.get_json()

        if not data_input or not all(key in data_input for key in ('Tipo_Solo', 'pH', 'Drenagem')):
            return jsonify({"error": "Dados incompletos. Inclua Tipo_Solo, pH e Drenagem."}), 400

        tipo_solo = data_input['Tipo_Solo']
        ph = data_input['pH']
        drenagem = data_input['Drenagem']

        result = predict_soil_culture(tipo_solo, ph, drenagem)

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

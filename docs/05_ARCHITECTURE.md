### **Arquitetura do Sistema**

#### **Visão Geral**
O projeto é dividido em dois componentes principais:
1. **Aplicação Flutter**:
   - Responsável pela interface de usuário e interação.
   - Componentes principais:
     - `menu_principal_screen.dart`: Tela inicial do sistema.
     - `cadastro_terra_screen.dart`: Cadastro de terras.
     - `listar_terras_screen.dart`: Listagem de terras cadastradas.
     - `recommendation_screen.dart`: Tela de recomendação.

2. **API Flask**:
   - Processa dados de entrada e retorna recomendações agrícolas usando aprendizado de máquina.
   - Componentes principais:
     - `api_flask.py`: Define os endpoints e carrega o modelo treinado.
     - `train_model.py`: Treina e salva o modelo de machine learning.

#### **Modelo de Machine Learning**
- O modelo utiliza Random Forest para prever a cultura ideal com base em:
  - Tipo de solo
  - pH
  - Drenagem
- Arquivos gerados:
  - `modelo_recomendacao_solo.pkl`: Modelo treinado.
  - Codificadores: `le_tipo_solo.pkl`, `le_drenagem.pkl`, `le_cultura.pkl`.

#### **Fluxo de Dados**
1. O usuário insere informações no app Flutter.
2. Os dados são enviados para a API Flask via requisição HTTP.
3. A API processa a entrada, consulta o modelo treinado e retorna a cultura recomendada.
4. O aplicativo exibe os resultados ao usuário.

---
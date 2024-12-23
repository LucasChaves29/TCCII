### **Perguntas Frequentes (FAQ)**

#### **1. O que fazer se o aplicativo não inicia no emulador ou dispositivo físico?**
- Certifique-se de que o Flutter está configurado corretamente. Execute o comando:
  ```bash
  flutter doctor
  ```
  Verifique se todos os componentes necessários estão instalados e configurados.

#### **2. A API Flask retorna um erro de conexão. O que pode ser?**
- Certifique-se de que a API Flask está rodando no endereço correto (`http://127.0.0.1:5000`) e que o servidor foi iniciado com:
  ```bash
  python api_flask.py
  ```

#### **3. O que fazer se não consigo instalar as dependências do Python?**
- Verifique se o ambiente virtual está ativo e tente instalar novamente com:
  ```bash
  pip install -r requirements.txt
  ```

#### **4. Como atualizar os dados de análise agrícola (CSV)?**
- Substitua o arquivo `tipos_de_solo_analise_agricola.csv` pelo novo arquivo. Certifique-se de que o formato está correto e reinicie a API Flask.

#### **5. É possível treinar o modelo novamente?**
- Sim, use o script `train_model.py` para treinar o modelo com novos dados:
  ```bash
  python train_model.py
  ```

---


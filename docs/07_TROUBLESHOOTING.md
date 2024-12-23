### **Solução de Problemas (TROUBLESHOOTING)**

#### **Erro: `No module named 'flask'`**
- Solução: Instale o Flask no ambiente virtual:
  ```bash
  pip install flask
  ```

#### **Erro: `Cannot connect to API`**
- Verifique se a API está rodando no terminal. Caso contrário, inicie-a com:
  ```bash
  python api_flask.py
  ```
- Certifique-se de que o aplicativo Flutter está configurado para acessar o mesmo endereço IP da API.

#### **Erro: `ValueError: Could not find a value for...` ao usar `/predict`**
- Solução: Certifique-se de que os valores enviados na requisição estão presentes no conjunto de dados usado para treinar o modelo. Adapte os valores no arquivo `tipos_de_solo_analise_agricola.csv` e treine o modelo novamente.

#### **O aplicativo Flutter trava ao acessar a tela de recomendação**
- Verifique a conexão com a API. Caso esteja fora do ar, reinicie-a.
- Certifique-se de que todos os campos da tela foram preenchidos corretamente antes de enviar a requisição.

#### **Erro: `Permission denied` ao tentar gravar arquivos do modelo**
- Solução: Verifique as permissões da pasta onde o script está tentando salvar os arquivos (`modelo_recomendacao_solo.pkl` e os codificadores). Conceda permissão com:
  ```bash
  chmod 777 <nome_da_pasta>
  ```

#### **Erro de dependência no Flutter (`pub get failed`)**
- Solução: Execute o comando para limpar o cache e baixar as dependências novamente:
  ```bash
  flutter clean
  flutter pub get
  ```

---
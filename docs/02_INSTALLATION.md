### **Guia de Instalação**

#### **Configuração do Ambiente Flutter**
1. Instale o Flutter seguindo as [instruções oficiais](https://flutter.dev/docs/get-started/install).
2. Clone o repositório:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <PASTA_DO_PROJETO>
   ```
3. Baixe as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o projeto:
   ```bash
   flutter run
   ```

#### **Configuração do Ambiente Python**
1. Crie e ative um ambiente virtual:
   ```bash
   python -m venv venv
   source venv/bin/activate   # No Windows: venv\Scripts\activate
   ```
2. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```
3. Coloque o arquivo `tipos_de_solo_analise_agricola.csv` na mesma pasta do servidor Flask.
4. Execute o servidor:
   ```bash
   python api_flask.py
   ```

#### **Verificação**
Após a instalação:
- A aplicação Flutter deve estar rodando no emulador/dispositivo.
- A API Flask deve estar disponível no endereço `http://127.0.0.1:5000`.

---
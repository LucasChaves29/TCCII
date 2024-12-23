### **Guia de Uso**

O guia de uso descreve como interagir com as principais funcionalidades do aplicativo.

#### **Uso da Aplicação Flutter**
1. **Menu Principal**:
   - Após realizar o login, você será redirecionado ao Menu Principal, onde poderá acessar:
     - **Cadastro de terras**
     - **Cadastro de safras**
     - **Controle de estoque**
     - **Tela de recomendação de culturas**

2. **Cadastro de Terras**:
   - Clique em **"Terras"** no Menu Principal.
   - Preencha os campos obrigatórios, como **nome da terra**, **localização** e **tipo de solo**.
   - Confirme o cadastro e aguarde a mensagem de sucesso.

3. **Cadastro de Safras**:
   - Clique em **"Safras"** no Menu Principal.
   - Preencha as informações da safra, como **terra associada**, **data de início** e **produtos utilizados**.
   - Finalize o cadastro e verifique se a safra foi listada na tela correspondente.

4. **Controle de Estoque**:
   - Adicione produtos ao estoque selecionando **"Estoque"** no Menu Principal.
   - Inclua entradas e saídas de produtos no sistema para manter o controle atualizado.
   - Verifique os detalhes do produto na tela de listagem.

5. **Tela de Recomendação**:
   - Acesse a funcionalidade de recomendação para obter sugestões de culturas agrícolas com base no tipo de solo, pH e drenagem.
   - Insira os parâmetros solicitados e receba a cultura recomendada.

#### **Uso da API Flask**:
- Endpoint disponível: **`/predict`**
- Método: **POST**
- Exemplo de requisição:
  ```json
  {
    "Tipo_Solo": "Arenoso",
    "pH": 6.5,
    "Drenagem": "Boa"
  }
  ```
- Resposta esperada:
  ```json
  {
    "success": true,
    "recommended_culture": "Soja",
    "insumos_recomendados": "Adubo NPK",
    "quantidade_insumos": "20kg/ha",
    "produtividade_estimada": "50 sacas/ha",
    "comentarios_adicionais": "Cultivar resistente à seca."
  }
  ```

---
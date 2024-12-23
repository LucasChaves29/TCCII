### **Documentação da API**

#### **Endpoints Disponíveis**
1. **`/predict`**
   - **Descrição**: Retorna uma recomendação de cultura agrícola com base nos parâmetros enviados.
   - **Método**: POST
   - **Cabeçalhos**:
     - `Content-Type`: `application/json`
   - **Parâmetros no corpo**:
     - `Tipo_Solo` (string): Tipo de solo (ex.: "Arenoso").
     - `pH` (float): Valor do pH (ex.: 6.5).
     - `Drenagem` (string): Nível de drenagem (ex.: "Boa").
   - **Exemplo de Requisição**:
     ```json
     {
       "Tipo_Solo": "Arenoso",
       "pH": 6.5,
       "Drenagem": "Boa"
     }
     ```
   - **Resposta**:
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
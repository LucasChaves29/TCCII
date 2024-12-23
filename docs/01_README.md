# Documentação do Projeto

Bem-vindo à documentação do projeto! Use os links abaixo para acessar cada seção:

1. [Introdução e Guia Rápido](docs/01_README.md)
2. [Instruções de Instalação](docs/02_INSTALLATION.md)
3. [Guia de Uso](docs/03_USAGE.md)
4. [Documentação da API](docs/04_API_REFERENCE.md)
5. [Descrição da Arquitetura](docs/05_ARCHITECTURE.md)
6. [Perguntas Frequentes (FAQ)](docs/06_FAQ.md)
7. [Solução de Problemas](docs/07_TROUBLESHOOTING.md)


### **Introdução**

O projeto é uma plataforma digital desenvolvida para gerenciamento agrícola, focando em cadastro, análise e recomendações personalizadas. Ele combina uma aplicação Flutter para interface de usuário com uma API Flask, que utiliza aprendizado de máquina para gerar insights a partir de dados de solos. 

**Principais funcionalidades**:
- Cadastro de safras, terras e produtos.
- Controle de estoque de insumos agrícolas.
- Análise e recomendação de culturas com base em características do solo.
- Integração com um modelo de machine learning para previsão.

**Público-alvo**:
Agricultores, gestores de propriedades rurais e profissionais do agronegócio que buscam otimizar sua produtividade.

---

### **Requisitos do Sistema**

Para executar o projeto corretamente, é necessário:

#### **Ambiente de Desenvolvimento**
1. **Flutter**: Versão 3.10 ou superior.
2. **Dart**: Compatível com a versão do Flutter.
3. **Python**: Versão 3.8 ou superior.
4. **Bibliotecas Python**:
   - `Flask`
   - `joblib`
   - `pandas`
   - `scikit-learn`

#### **Outros Requisitos**
- Arquivo CSV: `tipos_de_solo_analise_agricola.csv` contendo dados de análise agrícola.
- Modelos pré-treinados:
  - `modelo_recomendacao_solo.pkl`
  - Codificadores: `le_tipo_solo.pkl`, `le_drenagem.pkl`, `le_cultura.pkl`.

#### **Requisitos de Hardware**
- Computador com pelo menos 8 GB de RAM.
- Armazenamento: 1 GB de espaço livre para dependências e arquivos do projeto.

---

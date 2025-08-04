# MVP Consulta CEP

**MVP (Minimum Viable Product)** de consulta de CEP utilizando o WebService público [ViaCEP](https://viacep.com.br/).

## 📚 Descrição

Este projeto foi desenvolvido com foco em boas práticas de desenvolvimento e organização de código, utilizando:

- **Arquitetura MVC** para garantir o desacoplamento entre as camadas;
- **Padrão Fluent Interface** para facilitar a leitura e encadeamento de métodos;
- **Padrão Factory Method** para a criação da instância de conexão com o SQLite;
- **Programação Orientada a Objetos (POO)**;
- Princípios **SOLID**;
- Práticas de **Clean Code**;
- Implementação baseada em **interfaces**.

- ## 🛠️ Tecnologias utilizadas

- 🧱 **Delphi 12 Community Edition**
- 🗃️ **SQLite** 
- 🌐 **API ViaCEP** (WebService público)
- 🧩 Componentização com **BuscaCep.dpk**

## 🚀 Como executar

1. Abra o Delphi 12 CE;
2. Instale o componente `BuscaCep.dpk` localizado na pasta `/Componentes`;
3. Compile o projeto principal;
4. O executável gerado será `BuscadorCep.exe`, localizado na pasta `Win32/Release`.

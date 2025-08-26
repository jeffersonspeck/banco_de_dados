# Banco de Dados — Conteúdos & Atividades

Repositório para materiais e exercícios da disciplina de **Banco de Dados**. Aqui você encontrará **atividades práticas**, **materiais de apoio** e instruções para execução no **PostgreSQL**.

## Estrutura de Pastas

```text
/
├─ README.md
├─ atividades/
│  ├─ join_subconsultas/
│  │  ├─ 01/
│  │  │  ├─ atividade_sql_biblioteca.md   # enunciado + 20 SQLs respondidas
│  │  │  ├─ DER_Biblioteca_vetorial.pdf   # (adicione aqui)
│  │  │  └─ bd.sql                        # (adicione aqui)
│  │  ├─ 02/  # conteúdo em breve
│  │  └─ 03/  # conteúdo em breve
└─ materiais/
   ├─ aulas/            # conteúdo em breve
   ├─ slides/           # conteúdo em breve
   ├─ sql_cheatsheet/   # conteúdo em breve
   ├─ modelagem/        # conteúdo em breve
   ├─ configuracao/     # Manuais e conteúdos de configuração
   └─ datasets/         # conteúdo em breve
```

---

## Atividades

### join_subconsultas
- **[01 — Biblioteca Universitária (JOINs + Subconsultas)](atividades/join_subconsultas/01/README.md)**  
  Breve resumo: atividade prática com **20 consultas SQL** cobrindo `JOIN` (INNER/LEFT), `NOT EXISTS`, `COUNT FILTER`, `GROUP BY/HAVING`, `MAX`, `DISTINCT`, **subconsultas correlacionadas** e uso de `ROW_NUMBER()` para **pareamento** por curso. Inclui relatórios de empréstimos, livros sem exemplar, autores sem publicações, combinações curso×editora (CROSS JOIN), ranking de alunos e outras análises.

- **02 — (em breve)**  
- **03 — (em breve)**  

> Outras famílias de atividades (por exemplo, *CTEs e Recursão*, *Views e Índices*, *Funções/Triggers*, *Transações/ACID*) podem ser adicionadas depois — **conteúdo em breve**.

---

## Materiais

- **[aulas](materiais/aulas/README.md)** — conteúdo em breve  
- **[slides](materiais/slides/README.md)** — conteúdo em breve  
- **[sql_cheatsheet](materiais/sql_cheatsheet/README.md)** — conteúdo em breve  
- **[modelagem](materiais/modelagem/README.md)** — conteúdo em breve  
- **[datasets](materiais/datasets/README.md)** — conteúdo em breve  

---

## Execução das Atividades

### Opção A) db-fiddle (recomendado para prática rápida)
1. Abra **https://www.db-fiddle.com/** e selecione **PostgreSQL**.

### Opção B) Ambiente local (PostgreSQL)
1. Instale o PostgreSQL 14+.
2. Execute:
   ```bash
   psql -U seu_usuario -f bd.sql
   ```
3. Utilize `psql` ou seu cliente favorito (DBeaver, Beekeeper, etc.) para testar as consultas.


### Opção C) Ambiente windows
- **[Cpnfigurações](materiais/configuracao/instalacao_postgres.pdf)** — Manual simplificado de instação. 
---

## Licença
Licença de Uso e Atribuição (Permissiva)

Copyright (c) 2025 Jefferson Rodrigo Speck

PERMISSÃO é concedida, gratuitamente, a qualquer pessoa que obtenha uma cópia deste
repositório e de seus conteúdos (código, textos, imagens, dados e demais materiais), para
usar, copiar, modificar, fundir, publicar, distribuir, sublicenciar e/ou vender cópias,
para qualquer finalidade, inclusive comercial, observadas as seguintes CONDIÇÕES:

1) ATRIBUIÇÃO: Você deve creditar de forma apropriada o autor original, citando
   “Jefferson Rodrigo Speck”, e, sempre que possível, incluir um link para este repositório
   ou para a página do projeto. Ex.: “Conteúdo baseado em Jefferson Rodrigo Speck”.
2) AVISO DE LICENÇA: Esta nota de copyright e de licença deve ser mantida em todas
   as cópias e derivações significativas.
3) MUDANÇAS: Se você modificar o conteúdo, indique que mudanças foram feitas.
4) SEM RESTRIÇÕES ADICIONAIS: Você não pode aplicar termos legais ou medidas
   tecnológicas que restrinjam legalmente outros de fazer algo permitido por esta licença.

ISENÇÃO DE GARANTIA: O CONTEÚDO É FORNECIDO “NO ESTADO EM QUE SE ENCONTRA”,
SEM QUALQUER GARANTIA, EXPRESSA OU IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO A,
GARANTIAS DE COMERCIABILIDADE, ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO E
NÃO-INFRAÇÃO. EM NENHUM CASO OS AUTORES OU DETENTORES DE DIREITOS SERÃO
RESPONSÁVEIS POR QUALQUER REIVINDICAÇÃO, DANO OU OUTRA RESPONSABILIDADE,
SEJA EM AÇÃO CONTRATUAL, ILÍCITO CIVIL OU OUTRA, DECORRENTE DE, OU EM
CONEXÃO COM O CONTEÚDO OU O USO OU OUTRAS NEGOCIAÇÕES COM O CONTEÚDO.

Esta licença não concede direitos sobre marcas, logotipos ou nomes dos autores.

> Novos conjuntos (CTEs/Recursão, Views/Índices, Funções/Triggers, Transações/ACID, etc.) serão adicionados — conteúdo em breve.

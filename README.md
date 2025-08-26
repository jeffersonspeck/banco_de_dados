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
- **[aulas](materiais/configuracao/instalacao_postgres.pdf)** — Manual simplificado de instação. 
---

## Licença
Defina a licença do repositório (por exemplo, MIT).


> Novos conjuntos (CTEs/Recursão, Views/Índices, Funções/Triggers, Transações/ACID, etc.) serão adicionados — conteúdo em breve.

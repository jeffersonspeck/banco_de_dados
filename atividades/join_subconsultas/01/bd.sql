-- ===============================================================
-- BIBLIOTECA UNIVERSITÁRIA (PostgreSQL) - 3FN + Exemplos de JOIN
-- ===============================================================

-- Limpeza (para rodar várias vezes no db-fiddle)
DROP SCHEMA IF EXISTS biblioteca CASCADE;
CREATE SCHEMA biblioteca;
SET search_path TO biblioteca;

-- ======================
-- Tabelas (3ª Forma Normal)
-- ======================

-- 1: Course (Curso) 1:N Student
CREATE TABLE course (
  course_id    SERIAL PRIMARY KEY,
  name         VARCHAR(100) NOT NULL UNIQUE,
  department   VARCHAR(100) NOT NULL
);

-- 2: Student (Aluno) N:1 Course
CREATE TABLE student (
  student_id     SERIAL PRIMARY KEY,
  enrollment_no  VARCHAR(20) NOT NULL UNIQUE,
  full_name      VARCHAR(120) NOT NULL,
  email          VARCHAR(120) NOT NULL UNIQUE,
  course_id      INT NOT NULL REFERENCES course(course_id)
);

-- 2.1: StudentProfile (Perfil) 1:1 Student
-- PK = FK garante relação 1:1 (cada aluno tem no máx. 1 perfil)
CREATE TABLE student_profile (
  student_id   INT PRIMARY KEY REFERENCES student(student_id),
  birthdate    DATE,
  phone        VARCHAR(20)
);

-- 3: Publisher (Editora) 1:N Book
CREATE TABLE publisher (
  publisher_id  SERIAL PRIMARY KEY,
  name          VARCHAR(120) NOT NULL UNIQUE
);

-- 4: Author (Autor) N:N Book via BookAuthor
CREATE TABLE author (
  author_id   SERIAL PRIMARY KEY,
  name        VARCHAR(120) NOT NULL UNIQUE
);

-- 5: Book (Livro) N:1 Publisher
CREATE TABLE book (
  book_id       SERIAL PRIMARY KEY,
  isbn          VARCHAR(20) NOT NULL UNIQUE,
  title         VARCHAR(200) NOT NULL,
  publisher_id  INT NOT NULL REFERENCES publisher(publisher_id),
  pub_year      INT NOT NULL CHECK (pub_year BETWEEN 1500 AND 2100)
);

-- 6: BookAuthor (Livro-Autor) N:N
CREATE TABLE book_author (
  book_id    INT NOT NULL REFERENCES book(book_id) ON DELETE CASCADE,
  author_id  INT NOT NULL REFERENCES author(author_id),
  PRIMARY KEY (book_id, author_id)
);

-- 7: Exemplar (cópias físicas) 1:N a partir de Book
CREATE TABLE exemplar (
  exemplar_id  SERIAL PRIMARY KEY,
  book_id      INT NOT NULL REFERENCES book(book_id),
  copy_code    VARCHAR(30) NOT NULL UNIQUE,  -- etiqueta/plaqueta
  location     VARCHAR(50),                  -- estante/prateleira
  notes        VARCHAR(200)
);

-- 8: Loan (Empréstimo) N:1 Student
-- (Cabeçalho; itens ficam em loan_item)
CREATE TABLE loan (
  loan_id     SERIAL PRIMARY KEY,
  student_id  INT NOT NULL REFERENCES student(student_id),
  loan_date   DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 9: LoanItem (Itens do Empréstimo) N:1 Loan, N:1 Exemplar
-- Cada exemplar aparece em vários históricos, mas apenas 1 ativo (return_date IS NULL)
CREATE TABLE loan_item (
  loan_id                INT NOT NULL REFERENCES loan(loan_id) ON DELETE CASCADE,
  exemplar_id            INT NOT NULL REFERENCES exemplar(exemplar_id),
  expected_return_date   DATE NOT NULL,
  return_date            DATE,
  PRIMARY KEY (loan_id, exemplar_id)
);

-- Índice parcial para impedir o mesmo exemplar em 2 empréstimos ATIVOS
-- (somente quando return_date IS NULL)
CREATE UNIQUE INDEX uq_exemplar_active
  ON loan_item (exemplar_id)
  WHERE return_date IS NULL;

-- ======================
-- Inserts de Exemplo
-- ======================

-- Cursos
INSERT INTO course (name, department) VALUES
('Ciência da Computação', 'Tecnologia'),
('Administração',          'Gestão'),
('Ciências Contábeis',     'Gestão');

-- Alunos
INSERT INTO student (enrollment_no, full_name, email, course_id) VALUES
('2025001', 'Alice Souza',    'alice@uni.edu', 1),
('2025002', 'Bruno Lima',     'bruno@uni.edu', 3),
('2025003', 'Carla Mendes',   'carla@uni.edu', 1),
('2025004', 'Daniel Pereira', 'daniel@uni.edu', 2);

-- Perfis (1:1) – deixamos Carla e Daniel SEM perfil para mostrar LEFT JOIN
INSERT INTO student_profile (student_id, birthdate, phone) VALUES
(1, '2003-02-15', '(45) 99999-0001'),
(2, '2002-11-08', '(45) 98888-0002');

-- Editoras
INSERT INTO publisher (name) VALUES
('TechBooks'),
('Aprender+');

-- Autores (um autor sem livros para FULL/RIGHT JOIN)
INSERT INTO author (name) VALUES
('João Autor'),
('Maria Pesquisadora'),
('Autor Sem Publicações');

-- Livros (um livro sem exemplares para LEFT JOIN)
INSERT INTO book (isbn, title, publisher_id, pub_year) VALUES
('978-0-111-00001', 'Estruturas de Dados em Profundidade', 1, 2022),  -- book_id 1
('978-0-111-00002', 'Bancos de Dados: Teoria e Prática',   1, 2023),  -- book_id 2
('978-0-222-00003', 'Introdução à Administração',          2, 2021);  -- book_id 3

-- Livro-Autor (N:N)
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),  -- João -> Estruturas
(1, 2),  -- Maria -> Estruturas
(2, 2);  -- Maria -> BD

-- Exemplares (cópias físicas) – livro 3 fica sem exemplar
INSERT INTO exemplar (book_id, copy_code, location, notes) VALUES
(1, 'EX-A-001', 'E1-P1', 'Boa condição'),
(1, 'EX-A-002', 'E1-P1', 'Leve desgaste'),
(2, 'EX-B-001', 'E2-P3', 'Novo');

-- Empréstimos (Alice e Bruno tomam livros; Carla e Daniel sem)
INSERT INTO loan (student_id, loan_date) VALUES
(1, '2025-08-01'),  -- loan_id 1 - Alice
(2, '2025-08-05');  -- loan_id 2 - Bruno

-- Itens de Empréstimo
-- Alice pega EX-A-001 (devolve) e EX-B-001 (ainda ativo)
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date, return_date) VALUES
(1, 1, '2025-08-15', '2025-08-10'); -- devolvido
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date) VALUES
(1, 3, '2025-08-15');               -- ativo (sem return_date)

-- Bruno pega EX-A-002 (ativo)
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date) VALUES
(2, 2, '2025-08-20');

-- ===========================================
-- INSERTS ADICIONAIS (colar após seu script)
-- ===========================================

-- Editoras extras
-- Editoras extras (inclui Wiley já aqui!)
INSERT INTO publisher (name) VALUES
('MIT Press'),
('McGraw-Hill'),
('Addison-Wesley'),
('Pearson'),
('Prentice Hall'),
('Bookman'),
('Atlas'),
('Elsevier'),
('Saraiva Educação'),
('Wiley')          -- <<< ADICIONADA ANTES DOS LIVROS
;
-- Autores extras (mantém "Autor Sem Publicações" já inserido)
INSERT INTO author (name) VALUES
('Thomas H. Cormen'),
('Charles E. Leiserson'),
('Ronald L. Rivest'),
('Clifford Stein'),
('Abraham Silberschatz'),
('Henry F. Korth'),
('S. Sudarshan'),
('Andrew S. Tanenbaum'),
('Herbert Bos'),
('Elmasri'),
('Navathe'),
('Ian Sommerville'),
('Roger S. Pressman'),
('Erich Gamma'),
('Richard Helm'),
('Ralph Johnson'),
('John Vlissides'),
('Robert C. Martin'),
('Martin Fowler'),
('Philip Kotler'),
('Kevin Lane Keller'),
('Idalberto Chiavenato'),
('Sérgio de Iudícibus'),
('José Carlos Marion'),
('Kenneth C. Laudon'),
('Jane P. Laudon');

-- Livros (novos) — alguns clássicos e alguns de ADM/Contábeis
INSERT INTO book (isbn, title, publisher_id, pub_year) VALUES
('978-0-262-03384-8', 'Introduction to Algorithms (3rd ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'MIT Press'), 2009),
('978-0-07-352332-3', 'Database System Concepts (6th ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'McGraw-Hill'), 2010),
('978-0-13-359162-0', 'Modern Operating Systems (4th ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'Pearson'), 2014),
('978-0-13-110362-7', 'The C Programming Language (2nd ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'Prentice Hall'), 1988),
('978-0-201-63361-0', 'Design Patterns: Elements of Reusable Object-Oriented Software',
  (SELECT publisher_id FROM publisher WHERE name = 'Addison-Wesley'), 1994),
('978-0-13-235088-4', 'Clean Code: A Handbook of Agile Software Craftsmanship',
  (SELECT publisher_id FROM publisher WHERE name = 'Prentice Hall'), 2008),
('978-0-201-48567-7', 'Refactoring: Improving the Design of Existing Code',
  (SELECT publisher_id FROM publisher WHERE name = 'Addison-Wesley'), 1999),
('978-0-13-214535-0', 'Engineering Software Products',
  (SELECT publisher_id FROM publisher WHERE name = 'Pearson'), 2021),
('978-85-407-0000-1', 'Administração: Teoria, Processo e Prática',
  (SELECT publisher_id FROM publisher WHERE name = 'Atlas'), 2014),
('978-0-13-385646-0', 'Marketing Management (15th ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'Pearson'), 2015),
('978-85-216-1234-5', 'Contabilidade Introdutória',
  (SELECT publisher_id FROM publisher WHERE name = 'Saraiva Educação'), 2017),
('978-85-300-0001-0', 'Contabilidade Básica',
  (SELECT publisher_id FROM publisher WHERE name = 'Atlas'), 2010),
('978-85-8260-0001-2', 'Sistemas de Informação Gerenciais',
  (SELECT publisher_id FROM publisher WHERE name = 'Bookman'), 2016),
('978-0-13-608620-8', 'Fundamentals of Database Systems (6th ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'Addison-Wesley'), 2010),
('978-0-13-212695-3', 'Computer Networks (5th ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'Pearson'), 2010),
('978-85-352-0001-0', 'Engenharia de Software (Pressman)',
  (SELECT publisher_id FROM publisher WHERE name = 'McGraw-Hill'), 2011),
('978-0-470-12872-5', 'Operating System Concepts (8th ed.)',
  (SELECT publisher_id FROM publisher WHERE name = 'Wiley' ) -- Wiley não existe ainda
 , 2008);

-- Se "Wiley" não existir, cria antes e reexecuta a INSERT acima:
-- DO $$
-- BEGIN
--   IF NOT EXISTS (SELECT 1 FROM publisher WHERE name='Wiley') THEN
--     INSERT INTO publisher(name) VALUES ('Wiley');
--   END IF;
-- END$$;

-- Ajusta o publisher do "Operating System Concepts" para Wiley
UPDATE book
SET publisher_id = (SELECT publisher_id FROM publisher WHERE name='Wiley')
WHERE isbn = '978-0-470-12872-5';

-- Mapeamentos Livro-Autor (N:N)
-- CLRS
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-262-03384-8' AND a.name IN
('Thomas H. Cormen','Charles E. Leiserson','Ronald L. Rivest','Clifford Stein');

-- Database System Concepts
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-07-352332-3' AND a.name IN
('Abraham Silberschatz','Henry F. Korth','S. Sudarshan');

-- Modern Operating Systems
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-359162-0' AND a.name IN
('Andrew S. Tanenbaum','Herbert Bos');

-- K&R C
INSERT INTO author (name) VALUES ('Brian W. Kernighan'), ('Dennis M. Ritchie')
ON CONFLICT (name) DO NOTHING;

INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-110362-7' AND a.name IN
('Brian W. Kernighan','Dennis M. Ritchie');

-- Design Patterns (GoF)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-201-63361-0' AND a.name IN
('Erich Gamma','Richard Helm','Ralph Johnson','John Vlissides');

-- Clean Code
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-235088-4' AND a.name IN ('Robert C. Martin');

-- Refactoring
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-201-48567-7' AND a.name IN ('Martin Fowler');

-- Engineering Software Products (Sommerville)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-214535-0' AND a.name IN ('Ian Sommerville');

-- Administração (Chiavenato)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-85-407-0000-1' AND a.name IN ('Idalberto Chiavenato');

-- Marketing Management (Kotler & Keller)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-385646-0' AND a.name IN ('Philip Kotler','Kevin Lane Keller');

-- Contabilidade Introdutória (Iudícibus)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-85-216-1234-5' AND a.name IN ('Sérgio de Iudícibus');

-- Contabilidade Básica (Marion)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-85-300-0001-0' AND a.name IN ('José Carlos Marion');

-- Sistemas de Informação Gerenciais (Laudon & Laudon)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-85-8260-0001-2' AND a.name IN ('Kenneth C. Laudon','Jane P. Laudon');

-- Fundamentals of Database Systems (Elmasri & Navathe)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-608620-8' AND a.name IN ('Elmasri','Navathe');

-- Computer Networks (Tanenbaum)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-13-212695-3' AND a.name IN ('Andrew S. Tanenbaum');

-- Engenharia de Software (Pressman)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-85-352-0001-0' AND a.name IN ('Roger S. Pressman');

-- Operating System Concepts (Silberschatz et al.)
INSERT INTO book_author (book_id, author_id)
SELECT b.book_id, a.author_id FROM book b, author a
WHERE b.isbn='978-0-470-12872-5' AND a.name IN ('Abraham Silberschatz');

-- Exemplares (cópias) — alguns livros ficarão sem exemplar de propósito
INSERT INTO exemplar (book_id, copy_code, location, notes)
SELECT b.book_id, 'EX-CLRS-001', 'E3-P2', 'Capa gasta' FROM book b WHERE b.isbn='978-0-262-03384-8';
INSERT INTO exemplar (book_id, copy_code, location, notes)
SELECT b.book_id, 'EX-CLRS-002', 'E3-P2', 'Novo'      FROM book b WHERE b.isbn='978-0-262-03384-8';

INSERT INTO exemplar (book_id, copy_code, location) 
SELECT b.book_id, 'EX-DSC-001', 'E2-P4' FROM book b WHERE b.isbn='978-0-07-352332-3';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-MOS-001', 'E2-P1' FROM book b WHERE b.isbn='978-0-13-359162-0';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-DP-001', 'E4-P1' FROM book b WHERE b.isbn='978-0-201-63361-0';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-CC-001', 'E4-P2' FROM book b WHERE b.isbn='978-0-13-235088-4';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-REF-001', 'E4-P2' FROM book b WHERE b.isbn='978-0-201-48567-7';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-ADM-001', 'E1-P2' FROM book b WHERE b.isbn='978-85-407-0000-1';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-MKT-001', 'E1-P3' FROM book b WHERE b.isbn='978-0-13-385646-0';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-CONTI-001', 'E1-P4' FROM book b WHERE b.isbn='978-85-216-1234-5';

INSERT INTO exemplar (book_id, copy_code, location)
SELECT b.book_id, 'EX-CONTB-001', 'E1-P4' FROM book b WHERE b.isbn='978-85-300-0001-0';

-- (De propósito sem exemplar:)
-- 'Sistemas de Informação Gerenciais' e 'Fundamentals of Database Systems'

-- Alunos extras (para diversificar os JOINs)
INSERT INTO student (enrollment_no, full_name, email, course_id) VALUES
('2025005', 'Eduarda Nunes', 'eduarda@uni.edu', 2),
('2025006', 'Felipe Araujo', 'felipe@uni.edu', 1);

-- Perfis para alguns novos (outros sem perfil de propósito)
INSERT INTO student_profile (student_id, birthdate, phone) VALUES
((SELECT student_id FROM student WHERE enrollment_no='2025005'), '2001-09-12', '(45) 97777-0005');

-- Empréstimos adicionais
INSERT INTO loan (student_id, loan_date) VALUES
((SELECT student_id FROM student WHERE full_name='Carla Mendes'), '2025-08-08'), -- sem perfil
((SELECT student_id FROM student WHERE full_name='Daniel Pereira'), '2025-08-09'),
((SELECT student_id FROM student WHERE full_name='Eduarda Nunes'), '2025-08-10'),
((SELECT student_id FROM student WHERE full_name='Felipe Araujo'), '2025-08-11');

-- Itens dos novos empréstimos
-- Carla pega CLRS (um devolvido, outro ativo)
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date, return_date)
VALUES (
  (SELECT loan_id FROM loan l JOIN student s ON s.student_id=l.student_id WHERE s.full_name='Carla Mendes' ORDER BY l.loan_id DESC LIMIT 1),
  (SELECT exemplar_id FROM exemplar e JOIN book b ON b.book_id=e.book_id WHERE b.isbn='978-0-262-03384-8' AND copy_code='EX-CLRS-001'),
  '2025-08-22', '2025-08-15'
);

INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date)
VALUES (
  (SELECT loan_id FROM loan l JOIN student s ON s.student_id=l.student_id WHERE s.full_name='Carla Mendes' ORDER BY l.loan_id DESC LIMIT 1),
  (SELECT exemplar_id FROM exemplar e JOIN book b ON b.book_id=e.book_id WHERE b.isbn='978-0-262-03384-8' AND copy_code='EX-CLRS-002'),
  '2025-08-22'
);

-- Daniel pega Design Patterns (ativo)
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date)
VALUES (
  (SELECT loan_id FROM loan l JOIN student s ON s.student_id=l.student_id WHERE s.full_name='Daniel Pereira' ORDER BY l.loan_id DESC LIMIT 1),
  (SELECT exemplar_id FROM exemplar e JOIN book b ON b.book_id=e.book_id WHERE b.isbn='978-0-201-63361-0' AND copy_code='EX-DP-001'),
  '2025-08-25'
);

-- Eduarda pega Clean Code (ativo)
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date)
VALUES (
  (SELECT loan_id FROM loan l JOIN student s ON s.student_id=l.student_id WHERE s.full_name='Eduarda Nunes' ORDER BY l.loan_id DESC LIMIT 1),
  (SELECT exemplar_id FROM exemplar e JOIN book b ON b.book_id=e.book_id WHERE b.isbn='978-0-13-235088-4' AND copy_code='EX-CC-001'),
  '2025-08-26'
);

-- Felipe pega MOS (devolve) e depois DSC (ativo)
INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date, return_date)
VALUES (
  (SELECT loan_id FROM loan l JOIN student s ON s.student_id=l.student_id WHERE s.full_name='Felipe Araujo' ORDER BY l.loan_id DESC LIMIT 1),
  (SELECT exemplar_id FROM exemplar e JOIN book b ON b.book_id=e.book_id WHERE b.isbn='978-0-13-359162-0' AND copy_code='EX-MOS-001'),
  '2025-08-27', '2025-08-20'
);

INSERT INTO loan_item (loan_id, exemplar_id, expected_return_date)
VALUES (
  (SELECT loan_id FROM loan l JOIN student s ON s.student_id=l.student_id WHERE s.full_name='Felipe Araujo' ORDER BY l.loan_id DESC LIMIT 1),
  (SELECT exemplar_id FROM exemplar e JOIN book b ON b.book_id=e.book_id WHERE b.isbn='978-0-07-352332-3' AND copy_code='EX-DSC-001'),
  '2025-08-30'
);

-- Extra: um autor sem publicações já existe ("Autor Sem Publicações").
-- Extra: mantenho dois livros sem exemplar para LEFT/FULL JOIN:
--   "Sistemas de Informação Gerenciais" e "Fundamentals of Database Systems".

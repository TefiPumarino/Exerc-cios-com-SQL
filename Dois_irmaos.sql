-- Script de criação do Banco de Dados da empresa Dois Irmãos

CREATE DATABASE dois_irmaos

-----------------------------------------------
-- Criando as tabelas
-----------------------------------------------

CREATE TABLE Funcionario (
	id_fun INTEGER 
	, Nome VARCHAR(20)
	, Sobrenome VARCHAR(20)
	, DataNasc DATE
	, Cargo VARCHAR(40)
	, Salario INTEGER
	, Departamento INTEGER
)

CREATE TABLE Departamento (
	id_dep INTEGER 
	, Nome VARCHAR(20)
	, Locaal VARCHAR(20)
	, Func_Resp INTEGER
)


CREATE TABLE Projeto (
	id_proj INTEGER 
	, Descricao VARCHAR(100)
	, Func_Resp INTEGER
	, CH INTEGER
)

-----------------------------------------------
-- Adicionando chaves primárias 
-----------------------------------------------

ALTER TABLE Funcionario ADD PRIMARY KEY (id_fun);

ALTER TABLE Departamento ADD PRIMARY KEY (id_dep);

ALTER TABLE Projeto ADD PRIMARY KEY (id_proj);


-----------------------------------------------
-- Inserindo os dados nas tabelas
-----------------------------------------------

INSERT INTO Funcionario (id_fun, Nome, Sobrenome, DataNasc, Cargo, Salario, Departamento)
VALUES 
	(1001, 'Alberto', 'Silva', '1970-01-05', 'Supervisor', 5000, 102)
	, (1002, 'Silvia', 'Pires', '1985-05-13', 'Vendedor', 2500, 102)
	, (1003,'Mário', 'Oliveira','1970-11-20','Diretor',10000,104)
	, (1004,'Roberto', 'Albuquerque','1981-03-05','Supervisor',5300,101)
	, (1005,'Horácio','Almeida','1973-10-18','Gerente',8000,103)
	, (1006,'Fabiana','Rossi','1980-08-07','Gerente',8000,101)
	, (1007,'Maria','Silva','1979-03-07','Vendedor',2700,102)
	, (1008,'Joana','Pereira','1965-04-17','Supervisor',8000,103)
	, (1009,'Márcia','Sousa','1968-12-05','Gerente',8500,105)
	, (1010,'Antônio','Santos','1988-02-07','Programador',3500,105)

INSERT INTO Departamento (id_dep, Nome, Locaal, Func_Resp)
VALUES 
	(101, 'Administração', 'Matriz', 1006)
	, (102, 'Vendas', 'Filial', 1001)
	, (103, 'RH', 'Matriz', 1008)
	, (104, 'Diretoria', 'Matriz', 1003)
	, (105, 'CPD', 'Matriz', 1009)


INSERT INTO Projeto (id_proj, Descricao, Func_Resp, CH)
VALUES
	(1, 'Ampliação do setor de vendas', 1001, 100)
	, (2, 'Implantação do sistema de RH', 1009, 80)
	, (3, 'Auditoria interna', 1004, 120)


-----------------------------------------------
-- Adicionando chaves estrangeiras 
-----------------------------------------------

ALTER TABLE Funcionario 
ADD CONSTRAINT FK_Departamento 
FOREIGN KEY (Departamento) REFERENCES Departamento(id_dep);

ALTER TABLE Departamento 
ADD CONSTRAINT FK_Func_Resp 
FOREIGN KEY (Func_Resp) REFERENCES Funcionario(id_fun);

ALTER TABLE Projeto 
ADD CONSTRAINT FK_Func_Resp 
FOREIGN KEY (Func_Resp) REFERENCES Funcionario(id_fun);
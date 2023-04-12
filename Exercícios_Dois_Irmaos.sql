--------------------------------
-- Exercícios: PRIMEIRA PARTE
--------------------------------


-- Listar nome e sobrenome ordenado por sobrenome

SELECT Nome, Sobrenome
FROM Funcionario
ORDER BY Sobrenome

-- Listar todos os campos de funcionários ordenados por departamento

SELECT * 
FROM Funcionario
ORDER BY Departamento

-- Liste os funcionários que têm salário superior a R$ 5.000,00 
-- ordenados pelo nome completo

SELECT * 
FROM Funcionario
WHERE Salario > 5000
ORDER BY Nome || Sobrenome

-- Liste a data de nascimento e o primeiro nome 
-- dos funcionários ordenados do mais novo para o mais velho

SELECT DataNasc, Nome
FROM Funcionario
ORDER BY DataNasc DESC


-- Liste o total da folha de pagamento

SELECT SUM(Salario) AS TotalPagamento 
FROM Funcionario

-- Liste o nome, o nome do departamento e a função de todos os funcionários

SELECT F.Nome, F.Cargo, D.Nome AS Departamento
FROM Funcionario AS F
JOIN Departamento AS D ON F.Departamento = D.id_dep


-- Liste todos departamentos com seus respectivos responsáveis

SELECT D.Nome, F.Nome AS Responsavel
FROM Departamento AS D
JOIN Funcionario AS F ON D.Func_Resp = F.id_fun


-- Liste o valor da folha de pagamento de cada departamento (nome)

SELECT D.Nome, SUM(Salario) AS TotalFolha
FROM Funcionario AS F
JOIN Departamento AS D ON D.id_dep = F.Departamento
GROUP BY D.Nome


-- Liste os departamentos dos funcionários que têm a função de supervisor

SELECT D.Nome
FROM Funcionario AS F
JOIN Departamento AS D ON D.id_dep = F.Departamento
WHERE F.Cargo = 'Supervisor'


-- Liste a quantidade de funcionários desta empresa

SELECT COUNT(*) AS TotalFuncionarios
FROM Funcionario


-- Liste o salário médio pago pela empresa

SELECT ROUND(AVG(Salario), 2) AS SalarioMedio
FROM Funcionario

-- Liste o menor salário pago pela empresa em cada departamento

SELECT D.Nome, MIN(F.Salario) AS MenorSalario
FROM Funcionario AS F
JOIN Departamento AS D ON F.Departamento = D.id_dep
GROUP BY D.Nome


-- Liste o nome do departamento e do funcionário 
-- ordenados por departamento e funcionário

SELECT D.Nome AS Departamento, F.Nome AS Funcionario
FROM Departamento AS D
JOIN Funcionario AS F ON D.id_dep = F.Departamento
ORDER BY D.Nome, F.Nome


-- Liste os nomes dos funcionários que trabalham no Recursos Humanos

SELECT Nome
FROM Funcionario
WHERE Departamento = 103 -- RH


-- Liste os projetos e os nomes dos responsáveis

SELECT PR.Descricao, F.Nome
FROM Projeto AS PR
JOIN Funcionario AS F ON F.id_fun = PR.Func_Resp

--------------------------------
-- Exercícios: SEGUNDA PARTE
--------------------------------

-- ● Responda as perguntas a seguir:

-- Qual o comando para aumentar o salário dos funcionários que 
-- sejam do setor de Vendas, e que não sejam chefe do setor, em 5%?


UPDATE Funcionario
SET Salario = Salario * 1,05 
WHERE Cargo <> 'Supervisor'


-- Qual o comando para alterar o número de horas previstas para 100 h, do projeto
-- “Implantação do sistema de RH”?

UPDATE Projeto
SET CH = 100
WHERE Descricao = 'Implantação do sistema de RH'


-- Quais os comandos para mudar o cargo do funcionário "Antônio" Santos para
-- “Analista” e seu salário para 5000?

UPDATE Funcionario
SET Cargo = 'Analista'
	Salario = 5000
WHERE Nome = 'Antônio' AND Sobrenome = 'Santos'
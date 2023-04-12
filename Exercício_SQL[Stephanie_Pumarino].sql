----------------------------------------------------------------
-- Importando a base de dados
----------------------------------------------------------------

CREATE TABLE base_case (
	PERIODO VARCHAR(10)
	, Quantidade INT
	, Montadora VARCHAR(10)
	, Canal VARCHAR(10)
	, Estado CHAR(2)
	, Categoria VARCHAR(20)
	, Custo DECIMAL(10,2)
	, Vistoria_no_prazo INT
	, Vistoria_fora_do_prazo INT
	, FLAG_FORNECIDO CHAR(3)
	, QTD_PECAS_TOTAL INT
	, QTD_PCS_FORNECIDAS INT
)


COPY base_case
FROM 'C:\Users\Public\Base_Case_2.csv'
CSV
DELIMITER ';'
HEADER

----------------------------------------------------------------
-- Analisando custos glogalmente
----------------------------------------------------------------

SELECT flag_fornecido, COUNT(flag_fornecido), 100.0*COUNT(flag_fornecido)/SUM(COUNT(flag_fornecido)) OVER() AS percentual_flags
-- 100.0*COUNT(flag_fornecido)/SUM(COUNT(flag_fornecido)) OVER(): isso conta a distribuição percentual (nomalize = true)
FROM base_case
GROUP BY flag_fornecido

-- Temos 12917/22399 = 58% de flag_fornecido = 'NAO'

SELECT flag_fornecido, qtd_pcs_fornecidas 
FROM base_case
WHERE flag_fornecido = 'NAO' AND qtd_pcs_fornecidas isnull

-- Acima é possível verificar que somente para flag_fornecido = 'NAO' temos qtd_pcs_fornecidas isnull

SELECT *
FROM base_case
WHERE Custo < 0

-- Acima é possível verificar que há dois registros, que totalizam 6 sinistros, em que o custo do reparo é negativo, porém não é claro o motivo. 
-- Vou ignorar estes dois valores. 

SELECT SUM(Custo)/SUM(QTD_PECAS_TOTAL) AS custo_medio_peca
FROM base_case
WHERE Custo >= 0

-- Custo médio da peça: 656.7

SELECT flag_fornecido, SUM(QTD_PECAS_TOTAL) AS qts_pcs, SUM(Custo)/SUM(QTD_PECAS_TOTAL) AS custo_medio_peca
FROM base_case
WHERE Custo >= 0 
GROUP BY flag_fornecido

-- Com o código acima podemos ver que há uma diferença no custo de reparo quando há peças fornecidas
-- Se flag_fornecido = 'SIM', são 1_234_663 de peças totais registradas nos casos em que houve fornecimento, então o custo médio da peça é 505,8
-- Se flag_fornecido = 'NAO', são 1_930_967 de peças totais registradas nos casos em que não houve fornecimento, então o custo médio da peça é 753,3 (aproximadamente 50% mais caro)

SELECT 100.0 * SUM(QTD_PCS_FORNECIDAS)/SUM(QTD_PECAS_TOTAL) AS percenual_geral_pcs_fornecidas
FROM base_case
WHERE flag_fornecido = 'SIM' 

-- Quando há fornecimento, 66% das peças utilizadas são fornecidas pela seguradora


SELECT CASE 
		WHEN 1.0 * QTD_PCS_FORNECIDAS/QTD_PECAS_TOTAL >= 0.75 THEN '1: acima de 75%'
		WHEN 1.0 * QTD_PCS_FORNECIDAS/QTD_PECAS_TOTAL >= 0.50 THEN '2: entre 50 e 75%'
		WHEN 1.0 * QTD_PCS_FORNECIDAS/QTD_PECAS_TOTAL >= 0.25 THEN '3: entre 50 e 75%'
		ELSE '4: entre 0 e 25%'
		END AS ditribuicao
	, COUNT(*)/SUM(COUNT(*)) OVER() AS Percentual
FROM base_case
WHERE flag_fornecido = 'SIM' 
GROUP BY 
	CASE 
		WHEN 1.0 * QTD_PCS_FORNECIDAS/QTD_PECAS_TOTAL >= 0.75 THEN '1: acima de 75%'
		WHEN 1.0 * QTD_PCS_FORNECIDAS/QTD_PECAS_TOTAL >= 0.50 THEN '2: entre 50 e 75%'
		WHEN 1.0 * QTD_PCS_FORNECIDAS/QTD_PECAS_TOTAL >= 0.25 THEN '3: entre 50 e 75%'
		ELSE '4: entre 0 e 25%'
		END
ORDER BY ditribuicao

-- Olhando para  abse de dados em que os sinistros estão agregados, temos que: 

-- 3973 de 9482 tem acima de 75% das peças fornecidas: 41,9% dos casos
-- 4120 de 9482 tem entre 50 e 75% das peças fornecidas: 43,5% dos casos
-- 1108 de 9482 tem entre 25 e 50% das peças fornecidas: 11,7% dos casos
-- 275 de 9482 tem abaixo de 25% das peças fornecidas: 2,3% dos casos

-- Portanto, em 85% dos casos em que há fornecimento de peças, mais da metade das peças usadas são fornecidas pela seg. 



----------------------------------------------------------------
-- Analisando custos localmente
----------------------------------------------------------------

SELECT Estado, SUM(Custo)/SUM(QTD_PECAS_TOTAL) AS Custos_por_regiao
FROM base_case
WHERE Custo > 0
GROUP BY Estado
ORDER BY Custos_por_regiao DESC

-- AP tem um custo médio por peça discrepante: 833

SELECT Estado, flag_fornecido, SUM(Custo)/SUM(QTD_PECAS_TOTAL) AS Custos_por_regiao
FROM base_case
WHERE Custo > 0
GROUP BY Estado, flag_fornecido
ORDER BY estado, flag_fornecido

-- AP não teve fornecimento de peças

SELECT Estado, 
	SUM(Custo)/SUM(quantidade) AS custo_medio_sinistro_por_regiao
FROM base_case
WHERE Custo > 0
GROUP BY Estado
ORDER BY custo_medio_sinistro_por_regiao DESC

-- Acima vemos que na região norte e nordeste estão os estados que apresentam maior custo por sinistro

SELECT Estado, 100.0 * SUM(QTD_PCS_FORNECIDAS)/SUM(QTD_PECAS_TOTAL) AS porcentagem_pcs_fornecidas
FROM base_case
-- WHERE flag_fornecido = 'SIM' 
GROUP BY Estado
ORDER BY porcentagem_pcs_fornecidas DESC


--------------------------------------------------------


-- CRUZAR FORNECIMENTO DE PEÇAS COM VISTORIA A SEGUIR::

SELECT sum(quantidade)
FROM base_case

-- São 232_325 sinistros

SELECT SUM(vistoria_fora_do_prazo) AS total_vistoria_fora_do_prazo,
		SUM(vistoria_no_prazo) AS total_vistoria_no_prazo
FROM base_case

-- São 20_918 vistorias feitas fora do prazo e 550_218 vistorias feitas no prazo. 
-- Portanto temos 571_136 vistorias feitas das quais 96% são feitas no prazo. 


SELECT flag_fornecido, SUM(vistoria_fora_do_prazo) AS total_vistoria_fora_do_prazo
FROM base_case
GROUP BY flag_fornecido
ORDER BY SUM(vistoria_fora_do_prazo) DESC

-- Se a vistoria é feita fora do prazo, há uma probabilidade de 65% de não haver fornecimento de peças.

SELECT flag_fornecido, SUM(vistoria_no_prazo) AS total_vistoria_no_prazo
FROM base_case
GROUP BY flag_fornecido
ORDER BY SUM(vistoria_no_prazo) DESC

-- Se a vistoria é feita no prazo, há uma probabilidade de 51% de não haver fornecimento de peças.

-----------------------------------------------------------------
-- Analisando canais de comunicação
-----------------------------------------------------------------

SELECT canal, SUM(quantidade), 100.0*SUM(quantidade)/SUM(SUM(quantidade)) OVER() AS percentual
FROM base_case
GROUP BY canal
ORDER BY SUM(quantidade) DESC

-- O canal 1 concentra mais da metade dos cominicados de sinistros

SELECT canal, flag_fornecido, 
		SUM(quantidade), 100.0*SUM(quantidade)/SUM(SUM(quantidade)) OVER(PARTITION BY canal) AS percentual
FROM base_case
GROUP BY canal, flag_fornecido
ORDER BY canal, flag_fornecido

-- O canal 4 gera um maior fornecimento de peças em mais da metade dos casos: 56%
-- O canal 3 gera pouco fornecimento de peças: 26%

SELECT canal, SUM(vistoria_no_prazo) 
FROM base_case
GROUP BY canal
ORDER BY SUM(vistoria_no_prazo) DESC

-- O canal 1 tem mais vistorias no prazo: 304_751. É o tripo da segunda colocada: canal 4 com 100_321
-- O canal 3 tem 48_479 vistorias no prazo 

---------------------------------------------------------------------
Respondendo a mais duas perguntas específicas
---------------------------------------------------------------------

SELECT canal, SUM(quantidade), 100.0*SUM(quantidade)/SUM(SUM(quantidade)) OVER() AS percentual
FROM base_case
GROUP BY canal
ORDER BY SUM(quantidade) DESC

-- O canal 1 concentra mais da metade dos cominicados de sinistros

SELECT canal, flag_fornecido, 
		SUM(quantidade), 100.0*SUM(quantidade)/SUM(SUM(quantidade)) OVER(PARTITION BY canal) AS percentual
FROM base_case
GROUP BY canal, flag_fornecido
ORDER BY canal, flag_fornecido

-- O canal 4 gera um maior fornecimento de peças em mais da metade dos casos: 56%
-- O canal 3 gera pouco fornecimento de peças: 26%

SELECT canal, SUM(vistoria_no_prazo) 
FROM base_case
GROUP BY canal
ORDER BY SUM(vistoria_no_prazo) DESC

-- O canal 1 tem mais vistorias no prazo: 304_751. É o tripo da segunda colocada: canal 4 com 100_321
-- O canal 3 tem 48_479 vistorias no prazo 

-- ANALISANDO POR PERÍODOS

SELECT DISTINCT(PERIODO)
FROM base_case
ORDER BY PERIODO

-- o período analisado é 2020 e primeiro semestre e 2021
-- Portanto é necessária uma análise para o segundo semestre de 2021. 
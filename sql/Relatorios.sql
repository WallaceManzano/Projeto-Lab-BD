-- Rel1

CREATE OR REPLACE PROCEDURE cliente_cartao ( 
	p_nome PESSOA_DUP.NOME%TYPE, prc out sys_refcursor) IS
	
BEGIN
    IF p_nome IS NOT NULL THEN
    OPEN prc FOR SELECT NOME, EMAIL, 
		DATA_VENDA AS "ÚLTIMA VENDA PARA O CLIENTE",
		CARTAO_TIPO AS "TIPO DO CARTÃO", 
		CARTAO_NUMERO AS "NÚMERO DO CARTÃO",
		CARTAO_VALIDADE_MES AS "MÊS DE VALIDADE DO CARTÃO", 
		CARTAO_VALIDADE_ANO AS "ANO DE VALIDADE DO CARTÃO"
        
		FROM VENDA_DUP JOIN CLIENTE_DUP USING(ID_CLIENTE) JOIN PESSOA_DUP USING(ID_PESSOA)
		
		WHERE (CARTAO_VALIDADE_ANO < to_number(to_char(sysdate, 'YYYY')) 
            OR (CARTAO_VALIDADE_ANO = to_number(to_char(sysdate, 'YYYY')) AND
            CARTAO_VALIDADE_MES < to_number(to_char(sysdate, 'MM')))) AND
            
			DATA_VENDA = (SELECT DATA_VENDA 
				FROM (SELECT VENDA_DUP.ID_CLIENTE, VENDA_DUP.DATA_VENDA, RANK() 
                    OVER (PARTITION BY VENDA_DUP.ID_CLIENTE ORDER BY DATA_VENDA DESC) rnk
				
                    FROM VENDA_DUP JOIN CLIENTE_DUP ON(VENDA_DUP.ID_CLIENTE = CLIENTE_DUP.ID_CLIENTE) JOIN PESSOA_DUP USING(ID_PESSOA)
                    WHERE PESSOA_DUP.NOME = p_nome)
				WHERE rnk = 1 AND NOME = p_nome);
    END IF;
    IF p_nome IS NULL THEN
        OPEN prc FOR SELECT NOME, EMAIL,
        DATA_VENDA AS "DATA DA ÚLTIMA VENDA",
		CARTAO_TIPO AS "TIPO DO CARTÃO", 
		CARTAO_NUMERO AS "NÚMERO DO CARTÃO",
		CARTAO_VALIDADE_MES AS "MÊS DE VALIDADE DO CARTÃO",
		CARTAO_VALIDADE_ANO AS "ANO DE VALIDADE DO CARTÃO"
        FROM (SELECT VENDA_DUP.ID_CLIENTE, DATA_VENDA, NOME, EMAIL, CARTAO_TIPO,
            CARTAO_NUMERO, CARTAO_VALIDADE_MES, CARTAO_VALIDADE_ANO,
            RANK() OVER (PARTITION BY VENDA_DUP.ID_CLIENTE ORDER BY DATA_VENDA DESC) rnk
				
            FROM VENDA_DUP JOIN CLIENTE_DUP ON(VENDA_DUP.ID_CLIENTE = CLIENTE_DUP.ID_CLIENTE) JOIN PESSOA_DUP USING(ID_PESSOA))
        WHERE rnk = 1 AND (CARTAO_VALIDADE_ANO < to_number(to_char(sysdate, 'YYYY')) 
            OR (CARTAO_VALIDADE_ANO = to_number(to_char(sysdate, 'YYYY')) AND
            CARTAO_VALIDADE_MES < to_number(to_char(sysdate, 'MM'))));
    END IF;  
END cliente_cartao;

-- Rel2

/
CREATE OR REPLACE PROCEDURE historico_funcionarios ( 
	p_nome PESSOA_DUP.NOME%TYPE, p_depart DEPARTAMENTO_DUP.NOME%TYPE, prc out sys_refcursor) IS

	e_inexiste EXCEPTION;
	
BEGIN
	IF p_nome IS NOT NULL THEN
        OPEN prc FOR SELECT P.NOME AS "NOME DO FUNCIONÁRIO",
            D.NOME AS "NOME DO DEPARTAMENTO",
            H.TURNO AS "TURNO DE TRABALHO",
            H.DATA_ENTRADA AS "DATA DE ENTRADA",
            H.DATA_SAIDA AS "DATA DE SAÍDA",
            (CASE WHEN H.DATA_SAIDA IS NULL THEN 'Ativo' END) AS "STATUS"
	
        FROM DEPARTAMENTO_DUP D 
            JOIN HISTORICODEPARTAMENTO_DUP H ON(H.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO)
            JOIN EMPREGADO_DUP E ON(E.ID_PESSOA = H.ID_PESSOA) 
            JOIN PESSOA_DUP P ON(P.ID_PESSOA = E.ID_PESSOA)	
        WHERE
            p_nome = P.NOME;
	
	ELSIF p_depart IS NOT NULL THEN
		OPEN prc FOR SELECT P.NOME AS "NOME DO FUNCIONÁRIO",
			D.NOME AS "NOME DO DEPARTAMENTO",
			H.TURNO AS "TURNO DE TRABALHO",
			H.DATA_ENTRADA AS "DATA DE ENTRADA",
			H.DATA_SAIDA AS "DATA DE SAÍDA",
			(CASE WHEN H.DATA_SAIDA IS NULL THEN 'Ativo' END) AS "STATUS"
	
		FROM DEPARTAMENTO_DUP D 
            JOIN HISTORICODEPARTAMENTO_DUP H ON(H.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO)
            JOIN EMPREGADO_DUP E ON(E.ID_PESSOA = H.ID_PESSOA) 
            JOIN PESSOA_DUP P ON(P.ID_PESSOA = E.ID_PESSOA)	
		WHERE 
			p_depart = D.NOME;
			
	ELSE 
		OPEN prc FOR SELECT P.NOME AS "NOME DO FUNCIONÁRIO",
			D.NOME AS "NOME DO DEPARTAMENTO",
			H.TURNO AS "TURNO DE TRABALHO",
			H.DATA_ENTRADA AS "DATA DE ENTRADA",
			H.DATA_SAIDA AS "DATA DE SAÍDA",
			(CASE WHEN H.DATA_SAIDA IS NULL THEN 'Ativo' END) AS "STATUS"
	
		FROM DEPARTAMENTO_DUP D 
            JOIN HISTORICODEPARTAMENTO_DUP H ON(H.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO)
            JOIN EMPREGADO_DUP E ON(E.ID_PESSOA = H.ID_PESSOA) 
            JOIN PESSOA_DUP P ON(P.ID_PESSOA = E.ID_PESSOA)	
		WHERE P.ID_PESSOA = E.ID_PESSOA AND
			E.ID_PESSOA = H.ID_PESSOA AND
			H.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO;
			
	END IF;
END historico_funcionarios;

-- Rel3
/
CREATE OR REPLACE PROCEDURE dados_frete ( 
	p_ano number, prc out sys_refcursor) IS
	
BEGIN
	IF p_ano IS NOT NULL THEN
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') as "Ano",
        SUM(VALOR_FRETE) AS "TOTAL DE FRETE COBRADO NO ANO",
        SUM(CASE WHEN TOTAL > 2000 THEN VALOR_FRETE ELSE 0 END)
        AS "TOTAL FRETE VENDAS > 2000",
        SUM(CASE WHEN TOTAL <= 2000 THEN VALOR_FRETE ELSE 0 END)
        AS "TOTAL FRETE VENDAS <= 2000"
    
        FROM VENDA_DUP
    
        WHERE p_ano = to_number(to_char(DATA_VENDA, 'YYYY'))
        
        GROUP BY to_char(DATA_VENDA, 'YYYY');
	ELSE 
		OPEN prc FOR SELECT  to_char(DATA_VENDA, 'YYYY') as "Ano", 
        SUM(VALOR_FRETE) AS "TOTAL DE FRETE COBRADO NO ANO",
        SUM(CASE WHEN TOTAL > 2000 THEN VALOR_FRETE ELSE 0 END)
        AS "TOTAL FRETE VENDAS > 2000",
        SUM(CASE WHEN TOTAL <= 2000 THEN VALOR_FRETE ELSE 0 END)
        AS "TOTAL FRETE VENDAS <= 2000"
        
        FROM VENDA_DUP
        
        GROUP BY to_char(DATA_VENDA, 'YYYY');
			
	END IF;
END dados_frete;
/

-- Rel4

CREATE OR REPLACE PROCEDURE vendas_ano ( 
	p_ano number, prc out sys_refcursor) IS
    
    v_ano_anterior number := to_number(p_ano) - 1; 
    v_ano_anterior_str varchar2(10) := to_char(v_ano_anterior);
	
BEGIN
	IF p_ano IS NOT NULL THEN
		OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') AS "ANO",
			to_char(DATA_VENDA, 'MM') AS "MÊS",
			SUM(TOTAL) AS "TOTAL VENDIDO NO MÊS",
			MEDIA AS "MÉDIA DE VENDA NO ANO",
			100 * (((SELECT SUM(TOTAL) FROM VENDA_DUP V2
				WHERE to_char(V2.DATA_VENDA, 'YYYY') = p_ano
                AND to_char(V2.DATA_VENDA, 'MM') = to_char(V1.DATA_VENDA, 'MM')) - 
				
				(SELECT SUM(TOTAL) FROM VENDA_DUP V2
				WHERE to_char(V2.DATA_VENDA, 'YYYY') = v_ano_anterior_str
                AND to_char(V2.DATA_VENDA, 'MM') = to_char(V1.DATA_VENDA, 'MM'))) /
				
				(SELECT SUM(TOTAL) FROM VENDA_DUP V2
				WHERE to_char(V2.DATA_VENDA, 'YYYY') = v_ano_anterior_str
                AND to_char(V2.DATA_VENDA, 'MM') = to_char(V1.DATA_VENDA, 'MM'))) AS
				"AUMENTO AO MES/ANO ANTERIOR %"
    
        FROM VENDA_DUP V1,
        (SELECT AVG(TOTAL) AS "MEDIA"
            
            FROM VENDA_DUP
            
            WHERE to_char(DATA_VENDA, 'YYYY') = p_ano
            
            GROUP BY to_char(DATA_VENDA, 'YYYY')
        )

        WHERE to_char(DATA_VENDA, 'YYYY') = p_ano
        GROUP BY to_char(DATA_VENDA, 'YYYY'), to_char(DATA_VENDA, 'MM'), MEDIA
        ORDER BY to_char(DATA_VENDA, 'YYYY'), to_char(DATA_VENDA, 'MM');
    ELSE
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') AS "ANO",
			to_char(DATA_VENDA, 'MM') AS "MÊS",
			SUM(TOTAL) AS "TOTAL VENDIDO NO MÊS"

		FROM VENDA_DUP
        
        GROUP BY to_char(DATA_VENDA, 'YYYY'), to_char(DATA_VENDA, 'MM')
        ORDER BY to_char(DATA_VENDA, 'YYYY'), to_char(DATA_VENDA, 'MM');
		
	END IF;
END vendas_ano;



-- Rel5

CREATE OR REPLACE PROCEDURE produtos_semestre (
    p_ano number, p_semestre number, prc out sys_refcursor) IS
    e_inexiste EXCEPTION;
BEGIN
	IF p_ano < 0 OR p_ano > 9999 THEN
		RAISE e_inexiste;
	END IF;
	
	IF p_semestre <= 0 OR p_semestre > 2 THEN
		RAISE e_inexiste;
	END IF;
	
    IF p_ano IS NOT NULL THEN
        IF p_semestre IS NOT NULL AND to_number(p_semestre) = 1 THEN
            OPEN prc FOR SELECT * FROM (
                SELECT P.NOME AS "NOME DO PRODUTO",
                PRECO AS "PREÇO DO PRODUTO", 
                PESO AS "PESO DO PRODUTO", 
                C.NOME AS "CATEGORIA DO PRODUTO",
                TRUNC(SUM(V.TOTAL) / PRECO) AS "QUANTIDADE VENDIDA NO PERIODO"
	
                FROM PRODUTO_DUP P, CATEGORIA_DUP C, SUBCATEGORIA_DUP S, VENDA_DUP V, ITEMVENDA_DUP
	
                WHERE V.ID_VENDA = ITEMVENDA_DUP.ID_VENDA AND 
                    ITEMVENDA_DUP.ID_PRODUTO = P.ID_PRODUTO AND
                    P.ID_SUBCATEGORIA = S.ID_SUBCATEGORIA AND
                    S.ID_CATEGORIA = C.ID_CATEGORIA AND
                    to_char(DATA_VENDA, 'YYYY') = to_char(p_ano) AND
                    to_number(to_char(DATA_VENDA, 'MM')) <= 6
            
                GROUP BY P.NOME, PRECO, PESO, C.NOME
                ORDER BY TRUNC(SUM(V.TOTAL) / PRECO) DESC
            ) WHERE rownum <= 15;
        ELSIF p_semestre IS NOT NULL AND to_number(p_semestre) = 2 THEN
            OPEN prc FOR SELECT * FROM (
                SELECT P.NOME AS "NOME DO PRODUTO",
                PRECO AS "PREÇO DO PRODUTO", 
                PESO AS "PESO DO PRODUTO", 
                C.NOME AS "CATEGORIA DO PRODUTO",
                TRUNC(SUM(V.TOTAL) / PRECO) AS "QUANTIDADE VENDIDA NO PERIODO"
	
                FROM PRODUTO_DUP P, CATEGORIA_DUP C, SUBCATEGORIA_DUP S, VENDA_DUP V, ITEMVENDA_DUP
	
                WHERE V.ID_VENDA = ITEMVENDA_DUP.ID_VENDA AND 
                    ITEMVENDA_DUP.ID_PRODUTO = P.ID_PRODUTO AND
                    P.ID_SUBCATEGORIA = S.ID_SUBCATEGORIA AND
                    S.ID_CATEGORIA = C.ID_CATEGORIA AND
                    to_char(DATA_VENDA, 'YYYY') = to_char(p_ano) AND
                    to_number(to_char(DATA_VENDA, 'MM')) > 6
            
                GROUP BY P.NOME, PRECO, PESO, C.NOME
                ORDER BY TRUNC(SUM(V.TOTAL) / PRECO) DESC
            ) WHERE rownum <= 15;
        ELSE
            OPEN prc FOR SELECT * FROM (
                SELECT P.NOME AS "NOME DO PRODUTO",
                PRECO AS "PREÇO DO PRODUTO", 
                PESO AS "PESO DO PRODUTO", 
                C.NOME AS "CATEGORIA DO PRODUTO",
                TRUNC(SUM(V.TOTAL) / PRECO) AS "QUANTIDADE VENDIDA NO PERIODO"
	
                FROM PRODUTO_DUP P, CATEGORIA_DUP C, SUBCATEGORIA_DUP S, VENDA_DUP V, ITEMVENDA_DUP
	
                WHERE V.ID_VENDA = ITEMVENDA_DUP.ID_VENDA AND 
                    ITEMVENDA_DUP.ID_PRODUTO = P.ID_PRODUTO AND
                    P.ID_SUBCATEGORIA = S.ID_SUBCATEGORIA AND
                    S.ID_CATEGORIA = C.ID_CATEGORIA AND
                    to_char(DATA_VENDA, 'YYYY') = to_char(p_ano)
            
                GROUP BY P.NOME, PRECO, PESO, C.NOME
                ORDER BY TRUNC(SUM(V.TOTAL) / PRECO) DESC
            ) WHERE rownum <= 15;
        END IF;
    ELSIF p_ano IS NULL THEN
        OPEN prc FOR SELECT * FROM (
                SELECT P.NOME AS "NOME DO PRODUTO",
                PRECO AS "PREÇO DO PRODUTO", 
                PESO AS "PESO DO PRODUTO", 
                C.NOME AS "CATEGORIA DO PRODUTO",
                TRUNC(SUM(V.TOTAL) / PRECO) AS "QUANTIDADE VENDIDA NO PERIODO"
	
                FROM PRODUTO_DUP P, CATEGORIA_DUP C, SUBCATEGORIA_DUP S, VENDA_DUP V, ITEMVENDA_DUP
	
                WHERE V.ID_VENDA = ITEMVENDA_DUP.ID_VENDA AND 
                    ITEMVENDA_DUP.ID_PRODUTO = P.ID_PRODUTO AND
                    P.ID_SUBCATEGORIA = S.ID_SUBCATEGORIA AND
                    S.ID_CATEGORIA = C.ID_CATEGORIA
            
                GROUP BY P.NOME, PRECO, PESO, C.NOME
                ORDER BY TRUNC(SUM(V.TOTAL) / PRECO) DESC
            ) WHERE rownum <= 15;
    END IF;
EXCEPTION WHEN e_inexiste
	THEN raise_application_error(-20001, 'Ano ou semestre não existe!');
END produtos_semestre;



-- Rel7


CREATE OR REPLACE PROCEDURE vendas_por_pais (
    p_ano number, prc out sys_refcursor) IS
    e_inexiste EXCEPTION;
BEGIN
	IF p_ano IS NULL THEN
        OPEN prc FOR SELECT * FROM(SELECT * FROM (SELECT PAIS AS "NOME DO PAÍS",
            SUM(TOTAL) AS "TOTAL VENDIDO NO PAÍS GERAL",
            SUM(CASE WHEN to_number(to_char(DATA_VENDA, 'YYYY')) = 
                    (to_number(to_char(SYSDATE, 'YYYY')) - 1) THEN TOTAL ELSE 0 END)
                    AS "TOTAL ÚLTIMO ANO NO PAÍS"
	
            FROM VENDA_DUP, CLIENTE_DUP, PESSOA_DUP, ENDERECO_DUP
    
            WHERE VENDA_DUP.ID_CLIENTE = CLIENTE_DUP.ID_CLIENTE AND
                CLIENTE_DUP.ID_PESSOA = PESSOA_DUP.ID_PESSOA AND 
                PESSOA_DUP.ID_ENDERECO = ENDERECO_DUP.ID_ENDERECO
            
            GROUP BY PAIS)
            ORDER BY "NOME DO PAÍS") JOIN (
        
        SELECT "NOME DO PAÍS", "ESTADO COM MAIS VENDAS", "TOTAL VENDIDO NO ESTADO",
        "TOTAL ANO PASSADO NO ESTADO" FROM (
            SELECT PAIS AS "NOME DO PAÍS", ESTADO AS "ESTADO COM MAIS VENDAS",
            "TOTAL VENDIDO NO ESTADO", "TOTAL ANO PASSADO NO ESTADO", ROW_NUMBER() 
            OVER (PARTITION BY PAIS ORDER BY "TOTAL VENDIDO NO ESTADO" DESC) AS RN
            FROM (SELECT PAIS, ESTADO,
                SUM(TOTAL) AS "TOTAL VENDIDO NO ESTADO",
                SUM(CASE WHEN to_number(to_char(DATA_VENDA, 'YYYY')) = 
                    (to_number(to_char(SYSDATE, 'YYYY')) - 1) THEN TOTAL ELSE 0 END)
                     AS "TOTAL ANO PASSADO NO ESTADO"
        
                FROM VENDA_DUP, ENDERECO_DUP, CLIENTE_DUP, PESSOA_DUP
		
                WHERE VENDA_DUP.ID_CLIENTE = CLIENTE_DUP.ID_CLIENTE AND
                    CLIENTE_DUP.ID_PESSOA = PESSOA_DUP.ID_PESSOA AND 
                    PESSOA_DUP.ID_ENDERECO = ENDERECO_DUP.ID_ENDERECO
        
                GROUP BY PAIS, ESTADO
                ORDER BY PAIS, SUM(TOTAL) DESC)
    ) WHERE RN = 1
    ORDER BY "NOME DO PAÍS") USING("NOME DO PAÍS");
    
    ELSE
        OPEN prc FOR SELECT * FROM(SELECT * FROM (SELECT PAIS AS "NOME DO PAÍS",
            SUM(TOTAL) AS "TOTAL VENDIDO NO PAÍS NO ANO",
            SUM(CASE WHEN to_number(to_char(DATA_VENDA, 'YYYY')) = 
                    (to_number(to_char(SYSDATE, 'YYYY')) - 1) THEN TOTAL ELSE 0 END)
                    AS "TOTAL ÚLTIMO ANO NO PAÍS"
	
            FROM VENDA_DUP, CLIENTE_DUP, PESSOA_DUP, ENDERECO_DUP
    
            WHERE VENDA_DUP.ID_CLIENTE = CLIENTE_DUP.ID_CLIENTE AND
                CLIENTE_DUP.ID_PESSOA = PESSOA_DUP.ID_PESSOA AND 
                PESSOA_DUP.ID_ENDERECO = ENDERECO_DUP.ID_ENDERECO AND
                to_number(to_char(DATA_VENDA, 'YYYY')) = p_ano
            
            GROUP BY PAIS)
            ORDER BY "NOME DO PAÍS") JOIN (
        
        SELECT "NOME DO PAÍS", "ESTADO COM MAIS VENDAS", "TOTAL VENDIDO NO ESTADO",
        "TOTAL ANO PASSADO NO ESTADO" FROM (
            SELECT PAIS AS "NOME DO PAÍS", ESTADO AS "ESTADO COM MAIS VENDAS",
            "TOTAL VENDIDO NO ESTADO", "TOTAL ANO PASSADO NO ESTADO", ROW_NUMBER() 
            OVER (PARTITION BY PAIS ORDER BY "TOTAL VENDIDO NO ESTADO" DESC) AS RN
            FROM (SELECT PAIS, ESTADO,
                SUM(TOTAL) AS "TOTAL VENDIDO NO ESTADO",
                SUM(CASE WHEN to_number(to_char(DATA_VENDA, 'YYYY')) = 
                    (to_number(to_char(SYSDATE, 'YYYY')) - 1) THEN TOTAL ELSE 0 END)
                     AS "TOTAL ANO PASSADO NO ESTADO"
        
                FROM VENDA_DUP, ENDERECO_DUP, CLIENTE_DUP, PESSOA_DUP
		
                WHERE VENDA_DUP.ID_CLIENTE = CLIENTE_DUP.ID_CLIENTE AND
                    CLIENTE_DUP.ID_PESSOA = PESSOA_DUP.ID_PESSOA AND 
                    PESSOA_DUP.ID_ENDERECO = ENDERECO_DUP.ID_ENDERECO AND
                    to_number(to_char(DATA_VENDA, 'YYYY')) = p_ano
        
                GROUP BY PAIS, ESTADO
                ORDER BY PAIS, SUM(TOTAL) DESC)
        ) WHERE RN = 1
        ORDER BY "NOME DO PAÍS") USING("NOME DO PAÍS");
        
    END IF;
END vendas_por_pais;

-- Teste das procedures

VAR x REFCURSOR;
EXEC dados_frete(null, :x);
PRINT x
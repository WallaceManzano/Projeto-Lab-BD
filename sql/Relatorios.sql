﻿-- Rel1

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

-- Teste das procedures

VAR x REFCURSOR;
EXEC dados_frete(null, :x);
PRINT x
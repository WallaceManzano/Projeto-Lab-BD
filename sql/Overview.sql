

CREATE OR REPLACE PROCEDURE rendimento_por_ano ( 
	inicio number, fim number, prc out sys_refcursor) IS
BEGIN
    IF inicio IS NULL AND fim IS NULL THEN
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') AS ANO, SUM(TOTAL) AS DIA FROM VENDA_DUP
            GROUP BY to_char(DATA_VENDA, 'YYYY')
            ORDER BY to_char(DATA_VENDA, 'YYYY');
    ELSIF inicio IS NULL THEN
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') AS ANO, SUM(TOTAL) AS DIA FROM VENDA_DUP
            WHERE to_number(to_char(DATA_VENDA, 'YYYY')) <= fim
            GROUP BY to_char(DATA_VENDA, 'YYYY')
            ORDER BY to_char(DATA_VENDA, 'YYYY');
    ELSIF fim IS NULL THEN
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') AS ANO, SUM(TOTAL) AS DIA FROM VENDA_DUP
            WHERE to_number(to_char(DATA_VENDA, 'YYYY')) >= inicio
            GROUP BY to_char(DATA_VENDA, 'YYYY')
            ORDER BY to_char(DATA_VENDA, 'YYYY');
    ELSE 
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'YYYY') AS ANO, SUM(TOTAL) AS DIA FROM VENDA_DUP
            WHERE to_number(to_char(DATA_VENDA, 'YYYY')) <= fim
            AND to_number(to_char(DATA_VENDA, 'YYYY')) >= inicio
            GROUP BY to_char(DATA_VENDA, 'YYYY')
            ORDER BY to_char(DATA_VENDA, 'YYYY');
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE rendimento_por_mes ( 
	ano number, prc out sys_refcursor) IS
BEGIN
    IF ano IS NULL THEN
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'MM') AS MES, SUM(TOTAL) AS DIA FROM VENDA_DUP
            WHERE to_char(DATA_VENDA, 'YYYY') = to_char(sysdate, 'YYYY')
            GROUP BY to_char(DATA_VENDA, 'MM')
            ORDER BY to_char(DATA_VENDA, 'MM');
    ELSE
        OPEN prc FOR SELECT to_char(DATA_VENDA, 'MM') AS MES, SUM(TOTAL) AS DIA FROM VENDA_DUP
            WHERE to_char(DATA_VENDA, 'YYYY') =  ano
            GROUP BY to_char(DATA_VENDA, 'MM')
            ORDER BY to_char(DATA_VENDA, 'MM');
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE top_produtos ( 
	prc out sys_refcursor) IS
BEGIN
    OPEN prc FOR SELECT PRODUTO_DUP.ID_PRODUTO AS "ID", PRODUTO_DUP.NOME AS "NOME", CATEGORIA_DUP.NOME AS "Categoria", 
    	SUBCATEGORIA_DUP.NOME AS "Subcategoria" , PRODUTO_DUP.PRECO AS "Preço Unitário", COUNT(*) AS "Quantidade Vendida"
        FROM ITEMVENDA_DUP 
        JOIN PRODUTO_DUP USING(ID_PRODUTO) 
        JOIN SUBCATEGORIA_DUP USING(ID_SUBCATEGORIA)
        JOIN CATEGORIA_DUP USING(ID_CATEGORIA)
        GROUP BY PRODUTO_DUP.NOME, PRODUTO_DUP.NUMERO_PRODUTO, CATEGORIA_DUP.NOME, SUBCATEGORIA_DUP.NOME
        ORDER BY PRODUTO_DUP.NOME;
END;

/
CREATE OR REPLACE PROCEDURE top_clients ( 
	ano number, prc out sys_refcursor) IS
BEGIN
    IF ano IS NULL THEN
        OPEN prc FOR SELECT P.NOME AS "Nome", P.EMAIL AS "Email", SUM(VE.TOTAL) AS "Total Comprado" FROM CLIENTE_DUP CL 
        JOIN PESSOA_DUP P ON (CL.ID_PESSOA = P.ID_PESSOA) 
        JOIN VENDA_DUP VE ON(CL.ID_CLIENTE = VE.ID_CLIENTE)
		WHERE EMAIL <> 'test@test.com'
        GROUP BY P.NOME, P.EMAIL
        ORDER BY SUM(VE.TOTAL) DESC;
    ELSE
        OPEN prc FOR SELECT P.NOME AS "Nome", P.EMAIL AS "Email", SUM(VE.TOTAL) AS "Total Comprado" FROM CLIENTE_DUP CL 
        JOIN PESSOA_DUP P ON (CL.ID_PESSOA = P.ID_PESSOA) 
        JOIN VENDA_DUP VE ON(CL.ID_CLIENTE = VE.ID_CLIENTE)
        WHERE to_char(VE.DATA_VENDA, 'YYYY') = ano
		AND EMAIL <> 'test@test.com'
        GROUP BY P.NOME, P.EMAIL
        ORDER BY SUM(VE.TOTAL) DESC;
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE top_funcionarios ( 
	mes number, ano number, prc out sys_refcursor) IS
BEGIN
    IF mes IS NULL and ano IS NULL THEN
        OPEN prc FOR SELECT P.NOME AS "Nome", E.FUNCAO AS "Função", SUM(VE.TOTAL) AS "Total Vendido" FROM EMPREGADO_DUP E 
        JOIN VENDEDOR_DUP V ON(E.ID_PESSOA = V.ID_PESSOA) 
        JOIN PESSOA_DUP P ON (E.ID_PESSOA = P.ID_PESSOA) 
        JOIN VENDA_DUP VE ON(P.ID_PESSOA = VE.ID_VENDEDOR)
        WHERE to_char(VE.DATA_VENDA, 'YYYY') = to_char(sysdate, 'YYYY')
        AND to_char(VE.DATA_VENDA, 'MM') = to_char(sysdate, 'MM')
        AND EMAIL <> 'test@test.com'
        GROUP BY P.NOME, E.FUNCAO
        ORDER BY SUM(VE.TOTAL) DESC;
    ELSIF ano IS NULL THEN
        OPEN prc FOR SELECT P.NOME AS "Nome", E.FUNCAO AS "Função", SUM(VE.TOTAL) AS "Total Vendido" FROM EMPREGADO_DUP E 
        JOIN VENDEDOR_DUP V ON(E.ID_PESSOA = V.ID_PESSOA) 
        JOIN PESSOA_DUP P ON (E.ID_PESSOA = P.ID_PESSOA) 
        JOIN VENDA_DUP VE ON(P.ID_PESSOA = VE.ID_VENDEDOR)
        WHERE to_char(VE.DATA_VENDA, 'YYYY') = to_char(sysdate, 'YYYY')
        AND to_char(VE.DATA_VENDA, 'MM') = mes
        AND EMAIL <> 'test@test.com'
        GROUP BY P.NOME, E.FUNCAO
        ORDER BY SUM(VE.TOTAL) DESC;
    ELSIF mes IS NULL THEN
        OPEN prc FOR SELECT P.NOME AS "Nome", E.FUNCAO AS "Função", SUM(VE.TOTAL) AS "Total Vendido" FROM EMPREGADO_DUP E 
        JOIN VENDEDOR_DUP V ON(E.ID_PESSOA = V.ID_PESSOA) 
        JOIN PESSOA_DUP P ON (E.ID_PESSOA = P.ID_PESSOA) 
        JOIN VENDA_DUP VE ON(P.ID_PESSOA = VE.ID_VENDEDOR)
        WHERE to_char(VE.DATA_VENDA, 'YYYY') = ano
        AND to_char(VE.DATA_VENDA, 'MM') = to_char(sysdate, 'MM')
        AND EMAIL <> 'test@test.com'
        GROUP BY P.NOME, E.FUNCAO
        ORDER BY SUM(VE.TOTAL) DESC;
    ELSE 
        OPEN prc FOR SELECT P.NOME AS "Nome", E.FUNCAO AS "Função", SUM(VE.TOTAL) AS "Total Vendido" FROM EMPREGADO_DUP E 
        JOIN VENDEDOR_DUP V ON(E.ID_PESSOA = V.ID_PESSOA) 
        JOIN PESSOA_DUP P ON (E.ID_PESSOA = P.ID_PESSOA) 
        JOIN VENDA_DUP VE ON(P.ID_PESSOA = VE.ID_VENDEDOR)
        WHERE to_char(VE.DATA_VENDA, 'YYYY') = ano
        AND to_char(VE.DATA_VENDA, 'MM') = mes
        AND EMAIL <> 'test@test.com'
        GROUP BY P.NOME, E.FUNCAO
        ORDER BY SUM(VE.TOTAL) DESC;
    END IF;
END;

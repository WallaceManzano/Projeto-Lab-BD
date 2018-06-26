INSERT INTO PESSOA VALUES(9746, 'Test WC-20', rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('test'))), 'test@test.com', 1);
INSERT INTO EMPREGADO VALUES(9746, 123, 'Production Technician - WC20', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'), 'adventure-works\testWC20',
    'S', 'M', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'));


INSERT INTO PESSOA VALUES(9747, 'Test Stocker', rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('test'))), 'test@test.com', 1);
INSERT INTO EMPREGADO VALUES(9747, 1234, 'Stocker', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'), 'adventure-works\testS',
    'S', 'M', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'));


INSERT INTO PESSOA VALUES(60000, 'Test Vendas', rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('test'))), 'test@test.com', 1);
INSERT INTO CLIENTE VALUES(60000, 60000, 'Cartão', 42, 10, 3000);
/

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
    OPEN prc FOR SELECT PRODUTO_DUP.NOME AS "NOME", CATEGORIA_DUP.NOME AS "Categoria", SUBCATEGORIA_DUP.NOME AS "Subcategoria" ,
        COUNT(*) AS "Quantidade Vendida"
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

/
CREATE OR REPLACE PROCEDURE DUP_BASE IS
    CURSOR C_Tables IS SELECT DISTINCT TABLE_NAME
        FROM ALL_TAB_COLUMNS
        WHERE OWNER = USER;
BEGIN 
    FOR V_Table IN C_Tables LOOP
        IF V_Table.TABLE_NAME NOT LIKE '%_DUP' THEN
            execute immediate 'CREATE TABLE ' || V_Table.TABLE_NAME || '_DUP AS SELECT * FROM ' || V_Table.TABLE_NAME;
        END IF;
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE TRUNCATE_DUP_BASE IS
    CURSOR C_Tables IS SELECT DISTINCT TABLE_NAME
        FROM ALL_TAB_COLUMNS
        WHERE OWNER = USER;
BEGIN 
    FOR V_Table IN C_Tables LOOP
        IF V_Table.TABLE_NAME NOT LIKE '%_DUP' THEN
            execute immediate 'TRUNCATE TABLE ' || V_Table.TABLE_NAME || '_DUP';
        END IF;
    END LOOP;
END;
/
DECLARE
    CURSOR C_VENDEDOR IS SELECT ID_PESSOA FROM VENDEDOR;
    n pls_integer;
    f pls_integer;
    i pls_integer;
    da varchar(50);
BEGIN
    i := 60000;
    FOR Ano IN 2013..2018 LOOP
        FOR M IN 1..12 LOOP 
            FOR D IN 1..28 LOOP 
                FOR V IN C_VENDEDOR LOOP
                    n := dbms_random.value(32131,432432);
                    f := dbms_random.value(1000,5000);
                    da := D || '-' || M || '-'|| Ano;
                    da := 'TO_DATE('''|| da ||''', ''DD-MM-YYYY'')';
                    execute immediate 'INSERT INTO VENDA VALUES(' || i || ', ' || 60000 || ', ' || V.ID_PESSOA || ', ' || da || ', ' 
                     || 'TO_DATE(''01-JAN-3000'', ''DD-MON-YYYY'')' || ', 1, 0, 42, TO_DATE(''01-JAN-3000'', ''DD-MON-YYYY''), ' || f || ', ' || n || ')';
                    i := i + 1;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/

DECLARE
    CURSOR C_VENDEDOR IS SELECT ID_PESSOA FROM VENDEDOR;
    CURSOR C_CLIENTE IS SELECT ID_CLIENTE FROM CLIENTE;
    V_CLIENTE C_CLIENTE%ROWTYPE;
    n pls_integer;
    f pls_integer;
    i pls_integer;
    j pls_integer;
    da varchar(50);
BEGIN
    i := 100000;
    FOR Ano IN 2018..2018 LOOP
        FOR M IN 5..8 LOOP 
            FOR D IN 1..28 LOOP 
                FOR V IN C_VENDEDOR LOOP
                    j := 0;
                    OPEN C_CLIENTE;
                    LOOP
                        FETCH C_CLIENTE INTO V_CLIENTE;
                        EXIT WHEN C_CLIENTE%NOTFOUND OR j > 30;
                        j := j + 1;
                        n := dbms_random.value(6000,30000);
                        f := dbms_random.value(1000,5000);
                        da := D || '-' || M || '-'|| Ano;
                        da := 'TO_DATE('''|| da ||''', ''DD-MM-YYYY'')';
                        execute immediate 'INSERT INTO VENDA VALUES(' || i || ', ' || V_CLIENTE.ID_CLIENTE || ', ' || V.ID_PESSOA || ', ' || da || ', ' 
                         || 'TO_DATE(''01-JAN-3000'', ''DD-MON-YYYY'')' || ', 1, 0, 42, TO_DATE(''01-JAN-3000'', ''DD-MON-YYYY''), ' || f || ', ' || n || ')';
                        i := i + 1;
                    END LOOP;
                    CLOSE C_CLIENTE;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;	
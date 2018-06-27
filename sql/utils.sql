INSERT INTO PESSOA VALUES(9746, 'Test WC-20', rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('test'))), 'test@test.com', 1);
INSERT INTO EMPREGADO VALUES(9746, 123, 'Production Technician - WC20', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'), 'adventure-works\testWC20',
    'S', 'M', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'));


INSERT INTO PESSOA VALUES(9747, 'Test Stocker', rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('test'))), 'test@test.com', 1);
INSERT INTO EMPREGADO VALUES(9747, 1234, 'Stocker', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'), 'adventure-works\testS',
    'S', 'M', TO_DATE('01-JAN-2000', 'DD-MON-YYYY'));


INSERT INTO PESSOA VALUES(60000, 'Test Vendas', rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('test'))), 'test@test.com', 1);
INSERT INTO CLIENTE VALUES(60000, 60000, 'Cartão', 42, 10, 3000);

CREATE OR REPLACE VIEW DADOS_PRODUTO AS (
    SELECT P1.ID_PRODUTO, P1.NOME AS P_NOME, C1.NOME AS C_NOME, SC1.NOME AS SC_NOME
        FROM PRODUTO_DUP P1
        JOIN SUBCATEGORIA_DUP SC1 ON(P1.ID_SUBCATEGORIA = SC1.ID_SUBCATEGORIA)
        JOIN CATEGORIA_DUP C1 ON (SC1.ID_CATEGORIA = C1.ID_CATEGORIA));
/
CREATE OR REPLACE PROCEDURE DUP_BASE IS
    CURSOR C_Tables IS SELECT DISTINCT TABLE_NAME
        FROM ALL_TAB_COLUMNS
        WHERE OWNER = USER;
BEGIN 
    FOR V_Table IN C_Tables LOOP
        IF V_Table.TABLE_NAME NOT LIKE '%_DUP%' THEN
            execute immediate 'INSERT INTO ' || V_Table.TABLE_NAME || '_DUP VALUE SELECT * FROM ' || V_Table.TABLE_NAME;
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
        IF V_Table.TABLE_NAME NOT LIKE '%_DUP%' THEN
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
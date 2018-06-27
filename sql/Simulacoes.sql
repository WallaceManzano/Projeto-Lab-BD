-- Sim 1
-- v_tipo_de_alteracao é 0 para valor e 1 para porcentagem
-- v_alteracao é um posivo ou negativo que poderá ser o valor da alteração ou a porcentagem (v_alteracao%)
CREATE OR REPLACE PROCEDURE produto_altera_preco (
    v_id_produto PRODUTO.ID_PRODUTO%TYPE, v_alteracao number, v_tipo_de_alteracao number) IS
    v_produto_existe number := 0;
    e_produto_nao_existe EXCEPTION;
    
BEGIN

-- verifica se o produto existe na base
    SELECT Count(*) into v_produto_existe
        FROM PRODUTO_DUP
        WHERE ID_PRODUTO = v_id_produto;

-- caso o produto exista
    IF v_produto_existe = 1 THEN
    
        -- alteração por porcentagem
        IF v_tipo_de_alteracao = 1 THEN
            UPDATE PRODUTO_DUP
            SET PRECO = PRECO + PRECO*(v_alteracao/100)
            WHERE ID_PRODUTO = v_id_produto;
            
        --alteração por valor
        ELSIF v_tipo_de_alteracao = 0 THEN
            UPDATE PRODUTO_DUP
            SET PRECO = PRECO + v_alteracao
            WHERE ID_PRODUTO = v_id_produto;
            
        END IF;
        
-- caso o produto não exista   
    ELSE
        RAISE e_produto_nao_existe;
    END IF;
    
-- bloco de exceções
EXCEPTION
    WHEN e_produto_nao_existe
        THEN raise_application_error(-30001, 'Produto não encontrado na base de dados');
END produto_altera_preco;
/
-- Sim 2
CREATE OR REPLACE PROCEDURE produto_altera_quantidade (
    v_id_produto PRODUTO.ID_PRODUTO%TYPE, v_nova_quantidade PRODUTO.QUANTIDADE%TYPE) IS
    v_produto_existe number := 0;
    e_produto_nao_existe EXCEPTION;
    
BEGIN

-- verifica se o produto existe na base
    SELECT Count(*) into v_produto_existe
        FROM PRODUTO_DUP
        WHERE ID_PRODUTO = v_id_produto;

-- caso o produto exista
    IF v_produto_existe = 1 THEN

        UPDATE PRODUTO_DUP
        SET QUANTIDADE = v_nova_quantidade
        WHERE ID_PRODUTO = v_id_produto;
            
-- caso o produto não exista   
    ELSE
        RAISE e_produto_nao_existe;
    END IF;
    
-- bloco de exceções
EXCEPTION
    WHEN e_produto_nao_existe
        THEN raise_application_error(-30001, 'Produto não encontrado na base de dados');
    WHEN OTHERS 
        THEN dbms_output.put_line('Erro nuumero: '||SQLCODE||'. Mensagem: '||SQLERRM);
END produto_altera_quantidade;
/
CREATE OR REPLACE PROCEDURE produto_altera_categoria (
    v_id_produto PRODUTO.ID_PRODUTO%TYPE, v_nome_subcategoria SUBCATEGORIA.NOME%TYPE) IS
    v_produto_existe number := 0;
    v_subcategoria_existe number := 0;
    v_id_subcategoria PRODUTO.ID_SUBCATEGORIA%TYPE;
    e_subcategoria_nao_existe EXCEPTION;
    e_produto_nao_existe EXCEPTION;
    
BEGIN

-- verifica se o produto existe na base
    SELECT Count(*) into v_produto_existe
        FROM PRODUTO_DUP
        WHERE ID_PRODUTO = v_id_produto;
        
-- verifica se a subcategoria existe na base
    SELECT Count(*) into v_subcategoria_existe
        FROM SUBCATEGORIA_DUP
        WHERE NOME = v_nome_subcategoria;

-- caso o produto exista
    IF v_produto_existe = 1 AND v_subcategoria_existe > 0 THEN
        SELECT ID_SUBCATEGORIA into v_id_subcategoria
        FROM SUBCATEGORIA_DUP
        WHERE NOME = v_nome_subcategoria;

        UPDATE PRODUTO_DUP
        SET ID_SUBCATEGORIA = v_id_subcategoria
        WHERE ID_PRODUTO = v_id_produto;
            
-- caso a subcategoria não exista
    ELSIF v_produto_existe = 1 AND v_subcategoria_existe = 0 THEN
        RAISE e_subcategoria_nao_existe;
        
-- caso o produto não exista
    ELSE
       RAISE e_produto_nao_existe; 
    END IF;
    
-- bloco de exceções
EXCEPTION
    WHEN e_produto_nao_existe
        THEN raise_application_error(-30001, 'Produto não encontrado na base de dados');
END produto_altera_categoria;
/
CREATE OR REPLACE PROCEDURE altera_minimo_frete(
    v_minimo VENDA.VALOR_FRETE%TYPE) IS    
BEGIN
    UPDATE VENDA_DUP
    SET TOTAL = TOTAL + (v_minimo - VALOR_FRETE),
        VALOR_FRETE = v_minimo
    WHERE VALOR_FRETE < v_minimo;
-- bloco de exceções
END altera_minimo_frete;
/
-- v_tipo_de_alteracao é 0 para valor e 1 para porcentagem
-- v_alteracao é um numero positivo, quando por valor deve ser menor que o total da venda e em porcentagem é no máximo 100
CREATE OR REPLACE PROCEDURE venda_desconto (
    v_data_inicio varchar2, v_data_fim varchar2, v_desconto number, v_tipo_de_alteracao number) IS
    v_valor_do_desconto number;
BEGIN

    -- alteração por porcentagem
    IF v_tipo_de_alteracao = 1 THEN
        IF v_desconto<0 THEN
            v_valor_do_desconto:=0;
        ELSIF v_desconto > 100 THEN
            v_valor_do_desconto := 100;
        ELSE
            v_valor_do_desconto := v_desconto;
        END IF;
        
        UPDATE VENDA_DUP
            SET TOTAL = TOTAL - TOTAL*(v_valor_do_desconto/100)
            WHERE DATA_VENDA BETWEEN TO_DATE(v_data_inicio,'DD/MM/YYYY') AND TO_DATE(v_data_fim,'DD/MM/YYYY');
        
    --alteração por valor
    ELSIF v_tipo_de_alteracao = 0 THEN
    
        UPDATE VENDA_DUP
            SET TOTAL = TOTAL - ABS(v_desconto)
            WHERE DATA_VENDA BETWEEN TO_DATE(v_data_inicio,'DD/MM/YYYY') AND TO_DATE(v_data_fim,'DD/MM/YYYY');
        
    END IF;
END venda_desconto;
/
CREATE OR REPLACE PROCEDURE venda_desconto2 (
    v_data_inicio varchar2, v_data_fim varchar2, v_valor_inicial VENDA.TOTAL%TYPE, v_desconto number, v_tipo_de_alteracao number) IS
    v_valor_do_desconto number;
BEGIN

-- alteração por porcentagem
        IF v_tipo_de_alteracao = 1 THEN
            IF v_desconto<0 THEN
                v_valor_do_desconto:=0;
            ELSIF v_desconto > 100 THEN
                v_valor_do_desconto := 100;
            ELSE
                v_valor_do_desconto := v_desconto;
            END IF;
            
            UPDATE VENDA_DUP
            SET TOTAL = TOTAL - TOTAL*(v_valor_do_desconto/100)
            WHERE DATA_VENDA BETWEEN TO_DATE(v_data_inicio,'DD/MM/YYYY') AND TO_DATE(v_data_fim,'DD/MM/YYYY') AND TOTAL >= v_valor_inicial;
            
        --alteração por valor
        ELSIF v_tipo_de_alteracao = 0 THEN
        
            UPDATE VENDA_DUP
            SET TOTAL = TOTAL - ABS(v_desconto)
            WHERE DATA_VENDA BETWEEN TO_DATE(v_data_inicio,'DD/MM/YYYY') AND TO_DATE(v_data_fim,'DD/MM/YYYY') AND TOTAL >= v_valor_inicial;
            
        END IF;
END venda_desconto2;
/


-- v_tipo_de_alteracao é 0 para valor e 1 para porcentagem
-- v_alteracao é um numero positivo, quando por valor deve ser menor que o total da venda e em porcentagem é no máximo 100
CREATE OR REPLACE PROCEDURE venda_desconto_varios_itens (
    v_desconto number, v_minimo number, v_tipo_de_alteracao number) IS
    v_valor_do_desconto number;
BEGIN

-- alteração por porcentagem
        IF v_tipo_de_alteracao = 1 THEN
            IF v_desconto<0 THEN
                v_valor_do_desconto:=0;
            ELSIF v_desconto > 100 THEN
                v_valor_do_desconto := 100;
            ELSE
                v_valor_do_desconto := v_desconto;
            END IF;
            
            UPDATE ITEMVENDA_DUP
            SET DESCONTO = PRECO_UNITARIO*(v_valor_do_desconto/100)
            WHERE ID_PRODUTO IN (SELECT ID_PRODUTO FROM 
                ( SELECT V.ID_VENDA, IT.ID_PRODUTO, COUNT(V.ID_VENDA) AS QTD 
                    FROM VENDA_DUP V JOIN ITEMVENDA_DUP IT ON IT.ID_VENDA = V.ID_VENDA 
                    GROUP BY V.ID_VENDA, IT.ID_PRODUTO 
                    HAVING COUNT(V.ID_VENDA)>v_minimo));
            
        --alteração por valor
        ELSIF v_tipo_de_alteracao = 0 THEN
        
            UPDATE ITEMVENDA_DUP 
            SET DESCONTO = ABS(v_desconto)
            WHERE ID_PRODUTO IN (SELECT ID_PRODUTO FROM 
                ( SELECT V.ID_VENDA, IT.ID_PRODUTO, COUNT(V.ID_VENDA) AS QTD 
                    FROM VENDA_DUP V JOIN ITEMVENDA_DUP IT ON IT.ID_VENDA = V.ID_VENDA 
                    GROUP BY V.ID_VENDA, IT.ID_PRODUTO 
                    HAVING COUNT(V.ID_VENDA)>v_minimo));
            
        END IF;
END venda_desconto_varios_itens;
/
-- v_tipo_de_alteracao é 0 para valor e 1 para porcentagem
-- v_alteracao é um numero positivo, quando por valor deve ser menor que o total da venda e em porcentagem é no máximo 100
CREATE OR REPLACE PROCEDURE venda_desconto_pais (
    v_pais ENDERECO.PAIS%TYPE, v_desconto number, v_tipo_de_alteracao number) IS
    v_valor_do_desconto number;
BEGIN

-- alteração por porcentagem
    IF v_tipo_de_alteracao = 1 THEN
        IF v_desconto<0 THEN
            v_valor_do_desconto:=0;
        ELSIF v_desconto > 100 THEN
            v_valor_do_desconto := 100;
        ELSE
            v_valor_do_desconto := v_desconto;
        END IF;
        
        UPDATE VENDA_DUP
        SET TOTAL = TOTAL - TOTAL*(v_valor_do_desconto/100)
        WHERE ID_CLIENTE IN (SELECT CL.ID_CLIENTE FROM CLIENTE_DUP CL JOIN PESSOA_DUP P ON CL.ID_PESSOA = P.ID_PESSOA 
            JOIN ENDERECO_DUP E ON P.ID_ENDERECO = E.ID_ENDERECO WHERE E.PAIS = v_pais) ;
        
    --alteração por valor
    ELSIF v_tipo_de_alteracao = 0 THEN
    
        UPDATE VENDA_DUP
        SET TOTAL = TOTAL - ABS(v_desconto)
        WHERE ID_CLIENTE IN (SELECT CL.ID_CLIENTE FROM CLIENTE_DUP CL JOIN PESSOA_DUP P ON CL.ID_PESSOA = P.ID_PESSOA 
            JOIN ENDERECO_DUP E ON P.ID_ENDERECO = E.ID_ENDERECO WHERE E.PAIS = v_pais) ;
            
        END IF;
END venda_desconto_pais;

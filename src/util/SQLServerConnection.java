/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public class SQLServerConnection {
    
    
    private final Connection connection;
    private final Statement stmt;

    public SQLServerConnection(String user, String pass, String host, String port, String sid) throws ClassNotFoundException, SQLException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        connection = DriverManager.getConnection(
                "jdbc:oracle:thin:@" + host + ":" + port + ":" + sid, 
                user, pass);
	stmt = connection.createStatement();
	System.out.println("Connection openned");
    }
    
    public void close(){
	try {
	    connection.close();
	    stmt.close();
	    System.out.println("Connection closed");
	} catch (SQLException ex) {
	}
    }
    
    public String authenticateUser(String usr, String pass) throws SQLException {
	String ret = null;
	ResultSet rs;
	if(!usr.contains("\\")) {
	    usr = "adventure-works\\" + usr;
	}
	String select = "SELECT PESSOA.NOME, EMPREGADO.LOGIN, PESSOA.SENHA, EMPREGADO.FUNCAO FROM EMPREGADO JOIN PESSOA USING(ID_PESSOA) " +
			"WHERE EMPREGADO.LOGIN = '" + usr + "' " +
			"AND PESSOA.SENHA = rawtohex(dbms_obfuscation_toolkit.md5(input => utl_raw.cast_to_raw('" + pass + "')))";
	rs = stmt.executeQuery(select);
	if(rs.next()) {
	    ret = rs.getString("FUNCAO");
	}
	return ret;
    }
    
    public ResultSet getRelatoryData(RelatoryType rt, String filter1, String filter2) throws SQLException {
	String procedure = "";
	String param = "(?, ?)";
	filter1 = (filter1 == null || filter1.equals("")) ? null : filter1;
	filter2 = (filter2 == null || filter2.equals("")) ? null : filter2;
	ResultSet rs = null;
	int cursorIndex = 2;
	
	switch(rt) {
	    case CLIENTE_CARTAO:
		procedure = "cliente_cartao";
		break;
	    case HISTORICO_FUNCIONARIOS:
		procedure = "historico_funcionarios";
		param = "(?, ?, ?)";
		cursorIndex = 3;
		break;
	    case DADOS_FRETE:
		procedure = "dados_frete";
		break;
	    default:
		procedure = "";
		break;
	}
	
	if(!procedure.equals("")) {
	    CallableStatement cstmt = connection.prepareCall("{call " + procedure + param + "}");
	    if(filter1 == null)
		cstmt.setObject(1, null);
	    else
		cstmt.setString(1, filter1); 
	    if(rt == RelatoryType.HISTORICO_FUNCIONARIOS) {
		if(filter2 == null)
		    cstmt.setObject(2, null);
		else
		    cstmt.setString(2, filter2);
	    }
	    cstmt.registerOutParameter(cursorIndex, OracleTypes.CURSOR); //REF CURSOR
	    cstmt.execute();
	    rs = ((OracleCallableStatement)cstmt).getCursor(cursorIndex);
	}
	return rs;
    }
}

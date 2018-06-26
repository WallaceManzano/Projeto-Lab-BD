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
import java.util.LinkedHashMap;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import org.jfree.data.xy.XYSeries;

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
	CallableStatement cstmt = connection.prepareCall("{call DUP_BASE()}");
	cstmt.execute();
	System.out.println("Connection openned");
    }
    
    public void close(){
	try {
	    CallableStatement cstmt = connection.prepareCall("{call TRUNCATE_DUP_BASE()}");
	    cstmt.execute();
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
    
    public ResultSet getProductEnding() throws SQLException {
	ResultSet rs = stmt.executeQuery("SELECT NOME AS \"Nome\", QUANTIDADE AS \"Quantidade\" FROM PRODUTO WHERE QUANTIDADE <= 10");
	return rs;
    }
    
    public XYSeries getRevenueByMonth(String month) throws SQLException {
	month = (month == null || month.equals("")) ? null : month;
	ResultSet rs = null;
	XYSeries series = new XYSeries("Vendas");
	CallableStatement cstmt = connection.prepareCall("{call rendimento_por_mes(?, ?)}");
	
	
	if(month == null)
	    cstmt.setObject(1, null);
	else
	    cstmt.setString(1, month);
	
	cstmt.registerOutParameter(2, OracleTypes.CURSOR);
	cstmt.execute();
	rs = ((OracleCallableStatement)cstmt).getCursor(2);
	while(rs.next()) {
	    String x = rs.getString(1);
	    String y = rs.getString(2);
	    System.out.println("Point " + Long.parseLong(x) + ", " + Long.parseLong(y));
	    series.add(Long.parseLong(x), Long.parseLong(y));
}
	return series;
    }
    
    public XYSeries getRevenueByYear(String begin, String end) throws SQLException {
	begin = (begin == null || begin.equals("")) ? null : begin;
	end = (end == null || end.equals("")) ? null : end;
	
	
	ResultSet rs = null;
	XYSeries series = new XYSeries("Vendas");
	CallableStatement cstmt = connection.prepareCall("{call rendimento_por_ano(?, ?, ?)}");
	
	
	if(begin == null)
	    cstmt.setObject(1, null);
	else
	    cstmt.setString(1, begin);
	
	
	if(end == null)
	    cstmt.setObject(2, null);
	else
	    cstmt.setString(2, end);
	
	cstmt.registerOutParameter(3, OracleTypes.CURSOR);
	cstmt.execute();
	rs = ((OracleCallableStatement)cstmt).getCursor(3);
	while(rs.next()) {
	    String x = rs.getString(1);
	    String y = rs.getString(2);
	    series.add(Long.parseLong(x), Long.parseLong(y));
}
	return series;
    }
    
    public String getRevenues(String day, String month, String year) throws SQLException {
	String ret = "0";
	day = (day == null || day.equals("")) ? "to_char(sysdate, 'DD')" : day;
	month = (month == null || month.equals("")) ? "to_char(sysdate, 'MM')" : month;
	year = (year == null || year.equals("")) ? "to_char(sysdate, 'YYYY')" : year;
	
	ResultSet rs;
	rs = stmt.executeQuery("SELECT SUM(TOTAL) AS TOTAL FROM VENDA "
		+ "WHERE to_char(DATA_VENDA, 'YYYY') = " + year
		+ " AND to_char(DATA_VENDA, 'MM') = " + month
		+ " AND to_char(DATA_VENDA, 'DD') = " + day);
	if(rs.next()) {
	    ret = rs.getString("TOTAL");
	}
	
	return ret;
    }
    
    public ResultSet getTopProducts() throws SQLException {
	String ret = null;
	ResultSet rs = null;
	
	CallableStatement cstmt = connection.prepareCall("{call top_produtos(?)}");
	cstmt.registerOutParameter(1, OracleTypes.CURSOR);
	cstmt.execute();
	rs = ((OracleCallableStatement)cstmt).getCursor(1);
	return rs;
    }
    
    public ResultSet getTopEmployers(String month, String year) throws SQLException {
	String ret = null;
	ResultSet rs = null;
	year = (year == null || year.equals("")) ? null : year;
	month = (month == null || month.equals("")) ? null : month;
	
	CallableStatement cstmt = connection.prepareCall("{call top_funcionarios(?, ?, ?)}");
	
	
	if(month == null)
	    cstmt.setObject(1, null);
	else
	    cstmt.setString(1, month);
	
	if(year == null)
	    cstmt.setObject(2, null);
	else
	    cstmt.setString(2, year);
	
	cstmt.registerOutParameter(3, OracleTypes.CURSOR);
	
	cstmt.execute();
	rs = ((OracleCallableStatement)cstmt).getCursor(3);
	return rs;
    }
    
    public ResultSet getTopClients(String month) throws SQLException {
	String ret = null;
	ResultSet rs = null;
	month = (month == null || month.equals("")) ? null : month;
	
	
	CallableStatement cstmt = connection.prepareCall("{call top_clients(?, ?)}");
	
	if(month == null)
	    cstmt.setObject(1, null);
	else
	    cstmt.setString(1, month);
	cstmt.registerOutParameter(2, OracleTypes.CURSOR);
	
	cstmt.execute();
	rs = ((OracleCallableStatement)cstmt).getCursor(2);
	return rs;
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
	    cstmt.registerOutParameter(cursorIndex, OracleTypes.CURSOR);
	    cstmt.execute();
	    rs = ((OracleCallableStatement)cstmt).getCursor(cursorIndex);
	}
	return rs;
    }
}

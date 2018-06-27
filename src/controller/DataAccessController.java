/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;
import javax.swing.table.DefaultTableModel;
import util.RelatoryType;
import main.Main;
import static util.Util.generateTableModel;
import org.jfree.data.xy.XYSeriesCollection;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public class DataAccessController {
    
    public static void changeProductPrice(String id, String price, boolean percentage) throws SQLException {
	String a = (percentage) ? "1" : "0";
	Main.connection.simulateEvent("produto_altera_preco", id, price, a);
    }
    
    public static void changeProductQuantity(String id, String quantity) throws SQLException {
	Main.connection.simulateEvent("produto_altera_quantidade", id, quantity);
    }
    
    public static void changeProductSubcategory(String id, String subcategory) throws SQLException {
	Main.connection.simulateEvent("produto_altera_categoria", id, subcategory);
    }
    
    public static void changeSaleFreightMin(String min) throws SQLException {
	Main.connection.simulateEvent("altera_minimo_frete", min);
    }
    
    public static void discountSaleInterval1(String discount, String from, String to, boolean percentage) throws SQLException {
	String a = (percentage) ? "1" : "0";
	if(!from.matches("\\d{2}/\\d{2}/\\d{4}") || !to.matches("\\d{2}/\\d{2}/\\d{4}")) {
	    throw new IllegalArgumentException();
	}
	System.out.println(from + " " + to);
	Main.connection.simulateEvent("venda_desconto", from, to, discount, a);
    }
    
    public static void discountSaleInterval2(String discount, String from, String to, String min, boolean percentage) throws SQLException {
	String a = (percentage) ? "1" : "0";
	if(!from.matches("\\d{2}/\\d{2}/\\d{4}") || !to.matches("\\d{2}/\\d{2}/\\d{4}")) {
	    throw new IllegalArgumentException();
	}
	System.out.println(from + " " + to);
	Main.connection.simulateEvent("venda_desconto2", from, to, min, discount, a);
    }
    
    public static void discoutSaleUnits(String discount, String units, boolean percentage) throws SQLException {
	String a = (percentage) ? "1" : "0";
	Main.connection.simulateEvent("venda_desconto_varios_itens", discount, units, discount, a);
    }
    
    public static void discoutSaleCountry(String discount, String country, boolean percentage) throws SQLException {
	String a = (percentage) ? "1" : "0";
	Main.connection.simulateEvent("venda_desconto_pais", country, discount, a);
    }
    
    public static Set<String> getSubcategories() throws SQLException {
	Set<String> rl = new HashSet<>();
	ResultSet rs = Main.connection.getSubcategories();
	while(rs.next()) {
	    rl.add(rs.getString(1));
	}
	return rl;
    }
    
    public static Set<String> getCountries() throws SQLException {
	Set<String> rl = new HashSet<>();
	ResultSet rs = Main.connection.getCountries();
	while(rs.next()) {
	    rl.add(rs.getString(1));
	}
	return rl;
    }
    
    // <editor-fold defaultstate="collapsed" desc="Overview Methods"> 
    public static DefaultTableModel loadDataTopEmployers(String month, String ano) throws SQLException {
	ResultSet rs = Main.connection.getTopEmployers(month, ano);
	return generateTableModel(rs, 3);
    }
    
    public static DefaultTableModel loadDataTopClients(String month) throws SQLException {
	ResultSet rs = Main.connection.getTopClients(month);
	return generateTableModel(rs, 5);
    }
    
    public static DefaultTableModel loadDataTopProducts() throws SQLException {
	ResultSet rs = Main.connection.getTopProducts();
	return generateTableModel(rs, 15);
    }
    
    public static String getRevenues(String day, String month, String year) throws SQLException {
	return Main.connection.getRevenues(day, month, year);
    }
    
    public static XYSeriesCollection getRevenueByYearChartPoint(String begin, String end) throws SQLException {
	return new XYSeriesCollection(Main.connection.getRevenueByYear(begin, end));
    }
    
    public static XYSeriesCollection getRevenueByMonthChartPoint(String month) throws SQLException {
	return new XYSeriesCollection(Main.connection.getRevenueByMonth(month));
    }
    public static DefaultTableModel loadProductEnding() throws SQLException {
	ResultSet rs = Main.connection.getProductEnding();
	return generateTableModel(rs);
    }
    // </editor-fold>
    
    public static DefaultTableModel loadDataRelatory(RelatoryType rt, String filter1, String filter2) throws SQLException {
	ResultSet rs = Main.connection.getRelatoryData(rt, filter1, filter2);
	return generateTableModel(rs);
    }
    
}

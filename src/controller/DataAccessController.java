/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
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
    
    public static DefaultTableModel loadDataRelatory(RelatoryType rt, String filter1, String filter2) throws SQLException {
	ResultSet rs = Main.connection.getRelatoryData(rt, filter1, filter2);
	return generateTableModel(rs);
    }
    
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
}

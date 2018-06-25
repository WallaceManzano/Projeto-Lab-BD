/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Vector;
import javax.swing.table.DefaultTableModel;
import util.RelatoryType;
import main.Main;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public class RelatoryController {
    
    public static DefaultTableModel loadData(RelatoryType rt, String filter1, String filter2) throws SQLException {
	Vector<Vector<Object>> data = new Vector<Vector<Object>>();
	Vector<String> columnNames = new Vector<String>();
	DefaultTableModel tableModel = new DefaultTableModel();
	ResultSet rs = Main.connection.getRelatoryData(rt, filter1, filter2);
        ResultSetMetaData metaData = rs.getMetaData();
	Object aux;
	
	// Names of columns
	int columnCount = metaData.getColumnCount();
	for (int i = 1; i <= columnCount; i++) {
	    columnNames.add(metaData.getColumnName(i));
	}

	while (rs.next()) {
	    Vector<Object> vector = new Vector<Object>();
	    for (int i = 1; i <= columnCount; i++) {
		aux = rs.getObject(i);
		if(aux instanceof java.sql.Clob){
		    java.sql.Clob aux2 = (java.sql.Clob) aux;
		    StringBuilder sb = new StringBuilder();

		    try{
			Reader reader = aux2.getCharacterStream();
			BufferedReader br = new BufferedReader(reader);

			int b;
			while((b = br.read()) != -1){
			    sb.append((char)b);
			}

			br.close();
			aux = sb.toString();
		    } catch (IOException e){}
		}
		vector.add(aux);
	    }
	    data.add(vector);
	}

	tableModel.setDataVector(data, columnNames);
	return tableModel;
    }
}

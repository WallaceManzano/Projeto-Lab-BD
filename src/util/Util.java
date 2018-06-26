/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.awt.Dimension;
import java.awt.Rectangle;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Vector;
import javax.swing.ButtonModel;
import javax.swing.JButton;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
final public class Util {
    
    public static void simulateButtonClick(JButton button) {
	Dimension size = button.getSize();
	ButtonModel model = button.getModel();
	model.setArmed(true);
	model.setPressed(true);
	button.paintImmediately(new Rectangle(0, 0, size.width, size.height));
	try {
	    Thread.sleep(70);
	} catch (InterruptedException e1) {
	}
	model.setPressed(false);
	model.setArmed(false);
    }
    public static DefaultTableModel generateTableModel(ResultSet rs) throws SQLException {
	return generateTableModel(rs, Integer.MAX_VALUE);
    }
    public static DefaultTableModel generateTableModel(ResultSet rs, int max) throws SQLException {
	
	Vector<Vector<Object>> data = new Vector<Vector<Object>>();
	Vector<String> columnNames = new Vector<String>();
	DefaultTableModel tableModel = new DefaultTableModel();
        ResultSetMetaData metaData = rs.getMetaData();
	Object aux;
	
	// Names of columns
	int columnCount = metaData.getColumnCount();
	for (int i = 1; i <= columnCount; i++) {
	    columnNames.add(metaData.getColumnName(i));
	}
	int c = 0;
	while (rs.next() && c < max) {
	    c++;
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

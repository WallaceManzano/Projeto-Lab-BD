/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;
import java.sql.SQLException;
import view.Login;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import util.SQLServerConnection;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public class Main {
    public static SQLServerConnection connection;
    static {
	try {
	     connection = new SQLServerConnection("a9790840", "a9790840", "grad.icmc.usp.br", "15215", "orcl");
	} catch(ClassNotFoundException | SQLException e) {
	    e.printStackTrace();
	}
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
	try {
	    UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
	} catch (Exception e) {
	}
	SwingUtilities.invokeLater(new Runnable() {
	    
	    @Override
	    public void run() {
		Login l = new Login();
		l.setVisible(true);
	    }
	});
    }
}

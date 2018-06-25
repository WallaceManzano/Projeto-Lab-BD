/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.sql.SQLException;
import main.Main;
import util.UserType;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public class LoginController {
    public static UserType login(String usr, String pass) {
	String f = null;
	try {
	    f = Main.connection.authenticateUser(usr, pass);
	} catch (SQLException ex) {
	    ex.printStackTrace();
	}
	if(f == null)
	    return UserType.NOT_FOUND;
	switch (f) {
	    case "Production Technician - WC20":
		return UserType.PT_WC20;
	    case "Shipping and Receiving Clerk":
		return UserType.SR_CLERK;
	    case "Stocker":
		return UserType.STOCKER;
	    default:
		return UserType.OTHER_EMPLOYEES;
	}
    }
}

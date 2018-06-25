/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.awt.Dimension;
import java.awt.Rectangle;
import javax.swing.ButtonModel;
import javax.swing.JButton;

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
}

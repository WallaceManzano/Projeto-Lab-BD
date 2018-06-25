/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public enum UserType {
    NOT_FOUND(Permition.NOTHINHG),
    CLIENT(Permition.NOTHINHG),
    SR_CLERK(Permition.RELATORY),
    PT_WC20(Permition.RELATORY),
    STOCKER(Permition.SIM_RELATORY),
    OTHER_EMPLOYEES(Permition.FULL);
    
    private final Permition permition;
    UserType(Permition a) {
	this.permition = a;
    }
    public Permition getPermition() {
	return permition;
    }
}

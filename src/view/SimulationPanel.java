/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package view;
import static controller.DataAccessController.*;
import static javax.swing.JOptionPane.showMessageDialog;
import java.sql.SQLException;
import java.util.Set;
import javax.swing.text.MaskFormatter;

/**
 *
 * @author Wallace Alves Esteves Manzano <wallace.manzano at usp.br>
 */
public class SimulationPanel extends javax.swing.JPanel {

    /**
     * Creates new form SimulationPanel
     */
    public SimulationPanel() {
	initComponents();
	try {
	    Set<String> sc = getSubcategories();
	    for (String e : sc) {
		lstProductSubcategory.addItem(e);
	    }
	    sc = getCountries();
	    for (String e : sc) {
		lstSaleDiscount3Countries.addItem(e);
	    }
	} catch (SQLException ex) {
	    ex.printStackTrace();
	}
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        txtProductID = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        txtProductPrice = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        lstProductSubcategory = new javax.swing.JComboBox<>();
        chbProductPricePercentage = new javax.swing.JCheckBox();
        jButton1 = new javax.swing.JButton();
        txtProductQt = new javax.swing.JTextField();
        jLabel15 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        txtSaleFreight = new javax.swing.JTextField();
        txtSaleDiscount1 = new javax.swing.JTextField();
        txtSaleDiscount3 = new javax.swing.JTextField();
        txtSaleDiscount4 = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        txtSaleDiscount3Input = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        lstSaleDiscount3Countries = new javax.swing.JComboBox<>();
        jButton2 = new javax.swing.JButton();
        chbSaleDiscount1 = new javax.swing.JCheckBox();
        chbSaleDiscount3 = new javax.swing.JCheckBox();
        chbSaleDiscount4 = new javax.swing.JCheckBox();
        txtSaleDiscount1From = new javax.swing.JFormattedTextField();
        txtSaleDiscount1To = new javax.swing.JFormattedTextField();
        jLabel18 = new javax.swing.JLabel();
        txtSaleDiscount2Input1 = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();

        setBorder(javax.swing.BorderFactory.createTitledBorder("Simulações"));

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("Produto"));

        jLabel1.setText("ID Produto");

        jLabel2.setText("Preco");

        jLabel3.setText("Subcategoria");

        lstProductSubcategory.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Selecionar" }));

        chbProductPricePercentage.setText("%");

        jButton1.setText("Alterar");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jLabel15.setText("Quantidade");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(25, 25, 25)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel1)
                                    .addComponent(jLabel2))
                                .addGap(57, 57, 57)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(txtProductID, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addComponent(txtProductPrice, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(chbProductPricePercentage))))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel3)
                                    .addComponent(jLabel15))
                                .addGap(46, 46, 46)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(txtProductQt, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(lstProductSubcategory, javax.swing.GroupLayout.PREFERRED_SIZE, 96, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(85, 85, 85)
                        .addComponent(jButton1)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(txtProductID, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(txtProductPrice, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(chbProductPricePercentage))
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel15)
                    .addComponent(txtProductQt, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 19, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(lstProductSubcategory, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(30, 30, 30)
                .addComponent(jButton1)
                .addContainerGap())
        );

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("Venda"));

        jLabel4.setText("Frete mínimo");

        jLabel5.setText("Desconto");

        jLabel7.setText("Desconto");

        jLabel8.setText("Desconto");

        jLabel9.setText("do dia");

        jLabel11.setText("em itens com mais de");

        jLabel12.setText("no país");

        jLabel13.setText("até");

        jLabel14.setText("unidades na venda");

        lstSaleDiscount3Countries.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Selecionar" }));

        jButton2.setText("Alterar");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        chbSaleDiscount1.setText("%");

        chbSaleDiscount3.setText("%");

        chbSaleDiscount4.setText("%");

        try {
            MaskFormatter dateMask = new MaskFormatter("##/##/####");
            dateMask.setPlaceholderCharacter('_');
            dateMask.setValidCharacters("0123456789");
            txtSaleDiscount1From = new javax.swing.JFormattedTextField(dateMask);
        } catch (java.text.ParseException ex) {
            ex.printStackTrace();
        }

        try {
            MaskFormatter dateMask = new MaskFormatter("##/##/####");
            dateMask.setPlaceholderCharacter('_');
            dateMask.setValidCharacters("0123456789");
            txtSaleDiscount1To = new javax.swing.JFormattedTextField(dateMask);
        } catch (java.text.ParseException ex) {
            ex.printStackTrace();
        }

        jLabel18.setText("em vendas acima de");

        jLabel6.setText("(opcional)");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(24, 24, 24)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addComponent(jLabel5)
                    .addComponent(jLabel7)
                    .addComponent(jLabel8))
                .addGap(27, 27, 27)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(txtSaleDiscount4, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(txtSaleDiscount3, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(chbSaleDiscount4)
                                .addGap(6, 6, 6)
                                .addComponent(jLabel12)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(lstSaleDiscount3Countries, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(chbSaleDiscount3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel11)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(txtSaleDiscount3Input, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel14))))
                    .addComponent(txtSaleFreight, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(txtSaleDiscount1, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGap(24, 24, 24)
                                .addComponent(jButton2))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(chbSaleDiscount1)
                                .addGap(6, 6, 6)
                                .addComponent(jLabel9)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(txtSaleDiscount1From, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel13)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(txtSaleDiscount1To, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel18)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(txtSaleDiscount2Input1, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel6)))))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(txtSaleFreight, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(txtSaleDiscount1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel9)
                    .addComponent(jLabel13)
                    .addComponent(chbSaleDiscount1)
                    .addComponent(txtSaleDiscount1From, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txtSaleDiscount1To, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel18)
                    .addComponent(txtSaleDiscount2Input1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel6))
                .addGap(18, 18, 18)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel7)
                        .addGap(32, 32, 32)
                        .addComponent(jLabel8))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(txtSaleDiscount3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel11)
                            .addComponent(txtSaleDiscount3Input, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel14)
                            .addComponent(chbSaleDiscount3))
                        .addGap(23, 23, 23)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(txtSaleDiscount4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel12)
                            .addComponent(lstSaleDiscount3Countries, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(chbSaleDiscount4))))
                .addGap(49, 49, 49)
                .addComponent(jButton2))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(18, 18, 18)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
	try {
	    boolean a = true;
	    if(!txtProductID.getText().equals("") && !txtProductPrice.getText().equals("")) {
		a = false;
		changeProductPrice(txtProductID.getText(), txtProductPrice.getText(), chbProductPricePercentage.isSelected());
	    } 
	    if(!txtProductID.getText().equals("") && !txtProductQt.getText().equals("")) {
		a = false;
		changeProductQuantity(txtProductID.getText(), txtProductQt.getText());
		
	    } 
	    if(!txtProductID.getText().equals("") && !lstProductSubcategory.getSelectedItem().toString().equals("Selecionar")) {
		a = false;
		changeProductSubcategory(txtProductID.getText(), lstProductSubcategory.getSelectedItem().toString());	
	    } 
	    if(a){
		showMessageDialog(null, "Nada para ser feito!!");
	    } else {
		showMessageDialog(null, "Modificação feita com sucesso!!");
	    }
	} catch (SQLException ex) {
	    if(ex.getErrorCode() == -30001) {
		showMessageDialog(null, "Produto não encontrado!!");
	    } else {
		ex.printStackTrace();
	    }
	}
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        try {
	    boolean a = true;
	    if(!txtSaleFreight.getText().equals("")) {
		changeSaleFreightMin(txtSaleFreight.getText());
		a = false;
	    }
	    if(!txtSaleDiscount1.getText().equals("") && !txtSaleDiscount1From.getText().contains("_") 
		    && !txtSaleDiscount1To.getText().contains("_") && txtSaleDiscount2Input1.getText().equals("")) {
		try {
		    discountSaleInterval1(txtSaleDiscount1.getText(), txtSaleDiscount1From.getText(), 
			    txtSaleDiscount1To.getText(), chbSaleDiscount1.isSelected());
		    a = false;
		} catch(IllegalArgumentException e) {
		    showMessageDialog(null, "Verifique o formado da entrada, a data deve estar no formato dd/mm/aaaa");
		}
	    }
	    if(!txtSaleDiscount1.getText().equals("") && !txtSaleDiscount1From.getText().contains("_") 
		    && !txtSaleDiscount1To.getText().contains("_") && !txtSaleDiscount2Input1.getText().equals("")) {
		try {
		    discountSaleInterval2(txtSaleDiscount1.getText(), txtSaleDiscount1From.getText(), 
			    txtSaleDiscount1To.getText(), txtSaleDiscount2Input1.getText(), chbSaleDiscount1.isSelected());
		    a = false;
		} catch(IllegalArgumentException e) {
		    showMessageDialog(null, "Verifique o formado da entrada, a data deve estar no formato dd/mm/aaaa");
		}
	    }
	    if(!txtSaleDiscount3.getText().equals("") && !txtSaleDiscount3Input.getText().equals("")) {
		discoutSaleUnits(txtSaleDiscount3.getText(), txtSaleDiscount3Input.getText(), chbSaleDiscount3.isSelected());
		a = false;
	    }
	    if(!txtSaleDiscount4.getText().equals("") && !lstSaleDiscount3Countries.getSelectedItem().toString().equals("Selecionar")) {
		discoutSaleCountry(txtSaleDiscount4.getText(), lstSaleDiscount3Countries.getSelectedItem().toString(), chbSaleDiscount4.isSelected());
		a = false;
	    }
	    if(a){
		showMessageDialog(null, "Nada para ser feito!!");
	    } else {
		showMessageDialog(null, "Modificação feita com sucesso!!");
	    }
	} catch (SQLException ex) {
	    if(ex.getErrorCode() == -30001) {
		showMessageDialog(null, "Produto não encontrado!!");
	    } else {
		ex.printStackTrace();
	    }
	}
    }//GEN-LAST:event_jButton2ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JCheckBox chbProductPricePercentage;
    private javax.swing.JCheckBox chbSaleDiscount1;
    private javax.swing.JCheckBox chbSaleDiscount3;
    private javax.swing.JCheckBox chbSaleDiscount4;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JComboBox<String> lstProductSubcategory;
    private javax.swing.JComboBox<String> lstSaleDiscount3Countries;
    private javax.swing.JTextField txtProductID;
    private javax.swing.JTextField txtProductPrice;
    private javax.swing.JTextField txtProductQt;
    private javax.swing.JTextField txtSaleDiscount1;
    private javax.swing.JFormattedTextField txtSaleDiscount1From;
    private javax.swing.JFormattedTextField txtSaleDiscount1To;
    private javax.swing.JTextField txtSaleDiscount2Input1;
    private javax.swing.JTextField txtSaleDiscount3;
    private javax.swing.JTextField txtSaleDiscount3Input;
    private javax.swing.JTextField txtSaleDiscount4;
    private javax.swing.JTextField txtSaleFreight;
    // End of variables declaration//GEN-END:variables
}

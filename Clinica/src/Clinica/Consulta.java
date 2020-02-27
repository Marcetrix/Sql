package Clinica;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;


public class Consulta {
		
    static Connection con;
    static Statement stmt;
    static ResultSet rs;
    
    public static void main(String[]args) throws SQLException {
    	
    	String url;
    	
    	try {
    		Class.forName("com.mysql.cj.jdbc.Driver");
    		url = "jdbc:mysql://localhost:3306/Clinica?useTimezone=true&serverTimezone=UTC";
    		
    		con = DriverManager.getConnection(url, "root", "1234");
    		stmt = con.createStatement();
    		rs = stmt.executeQuery("select * from funcionarios");
    		while(rs.next()){
                 System.out.println("Nome: " + rs.getString("nome"));
                 //System.out.println("Cargo: " + rs.getString("cargo"));
             }
    		
    		}
    	
    	 catch (ClassNotFoundException ex) {
             Logger.getLogger(Consulta.class.getName()).log(Level.SEVERE, null, ex);
            }
         catch (SQLException ex) {
        	 Logger.getLogger(Consulta.class.getName()).log(Level.SEVERE, null, ex);
         		}
    	  finally{
              stmt.close();
              rs.close();
              con.close();
          }
    	
    }
}

//
//  CallWsClass.swift
//  LoginProyect
//
//  Created by SAMUEL on 2/4/18.
//  Copyright © 2018 SAMUEL VASILOVSKI. All rights reserved.
//

import Foundation
import UIKit

class CallWsClass: UIViewController{
    func connection(myUrl: NSURL, httpBody: [String: Any] = [:], method: String = "POST"){
        var myAlert: UIAlertController?;
        
        let request = NSMutableURLRequest(url: myUrl as URL);
        request.httpMethod = method;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let jsonTodo: Data;
        do{
            jsonTodo = try JSONSerialization.data(withJSONObject: httpBody, options: []);
            request.httpBody = jsonTodo;
        }catch{
            myAlert = displayMyAlertMessage("Error: Cannot create JSON from User.");
            present(myAlert!, animated: true, completion: nil);
            return;
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data,response,error in
            if error != nil {
                myAlert = self.displayMyAlertMessage("error:\(String(describing: error))");
                self.present(myAlert!, animated: true, completion: nil);
                return;
            }
            guard let data = data else {
                return;
            }
            
            self.dataProcess(data: data);
        }
        task.resume();
    }
    
    func dataProcess(data:Data){
        var myAlert: UIAlertController?;
        
        //let json: AnyObject?
        do {
            let intEstado: Int;
            var txtUsuario: String?;
            let arrReferencia: [String];
            
            if let datos = String(data: data, encoding: .utf8)?.data(using: .utf8){
                let dicDatos = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any];
                if let datoStr=dicDatos!["data"] as? [String: Any] {
                    if let estado=datoStr["status"] as? Int {
                        intEstado = estado;
                    } else {
                        myAlert = self.displayMyAlertMessage("error: server error.");
                        self.present(myAlert!, animated: true, completion: nil);
                        return;
                    }
                    if let usuario=datoStr["usuario"] as? String {
                        txtUsuario = usuario;
                    }
                } else {
                    myAlert = self.displayMyAlertMessage("error: server error.");
                    self.present(myAlert!, animated: true, completion: nil);
                    return;
                };
                
                if let referencia=dicDatos!["references"] as? [String] {
                    arrReferencia = referencia;
                } else {
                    myAlert = self.displayMyAlertMessage("error: server error.");
                    self.present(myAlert!, animated: true, completion: nil);
                    return;
                };
                
                if (!(arrReferencia.count > 0) && arrReferencia.count <= intEstado){
                    myAlert = self.displayMyAlertMessage("error: status out of range.");
                    self.present(myAlert!, animated: true, completion: nil);
                    return;
                }
                
                resultProcess(intEstado: intEstado, txtUsuario: txtUsuario, arrReferencia: arrReferencia);
            }
        } catch {
            let mensaje = "failed: \(String(describing: error))";
            myAlert = self.displayMyAlertMessage(mensaje);
            self.present(myAlert!, animated: true, completion: nil);
            return;
        }
    }
    
    func resultProcess(intEstado: Int, txtUsuario: String?, arrReferencia: [String]){}
    
    // Acciones del Usuario
    func loguinUserAction(userLogged:String, login: Bool = true){
        var myAlert: UIAlertController?;
        
        let alert = UIAlertController(title: "Login", message: nil, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        
        alert.addTextField(configurationHandler: {UITextField in
            UITextField.placeholder = "Input your user name ...";
        });
        
        alert.addTextField(configurationHandler: {UITextField in
            UITextField.placeholder = "Input your password ...";
            UITextField.isSecureTextEntry = true;
        });
        
        // si no es loggin lo toma como cambio de password
        if(!login){
            alert.addTextField(configurationHandler: {UITextField in
                UITextField.placeholder = "Input your mew password ...";
                UITextField.isSecureTextEntry = true;
            });
            
            alert.addTextField(configurationHandler: {UITextField in
                UITextField.placeholder = "Confirm your new password ...";
                UITextField.isSecureTextEntry = true;
            });
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            var user:String?;
            var password:String?;
            var newPassword:String? = "";
            var repetPassword:String? = "";
            
            if let dato = alert.textFields?.first?.text{
                if(userLogged == dato){
                    user = dato;
                } else {
                    myAlert = self.displayMyAlertMessage("User is distint to user logged.");
                    self.present(myAlert!, animated: true, completion: nil);
                    return;
                }
            }
            
            if let dato = alert.textFields?[1].text{
                password = dato;
            }
            
            if(!login){
                if let dato = alert.textFields?[2].text{
                    newPassword = dato;
                }
                
                if let dato = alert.textFields?[3].text{
                    repetPassword = dato;
                }
                
                if(newPassword != repetPassword){
                    myAlert = self.displayMyAlertMessage("Password do not match.");
                    self.present(myAlert!, animated: true, completion: nil);
                    return;
                }
            }
            
            self.tratamientoAccionUsuario(user: user!, password: password!, newPassword: newPassword!, repetPassword: repetPassword!)
        }));
        
        self.present(alert, animated: true);
    }
    
    func tratamientoAccionUsuario(user:String, password:String, newPassword:String, repetPassword: String){}
}

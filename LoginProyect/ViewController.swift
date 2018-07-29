//
//  ViewController.swift
//  LoginProyect
//
//  Created by SAMUEL on 24/2/18.
//  Copyright © 2018 SAMUEL VASILOVSKI. All rights reserved.
//

import UIKit

class ViewController: CallWsClass {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "LoginView", sender: self);
        }
    }
    @IBAction func LogoutButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        UserDefaults.standard.set("", forKey: "logginUser");
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "LoginView", sender: self)
    }
    
    override func resultProcess(intEstado: Int, txtUsuario: String?, arrReferencia: [String]) {
        let login = UserDefaults.standard.string(forKey: "registerUser");
        var messageToDisplay:String? = "Fail.";
        var fallo:Bool = false;
        
        if(arrReferencia[intEstado] == "OK") {
            // Login is successfull
            switch login {
            case "du":
                messageToDisplay = "The \"\(txtUsuario!)\" user deleting correctly.";
                break;
            case "cp":
                messageToDisplay = "The \"\(txtUsuario!)\" user change password correctly.";
                break;
            case "bk":
                messageToDisplay = "The \"\(txtUsuario!)\" user blocking correctly.";
                break;
            default:
                fallo = true;
            }
        }
        else{
            fallo = true;
            messageToDisplay = arrReferencia[intEstado];
        }
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            DispatchQueue.main.async { // 2
                if(messageToDisplay != nil && !(messageToDisplay!.isEmpty)){
                    let myAlert = self.displayMyAlertMessage(messageToDisplay!, addButton: fallo);
                    if(!fallo){
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ action in
                            // Seteo variables por defecto
                            UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
                            UserDefaults.standard.set(nil, forKey: "logginUser");
                            UserDefaults.standard.set(nil, forKey: "registerUser");
                            UserDefaults.standard.synchronize();
                            // Vuelvo a logear
                            self.performSegue(withIdentifier: "LoginView", sender: self);
                        }
                        myAlert.addAction(okAction);
                    }
                    self.present(myAlert, animated: true, completion: nil);
                }
            }
        };
    }
    
    override func tratamientoAccionUsuario(user: String, password: String, newPassword: String, repetPassword: String) {
        // acciones del usuario
        let login = UserDefaults.standard.string(forKey: "registerUser");
        var myAlert: UIAlertController?;
        var parametros: [String: Any];
        var myUrl: NSURL;
        var consultar: Bool = true;
        
        switch login {
        case "du":
            parametros = ["usuario": user, "password": password];
            myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/eliminarUsuario")!;
            break;
        case "cp":
            parametros = ["usuario": user, "password": password, "nuevaPassword": newPassword, "passwordRepetida" : repetPassword];
            myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/actualizarUsuario")!;
            break;
        case "bk":
            parametros = ["usuario": user, /*"password": password,*/ "habilitado": 0];
            myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/bloquearDesbloquearUsuario")!;
            break;
        default:
            parametros = [:];
            myUrl = NSURL(string: "")!;
            consultar = false;
        }
        
        if(consultar){
            connection(myUrl: myUrl, httpBody: parametros);
        } else{
            myAlert = self.displayMyAlertMessage("Fail.");
            self.present(myAlert!, animated: true, completion: nil);
        }
    }
    
    @IBAction func DeleteUserButtonTapped(_ sender: UIButton) {
        let login = UserDefaults.standard.string(forKey: "logginUser");
        
        UserDefaults.standard.set("du", forKey: "registerUser");
        UserDefaults.standard.synchronize();
        
        loguinUserAction(userLogged: login!);
    }
    
    @IBAction func ChangePasswordButtonTapped(_ sender: UIButton) {
        let login = UserDefaults.standard.string(forKey: "logginUser");
        
        UserDefaults.standard.set("cp", forKey: "registerUser");
        UserDefaults.standard.synchronize();
        
        loguinUserAction(userLogged: login!, login: false);
    }
    
    @IBAction func BlockUserButtonTapped(_ sender: UIButton) {
        let login = UserDefaults.standard.string(forKey: "logginUser");
        
        UserDefaults.standard.set("bk", forKey: "registerUser");
        UserDefaults.standard.synchronize();
        
        loguinUserAction(userLogged: login!);
    }
}


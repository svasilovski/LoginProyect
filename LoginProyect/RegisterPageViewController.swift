//
//  RegisterPageViewController.swift
//  LoginProyect
//
//  Created by SAMUEL on 24/2/18.
//  Copyright © 2018 SAMUEL VASILOVSKI. All rights reserved.
//

import UIKit

class RegisterPageViewController: CallWsClass {
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPaswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

    override func resultProcess(intEstado: Int, txtUsuario: String?, arrReferencia: [String]) {
        var messageToDisplay:String;
        var isUserRegister: Bool = false;
        
        if(arrReferencia[intEstado] == "OK") {
            isUserRegister = true;
            messageToDisplay = "The \"\(txtUsuario!)\" user adding correctly.";
        }
        else{
            messageToDisplay = arrReferencia[intEstado];
        }
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            DispatchQueue.main.async { // 2
                let myAlert = self.displayMyAlertMessage(messageToDisplay, addButton: !isUserRegister);
                if(isUserRegister){
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ action in
                        self.dismiss(animated: true, completion: nil)
                    }
                    myAlert.addAction(okAction);
                }
                self.present(myAlert, animated: true, completion: nil);
            }
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPasswd = userRepeatPaswordTextField.text;
        var myAlert: UIAlertController?;
        
        // Check for empty field.
        if(userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPasswd!.isEmpty) {
            // Display an alert message
            myAlert = displayMyAlertMessage("All fields are required.");
            self.present(myAlert!, animated: true, completion: nil);
            return;
        }
        
        // Check if passwd mach
        if(userPassword != userRepeatPasswd){
            // Display an alert message
            myAlert = displayMyAlertMessage("Password do not match.");
            self.present(myAlert!, animated: true, completion: nil);
            return;
        }
        
        let newUser: [String: Any] = ["usuario": userEmail!, "password": userPassword!];
        let myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/agregarUsuario");
        connection(myUrl: myUrl!, httpBody: newUser);
    }
        /*
        let myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/agregarUsuario");
        let request = NSMutableURLRequest(url: myUrl! as URL);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let newUser: [String: Any] = ["usuario": userEmail!, "password": userPassword!];
        let jsonTodo: Data;
        do{
            jsonTodo = try JSONSerialization.data(withJSONObject: newUser, options: []);
            request.httpBody = jsonTodo;
        }catch{
            myAlert = self.displayMyAlertMessage("Error: Cannot create JSON from User.");
            self.present(myAlert!, animated: true, completion: nil);
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
            
            //let json: AnyObject?
            do {
                let intEstado: Int;
                var txtUsuario: String? = nil;
                let arrReferencia: [String];
                
                if let datos = String(data: data, encoding: .utf8)?.data(using: .utf8){
                    let dicDatos = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any];
                    if let datoStr=dicDatos!["data"] as? [String: Any] {
                        if let estado=datoStr["status"] as? Int {
                            intEstado = estado;
                        } else {
                            return;
                        }
                        if let usuario=datoStr["usuario"] as? String {
                            txtUsuario = usuario;
                        }
                    } else {
                        return;
                    };
                    
                    if let referencia=dicDatos!["references"] as? [String] {
                        arrReferencia = referencia;
                    } else {
                        return;
                    };
                    
                    if (!(arrReferencia.count > 0) && arrReferencia.count <= intEstado){
                        myAlert = self.displayMyAlertMessage("error: status out of range.");
                        self.present(myAlert!, animated: true, completion: nil);
                        return;
                    }
                    var messageToDisplay:String;
                    var isUserRegister: Bool = false;
                    if(arrReferencia[intEstado] == "OK") {
                        isUserRegister = true;
                        messageToDisplay = "The \"\(txtUsuario!)\" user adding correctly.";
                    }
                    else{
                        messageToDisplay = arrReferencia[intEstado];
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async { // 1
                        DispatchQueue.main.async { // 2
                            // Display Alert message with confirmation
                            /*
                            let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ action in
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            myAlert.addAction(okAction);
                            self.present(myAlert, animated: true, completion: nil);
                             */
                            myAlert = self.displayMyAlertMessage(messageToDisplay, addButton: !isUserRegister);
                            if(isUserRegister){
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ action in
                                    self.dismiss(animated: true, completion: nil)
                                }
                                myAlert?.addAction(okAction);
                            }
                            self.present(myAlert!, animated: true, completion: nil);
                        }
                    }
                }
            } catch {
                let mensaje = "failed: \(String(describing: error))";
                myAlert = self.displayMyAlertMessage(mensaje);
                self.present(myAlert!, animated: true, completion: nil);
                return;
            }
        }
        
        task.resume();
        
        /*
         // Store data.
         let defaults = UserDefaults.standard;
         defaults.set(userEmail, forKey: "userEmail");
         defaults.set(userPassword, forKey: "userPassword");
         
        // Display alert message with confirmation.
        let myAlert = UIAlertController(
            title: "Alert",
            message: "Registration is successfull. Tank You!",
            preferredStyle: UIAlertControllerStyle.alert
        );
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.default
        ){
            //(action) -> Void in
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        myAlert.addAction(okAction);
        
        self.present(
            myAlert,
            animated: true,
            completion: nil
        );
        
        /*self.presentViewController(
            myAlert,
            animated: true,
            completion: nil
        );*/
        */
    }
    /*
    func displayMyAlertMessage(_ userMessage:String){
        let myAlert = UIAlertController(
            title: "Alert",
            message: userMessage,
            preferredStyle: UIAlertControllerStyle.alert
        );
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        
        myAlert.addAction(okAction);
        
        self.present(
            myAlert,
            animated: true,
            completion: nil
        );
        
        /*self.presentViewController(
            myAlert,
            animated: true,
            completion: nil
        );*/
    }*/
    */
}

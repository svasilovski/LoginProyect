//
//  LoginViewController.swift
//  LoginProyect
//
//  Created by SAMUEL on 25/2/18.
//  Copyright © 2018 SAMUEL VASILOVSKI. All rights reserved.
//

import UIKit

class LoginViewController: CallWsClass {

    @IBOutlet weak var userEmailTextfield: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func resultProcess(intEstado: Int, txtUsuario: String?, arrReferencia: [String]) {
        var messageToDisplay:String? = nil;
        if(arrReferencia[intEstado] == "OK" || arrReferencia[intEstado] == "Password correcta") {
            // Login is successfull
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
            UserDefaults.standard.set(txtUsuario, forKey: "logginUser");
            UserDefaults.standard.synchronize();
            
            self.dismiss(animated: true, completion: nil);
        }
        else{
            messageToDisplay = arrReferencia[intEstado];
        }
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            DispatchQueue.main.async { // 2
                if(messageToDisplay != nil && !(messageToDisplay!.isEmpty)){
                    let myAlert = self.displayMyAlertMessage(messageToDisplay!);
                    self.present(myAlert, animated: true, completion: nil);
                }
            }
        };
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let userEmail = userEmailTextfield.text;
        let userPassword = userPasswordTextField.text;

        if(userEmail!.isEmpty || userPassword!.isEmpty){
            return;
        }
        
        let newUser: [String: Any] = ["usuario": userEmail!, "password": userPassword!];
        let myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/validarUsuario");
        connection(myUrl: myUrl!, httpBody: newUser);
    }
        /*
        let myUrl = NSURL(string: "http://192.168.0.32:8000/usuario/validarUsuario");
        let request = NSMutableURLRequest(url: myUrl! as URL);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let newUser: [String: Any] = ["usuario": userEmail!, "password": userPassword!];
        let jsonTodo: Data;
        do{
            jsonTodo = try JSONSerialization.data(withJSONObject: newUser, options: []);
            request.httpBody = jsonTodo;
        }catch{
            myAlert = displayMyAlertMessage("Error: Cannot create JSON from User.");
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
                var txtUsuario: String?;
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
                    if(arrReferencia[intEstado] == "OK" || arrReferencia[intEstado] == "Password correcta") {
                        // Login is successfull
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                        UserDefaults.standard.synchronize();
                        
                        self.dismiss(animated: true, completion: nil);
                        messageToDisplay = "Welcome \(String(describing: txtUsuario)).";
                    }
                    else{
                        messageToDisplay = arrReferencia[intEstado];
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async { // 1
                        DispatchQueue.main.async { // 2
                            myAlert = self.displayMyAlertMessage(messageToDisplay);
                            self.present(myAlert!, animated: true, completion: nil);
                        }
                    };
                }
            } catch {
                let mensaje = "failed: \(String(describing: error))";
                myAlert = self.displayMyAlertMessage(mensaje);
                self.present(myAlert!, animated: true, completion: nil);
                return;
            };
        };
        
        task.resume();
        */
        
        /*
        let userEmailStored = UserDefaults.standard.string(forKey: "userEmail");
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword");
        
        if(userEmailStored == userEmail){
            if(userPasswordStored == userPassword){
                // Login is successfull
                UserDefaults.standard.set(
                    true,
                    forKey: "isUserLoggedIn"
                );
                UserDefaults.standard.synchronize();
                
                self.dismiss(
                    animated: true,
                    completion: nil
                );
            }
        }
        */
    //}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

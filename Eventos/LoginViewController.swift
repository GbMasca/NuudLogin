//
//  LoginViewController.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 22/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    var canLogin : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        loginButton.isEnabled = false
        errorMsg.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    func updateButtonColor(){
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            let color = UIColor(red: 57, green: 222, blue: 191)
            loginButton.isEnabled = true
            loginButton.setTitleColor(color, for: .normal)
        }
        else{
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            loginButton.isEnabled = false
            loginButton.setTitleColor(color, for: .normal)
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonColor()
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            loginPressed(self)
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMsg.text = ""
    }
    @objc func viewTapped(){
        dismissKeyboard()
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                self.decodeErrorMsg(error: error!)
            }
            else{
                print("login: Deu")
                self.errorMsg.text = "Login feito"
            }
        }
    }
    
    func decodeErrorMsg(error: Error){
        
        let errorStr = String(describing: error)
        
        let indexOfError = errorStr.index(of: "1") ?? errorStr.endIndex
        let indexOfError2 = errorStr.index(of: "\"") ?? errorStr.endIndex
        
        let str = errorStr[indexOfError..<indexOfError2]
        
        let errorCode = (str as NSString).integerValue
        
        updateErrorMsg(error: errorCode)
        
        print("Aqui", (str as NSString).integerValue, "Aqui")
    }
    
    func updateErrorMsg(error: Int){
        if error == 17009{
            errorMsg.text = "Senha incorreta"
            passwordTextField.text = ""
            updateButtonColor()
        }
        if error == 17011{
            errorMsg.text = "Email não cadastrado"
            passwordTextField.text = ""
            updateButtonColor()
        }
    }
}

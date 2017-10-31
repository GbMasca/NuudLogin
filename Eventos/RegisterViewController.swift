//
//  RegisterViewController.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 22/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    
    var canRegister : Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordCheckTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        errorMsg.text = ""
        registerButton.isEnabled = false
    
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMsg.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordCheckTextField{
            checkForErrors()
        }
        
        updateButtonColor()
        
    }
    
    func updateButtonColor(){
        
        if emailTextField.text != "" && nameTextField.text != "" && passwordTextField.text != "" && passwordCheckTextField.text != ""{
            let color = UIColor(red: 57, green: 222, blue: 191)
            registerButton.isEnabled = true
            registerButton.setTitleColor(color, for: .normal)
        }
        else{
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            registerButton.isEnabled = false
            registerButton.setTitleColor(color, for: .normal)
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        passwordCheckTextField.resignFirstResponder()
        
        if emailTextField.text != "" && nameTextField.text != "" && passwordTextField.text != "" && passwordCheckTextField.text != ""{
            registerPressed(self)
        }
        
        return true
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
    
    @IBAction func registerPressed(_ sender: Any) {
        
        canRegister = true
        checkForErrors()
        
        if canRegister{
            createUser(email: emailTextField.text!, password: passwordTextField.text!)
        }
        else{
            print("falha na criacao")
        }
    }
    
    func checkForErrors(){
        checkForPasswordEquality()
    }
    
    func checkForPasswordEquality(){
        
        if passwordTextField.text == nil{
            canRegister = false
        }
        
        if passwordTextField.text != passwordCheckTextField.text{
            updateErrorMsg(error: 17000)
            canRegister = false
        }
    }
    
    
    func createUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print("Esse é o erro \(error!) Esse é o erro")
                self.decodeErrorMsg(error: error!)
                //Error Domain=FIRAuthErrorDomain Code=17007 "The email address is already in use by another account." UserInfo={NSLocalizedDescription=The email address is already in use by another account., error_name=ERROR_EMAIL_ALREADY_IN_USE}
            }
            else{
                self.errorMsg.text = "Cadastro feito com sucesso"
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
        if error == 17007{
            errorMsg.text = "Email já cadastrado"
            emailTextField.text = ""
            updateButtonColor()
        }
        if error == 17026{
            errorMsg.text = "Senha muito peguena"
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            updateButtonColor()
        }
        if error == 17008{
            errorMsg.text = "Email invalido"
            emailTextField.text = ""
            updateButtonColor()
        }
        if error == 17000{
            errorMsg.text = "Senhas não iguais"
            updateButtonColor()
        }
    }
    
}

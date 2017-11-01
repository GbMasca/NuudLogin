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
    // MARK: - Declare instance variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    var canRegister : Bool = true
    var isComplete : Bool = true

    
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
        errorView.isHidden = true
        errorViewHeightConstraint.constant = 68
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
    
    // MARK: - Text Field Related
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var shouldHide = true
        if textField != passwordCheckTextField{
            shouldHide = checkForPasswordEquality()
        }
        if shouldHide{
            UIView.animate(withDuration: 0.5, animations: {
                self.errorViewHeightConstraint.constant = 68
                self.errorMsg.text = ""
                self.view.layoutIfNeeded()
            }) { (canHide) in
                if canHide{
                    self.errorView.isHidden = true
                }
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordCheckTextField{
            checkPasswordEquality()
        }
        updateButtonColor()
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
    
    

    
    // MARK: - Error Ckecking and button update
    func updateButtonColor(){
        if emailTextField.text != "" && nameTextField.text != "" && passwordTextField.text != "" && passwordCheckTextField.text != ""{
            let color = UIColor(red: 57, green: 222, blue: 191)
            registerButton.setTitleColor(color, for: .normal)
        }
        else{
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            registerButton.setTitleColor(color, for: .normal)
        }
    }
    func checkForErrors(){
        canRegister = checkForPasswordEquality()
        isComplete = checkForComplition()
    }
    
    func checkForComplition() -> Bool {
        if emailTextField.text != "" && nameTextField.text != "" && passwordTextField.text != "" && passwordCheckTextField.text != ""{
            return true
        }
        else{
            updateErrorMsg(error: 16000)
            return false
        }
    }
    
    func checkForPasswordEquality() -> Bool{
        if passwordTextField.text == nil{
            return false
        }
        if passwordTextField.text != passwordCheckTextField.text{
            updateErrorMsg(error: 17000)
            return false
        }
        else{
           return true
        }
    }
    
    func checkPasswordEquality(){
        if passwordTextField.text != passwordCheckTextField.text{
            updateErrorMsg(error: 17000)
        }
    }
    
    // MARK: - Error Msg Update
    
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
            emailTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "EMAIL JÁ CADASTRADO"
                self.view.layoutIfNeeded()
            })
            updateButtonColor()
        }
        if error == 17026{
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "SENHA MUITO PEQUENA"
                self.view.layoutIfNeeded()
            })
            //print(errorMsg.text)
            updateButtonColor()
        }
        if error == 17008{
            emailTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "EMAIL INVALIDO"
                self.view.layoutIfNeeded()
            })
            updateButtonColor()
        }
        if error == 17000{
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "SENHAS NÃO CORRESPONDEM"
                self.view.layoutIfNeeded()
            })
            updateButtonColor()
        }
        if error == 16000{
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "CAMPOS NÃO PREENCHIDOS"
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Create User
    
    @IBAction func registerPressed(_ sender: Any) {
        
        canRegister = true
        isComplete = true
        checkForErrors()
        
        
        if canRegister && isComplete{
            createUser(email: emailTextField.text!, password: passwordTextField.text!)
        }
        else{
            print("falha na criacao")
        }
    }
    func createUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print("Esse é o erro \(error!) Esse é o erro")
                self.decodeErrorMsg(error: error!)
            }
            else{
                self.registerButton.setTitle("REGISTROU", for: .normal)
            }
        }
    }
}

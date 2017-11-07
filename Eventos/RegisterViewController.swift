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
    @IBOutlet weak var registerButton: UIButton!
    
    var canRegister : Bool = true
    var isComplete : Bool = true
    
    var errorView : UIView = UIView()
    var windowWidth = CGFloat(0)
    var windowHeight = CGFloat(0)
    var errorMsg : UILabel = UILabel()
    var ops : UILabel = UILabel()
    
    var userData : [String: String] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordCheckTextField.delegate = self
        windowWidth = self.view.frame.size.width
        windowHeight = self.view.frame.size.height
        
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 0))
        self.view.addSubview(errorView)
        UIApplication.shared.keyWindow!.addSubview(errorView)
        errorView.backgroundColor = UIColor(red: 255, green: 108, blue: 108)
        
        populateErrorView()
        editTextField()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
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
    override func viewWillDisappear(_ animated: Bool) {
        hide()
    }
    
    // MARK: - Text Field Related
    
    func editTextField(){
        let color : CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        
        emailTextField.layer.borderColor = color
        emailTextField.layer.borderWidth = 2
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.masksToBounds = true
        emailTextField.textAlignment = .natural
        
        passwordTextField.layer.borderColor = color
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textAlignment = .natural
        
        nameTextField.layer.borderColor = color
        nameTextField.layer.borderWidth = 2
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.masksToBounds = true
        nameTextField.textAlignment = .natural
        
        passwordCheckTextField.layer.borderColor = color
        passwordCheckTextField.layer.borderWidth = 2
        passwordCheckTextField.layer.cornerRadius = 8
        passwordCheckTextField.layer.masksToBounds = true
        passwordCheckTextField.textAlignment = .natural
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
            //registerButton.isEnabled = true
        }
        else{
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            registerButton.setTitleColor(color, for: .normal)
            //registerButton.isEnabled = false
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
                self.unhide(error: "EMAIL JÁ CADASTRADO")
                self.view.layoutIfNeeded()
            }, completion: { (canHide) in
                if canHide{
                    UIView.animate(withDuration: 0.5, delay: 2, animations: {
                        self.hide()
                    })
                }
            })
            updateButtonColor()
        }
        if error == 17026{
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.unhide(error: "SENHA MUITO PEQUENA")
                self.view.layoutIfNeeded()
            }, completion: { (canHide) in
                if canHide{
                    UIView.animate(withDuration: 0.5, delay: 2, animations: {
                        self.hide()
                    })
                }
            })
            //print(errorMsg.text)
            updateButtonColor()
        }
        if error == 17008{
            emailTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.unhide(error: "EMAIL INVALIDO")
                self.view.layoutIfNeeded()
            }, completion: { (canHide) in
                if canHide{
                    UIView.animate(withDuration: 0.5, delay: 2, animations: {
                        self.hide()
                    })
                }
            })
            updateButtonColor()
        }
        if error == 17000{
            UIView.animate(withDuration: 0.5, animations: {
                self.unhide(error: "SENHAS NÃO CORRESPONDEM")
                self.view.layoutIfNeeded()
            }, completion: { (canHide) in
                if canHide{
                    UIView.animate(withDuration: 0.5, delay: 2, animations: {
                        self.hide()
                    })
                }
            })
            updateButtonColor()
        }
        if error == 16000{
            UIView.animate(withDuration: 0.5, animations: {
                self.unhide(error: "CAMPOS NÃO PREENCHIDOS")
                self.view.layoutIfNeeded()
            }, completion: { (canHide) in
                if canHide{
                    UIView.animate(withDuration: 0.5, delay: 2, animations: {
                        self.hide()
                    })
                }
            })
        }
    }
    
    func unhide(error: String) {
        self.errorView.frame = CGRect(x: 0, y: 0, width: self.windowWidth, height: 85)
        self.ops.frame = CGRect(x: 16, y: (errorView.frame.height - 55), width: (errorView.frame.width - 32), height: 21)
        self.errorMsg.frame = CGRect(x: 16, y: (errorView.frame.height - 35), width: (errorView.frame.width - 32), height: 21)
        errorMsg.text = error
    }
    
    func hide(){
        self.errorView.frame = CGRect(x: 0, y: 0, width: self.windowWidth, height: 0)
        self.ops.frame = CGRect(x: 16, y: (errorView.frame.height - 55), width: (errorView.frame.width - 32), height: 0)
        self.errorMsg.frame = CGRect(x: 16, y: (errorView.frame.height - 35), width: (errorView.frame.width - 32), height: 0)
    }
    func populateErrorView(){
        
        ops = UILabel(frame: CGRect(x: 16, y: (errorView.frame.height - 55), width: (errorView.frame.width - 32), height: 0))
        ops.text = "OPS!"
        ops.textAlignment = .center
        ops.textColor = UIColor.white
        ops.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(14))
        errorView.addSubview(ops)
        
        errorMsg = UILabel(frame: CGRect(x: 16, y: (errorView.frame.height - 35), width: (errorView.frame.width - 32), height: 0))
        errorMsg.text = ""
        errorMsg.textColor = UIColor.white
        errorMsg.textAlignment = .center
        errorMsg.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(11))
        errorView.addSubview(errorMsg)
        
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
                self.registerButton.isEnabled = true
                self.userData = ["Name": self.nameTextField.text!,"Email": self.emailTextField.text!, "Photo": ""]
                self.addToDB(data: self.userData)
                self.performSegue(withIdentifier: "goToWelcomingPage", sender: self)
            }
        }
    }
    func addToDB(data: [String:String]){
        let userID = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users")
        userDB.child(userID!).setValue(data)
    }
}

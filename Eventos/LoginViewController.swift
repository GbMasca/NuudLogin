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
    
    // MARK: - Declare Instace Variables
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    
    var canLogin : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        errorMsg.text = ""
        errorView.isHidden = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            loginPressed(self)
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonColor()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
    
    // MARK: - Button Update
    
    func updateButtonColor(){
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            let color = UIColor(red: 57, green: 222, blue: 191)
            loginButton.setTitleColor(color, for: .normal)
        }
        else{
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            updateErrorMsg(error: 16000)
            loginButton.setTitleColor(color, for: .normal)
        }
    }
    
    // MARK: - Register User
    
    @IBAction func loginPressed(_ sender: Any) {
    
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print("Aqui o erro", error!)
                self.decodeErrorMsg(error: error!)
            }
            else{
                print("login: Deu")
                //self.loginButton.setTitle("LOGOU", for: .normal)
            }
        }
    }
    
    // MARK: - Error Msg
    
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
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "SENHA INCORRETA"
                self.view.layoutIfNeeded()
            })
            updateButtonColor()
        }
        if error == 17011{
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "EMAIL NÃO CADASTRADO"
                self.view.layoutIfNeeded()
            })
        }
        if error == 17008{
            UIView.animate(withDuration: 0.5, animations: {
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 149
                self.errorMsg.text = "EMAIL INVALIDO"
                self.view.layoutIfNeeded()
            })
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
}

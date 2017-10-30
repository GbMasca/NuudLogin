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
    @IBOutlet weak var emailCheckTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    
    var canRegister : Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func loginWithFacebookPressed(_ sender: Any) {
        
        
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if error != nil {
                    print(error!)
                }
                else{
                    print("login com FB feito")
                    self.performSegue(withIdentifier: "goToSetUpPasswordPage", sender: self)
                }
            })
        }
    }
        
    
    func checkForErrors(){
        
        checkForEmailEquality()
        checkForPasswordEquality()
    }
    
    func checkForEmailEquality(){
        
        if emailTextField.text == nil{
            canRegister = false
        }
        
        if emailTextField.text != emailCheckTextField.text {
            print("email no bate")
            canRegister = false
            emailCheckTextField.text = ""
        }
        else{
            print("Email checking done")
        }
    }
    
    func checkForPasswordEquality(){
        
        if passwordTextField.text == nil{
            canRegister = false
        }
        
        if passwordTextField.text != passwordCheckTextField.text{
            print("Senha no bate")
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            canRegister = false
        }
        else{
            print("password checking done")
        }
    }
    
    func checkForExistence(username: String){
        
        let userListSnapshot = DataSnapshot()
        
        if !userListSnapshot.hasChild("UserList/\(username)"){
            
            print("Existence Check")
        }
        else{
            print("Usuario ja cadastrado")
            canRegister = false
        }
    }
    
    func createUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print("Esse é o erro \(error!) Esse é o erro")
                //updateErrorMsg(error: error!)
                //Error Domain=FIRAuthErrorDomain Code=17007 "The email address is already in use by another account." UserInfo={NSLocalizedDescription=The email address is already in use by another account., error_name=ERROR_EMAIL_ALREADY_IN_USE}
            }
            else{
                print("deu")
                self.performSegue(withIdentifier: "goToSetUpProfilePage" , sender: self)
            }
        }
        
    }

}

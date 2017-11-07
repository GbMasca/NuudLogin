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

class LoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    
    // MARK: - Declare Instace Variables
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var canLogin : Bool = true
    var isComplete : Bool = true
    var errorView : UIView = UIView()
    var windowWidth : CGFloat = CGFloat(0)
    var windowHeight : CGFloat = CGFloat(0)
    var errorMsg : UILabel = UILabel()
    var ops : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        windowWidth = self.view.frame.size.width
        windowHeight = self.view.frame.size.height
        
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 0))
        self.view.addSubview(errorView)
        UIApplication.shared.keyWindow!.addSubview(errorView)
        errorView.backgroundColor = UIColor(red: 255, green: 108, blue: 108)
        
        populateErrorView()
        editTextField()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped(){
        dismissKeyboard()
        hide()
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    }
    
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
        
    }
    
    // MARK: - Button Update and Error Checking
    
    func updateButtonColor(){
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            let color = UIColor(red: 57, green: 222, blue: 191)
            loginButton.setTitleColor(color, for: .normal)
        }
        else{
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            //updateErrorMsg(error: 16000)
            loginButton.setTitleColor(color, for: .normal)
        }
    }
    func checkForCompletion() -> Bool {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            return true
        }
        else{
            updateErrorMsg(error: 16000)
            return false
        }
    }
    
    // MARK: - Login User
    
    @IBAction func loginPressed(_ sender: Any) {
        
        isComplete = checkForCompletion()
        if isComplete{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    self.decodeErrorMsg(error: error!)
                }
                else{
                    print("login: Deu")
                    //self.loginButton.setTitle("LOGOU", for: .normal)
                }
            }
        }
    }
    @IBAction func loginFacebookPressed(_ sender: Any) {
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
                }
            })
        }
    }
    
    // MARK: - Error Msg
    
    func decodeErrorMsg(error: Error){
        
        let errorStr : String = String(describing: error)
        
        let indexOfError = errorStr.index(of: "1") ?? errorStr.endIndex
        let indexOfError2 = errorStr.index(of: "\"") ?? errorStr.endIndex
        let str = errorStr[indexOfError..<indexOfError2]
        let errorCode = (str as NSString).integerValue
        updateErrorMsg(error: errorCode)
    }
    
    func updateErrorMsg(error: Int){
        
        if error == 17009{
            passwordTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.unhide(error: "SENHA INCORRETA")
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
        if error == 17011{
            emailTextField.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.unhide(error: "EMAIL NÃO CADASTRADO")
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
}

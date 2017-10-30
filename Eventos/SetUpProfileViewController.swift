//
//  SetUpProfileViewController.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 25/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

class SetUpProfileViewController: UIViewController {

    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileLastNameTextField: UITextField!
    @IBOutlet weak var profileEmailTextField: UITextField!
    @IBOutlet weak var profilePhoneTextField: UITextField!
    var profilePicture : String?
    
    var userData : [String: String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileEmailTextField.text = Auth.auth().currentUser?.email
        
        if FBSDKAccessToken.current() != nil{
            profileNameTextField.text = FBSDKProfile.current().firstName
            profileLastNameTextField.text = FBSDKProfile.current().lastName
        }
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        userData = ["FirstName": profileNameTextField.text!, "LastName": profileLastNameTextField.text!, "Email": profileEmailTextField.text!, "Phone": profilePhoneTextField.text!]
        let userID = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users")
        
        userDB.child(userID!).setValue(userData)
        
        performSegue(withIdentifier: "goToLoggedPage", sender: self)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SetUpPasswordViewController.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 25/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import Firebase

class SetUpPasswordViewController: UIViewController {

    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    var canSetUp : Bool = true
    
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setUpPressed(_ sender: Any) {
        checkForError()
        if canSetUp{
            Auth.auth().currentUser?.updatePassword(to: passwordTextField.text!, completion: { (error) in
                if error != nil{
                    print (error!)
                }
                else{
                    print("Mudou a senha com sucesso")
                    self.performSegue(withIdentifier: "goToSetUpProfilePage", sender: self)
                }
            })
            
        }
        
        
    }
    
    func checkForError(){
        if passwordTextField.text! != passwordCheckTextField.text!{
            canSetUp = false
            updateErrorMsg(error: 1)
            if passwordTextField.text!.count < 6{
                canSetUp = false
                updateErrorMsg(error: 2)
            }
        }
    }
    
    func updateErrorMsg(error: Int){
        
        if error == 1{
            errorMsgLabel.text = "Senhas diferentes"
        }
        if error == 2{
            errorMsgLabel.text = "Senha muito pequena. Ela deve conter no minimo 6 caracteres"
        }
        
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

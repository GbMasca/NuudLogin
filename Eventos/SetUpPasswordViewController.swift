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

    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setUpPressed(_ sender: Any) {
        Auth.auth().currentUser?.updatePassword(to: passwordTextField.text!, completion: { (error) in
            if error != nil{
                print (error!)
            }
            else{
                print("Mudou a senha com sucesso")
                self.performSegue(withIdentifier: "goToLoggedPage", sender: self)
            }
        })
        
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

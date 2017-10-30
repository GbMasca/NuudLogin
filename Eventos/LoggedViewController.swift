//
//  LoggedViewController.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 23/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class LoggedViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
            label.text = Auth.auth().currentUser?.email

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        var errorHappened = false
        do{
            try Auth.auth().signOut()
            print("deu")
        }
        catch{
            print("error")
            errorHappened = true
        }
        
        if !errorHappened{
            performSegue(withIdentifier: "BackToStart", sender: self)
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

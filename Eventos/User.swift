//
//  File.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 23/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import Foundation

class User{
    
    let name : String?
    //let username : String?
    let email : String?
    
    init(email: String, name: String) {
        
        self.name = name
        self.email = email
        
    }
}

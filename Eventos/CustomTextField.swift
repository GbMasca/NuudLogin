//
//  File.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 04/11/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import Foundation
import UIKit


class CustomTextField: UITextField {
    
    var paddingLeft : CGFloat = 15
    var paddingRight : CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

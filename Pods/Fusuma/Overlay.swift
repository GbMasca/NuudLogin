//
//  Overlay.swift
//  Bolts
//
//  Created by Gabriel Mascarenhas on 07/11/2017.
//

import Foundation

class Overlay {
    var radius: CGFloat!
    var XOffset: CGFloat!
    var YOffset: CGFloat!
    var viewFrame: CGRect!
    var overlay: UIView?
    
    init(frame: CGRect, XOffset: CGFloat, YOffset: CGFloat, radius: CGFloat){
        self.radius = radius
        self.XOffset = XOffset
        self.YOffset = YOffset
        self.viewFrame = frame
        self.overlay = self.createOverlay(frame: frame, xOffset: XOffset, yOffset: YOffset, radius: radius)
    }
    
    func createOverlay(frame : CGRect, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView
    {
        let overlayView = UIView(frame: frame)
        overlayView.alpha = 0.6
        overlayView.backgroundColor = UIColor.black
        
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: xOffset, y: yOffset), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
}

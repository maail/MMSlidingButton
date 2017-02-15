//
//  MMSlidingButton.swift
//  MMSlidingButton
//
//  Created by Mohamed Maail on 6/7/16.
//  Copyright © 2016 Mohamed Maail. All rights reserved.
//

import Foundation
import UIKit

protocol SlideButtonDelegate{
    func buttonStatus(status:String, sender:MMSlidingButton)
}

@IBDesignable class MMSlidingButton: UIView{
    
    var delegate: SlideButtonDelegate?
    
    @IBInspectable var dragPointWidth: CGFloat = 70 {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var dragPointColor: UIColor = UIColor.darkGray {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonColor: UIColor = UIColor.gray {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonText: String = "UNLOCK" {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var imageName: UIImage = UIImage() {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var dragPointTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonUnlockedTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 30 {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonUnlockedText: String   = "UNLOCKED"
    @IBInspectable var buttonUnlockedColor: UIColor = UIColor.black
    var buttonFont                                  = UIFont.boldSystemFont(ofSize: 17)
    
    
    var dragPoint            = UIView()
    var buttonLabel          = UILabel()
    var dragPointButtonLabel = UILabel()
    var imageView            = UIImageView()
    var unlocked             = false
    var layoutSet            = false
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func layoutSubviews() {
        if !layoutSet{
            self.setUpButton()
            self.layoutSet = true
        }
    }
    
    func setStyle(){
        self.buttonLabel.text               = self.buttonText
        self.dragPointButtonLabel.text      = self.buttonText
        self.dragPoint.frame.size.width     = self.dragPointWidth
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.backgroundColor                = self.buttonColor
        self.imageView.image                = imageName
        self.buttonLabel.textColor          = self.buttonTextColor
        self.dragPointButtonLabel.textColor = self.dragPointTextColor
        
        self.dragPoint.layer.cornerRadius   = buttonCornerRadius
        self.layer.cornerRadius             = buttonCornerRadius
    }
    
    func setUpButton(){
        
        self.backgroundColor              = self.buttonColor
        
        self.dragPoint                    = UIView(frame: CGRect(x: dragPointWidth - self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.dragPoint.backgroundColor    = dragPointColor
        self.dragPoint.layer.cornerRadius = buttonCornerRadius
        self.addSubview(self.dragPoint)
        
        if !self.buttonText.isEmpty{
            
            self.buttonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.buttonLabel.textAlignment = .center
            self.buttonLabel.text          = buttonText
            self.buttonLabel.textColor     = UIColor.white
            self.buttonLabel.font          = self.buttonFont
            self.buttonLabel.textColor     = self.buttonTextColor
            self.addSubview(self.buttonLabel)
            
            self.dragPointButtonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.dragPointButtonLabel.textAlignment = .center
            self.dragPointButtonLabel.text          = buttonText
            self.dragPointButtonLabel.textColor     = UIColor.white
            self.dragPointButtonLabel.font          = self.buttonFont
            self.dragPointButtonLabel.textColor     = self.dragPointTextColor
            self.dragPoint.addSubview(self.dragPointButtonLabel)
        }
        self.bringSubview(toFront: self.dragPoint)
        
        if self.imageName != UIImage(){
            self.imageView = UIImageView(frame: CGRect(x: self.frame.size.width - dragPointWidth, y: 0, width: self.dragPointWidth, height: self.frame.size.height))
            self.imageView.contentMode = .center
            self.imageView.image = self.imageName
            self.dragPoint.addSubview(self.imageView)
        }
        
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    func panDetected(sender: UIPanGestureRecognizer){
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        sender.view?.frame.origin.x = (dragPointWidth - self.frame.size.width) + translatedPoint.x
        if sender.state == .ended{
            
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX    = translatedPoint.x + velocityX
            if finalX < 0{
                finalX = 0
            }else if finalX + self.dragPointWidth  >  (self.frame.size.width - 60){
                unlocked = true
                self.unlock()
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
                }, completion: { (Status) in
                    if Status{
                        self.animationFinished()
                    }
            })
        }
    }
    
    func animationFinished(){
        if !unlocked{
            self.reset()
        }
    }
    
    //lock button animation (SUCCESS)
    func unlock(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.dragPointButtonLabel.text      = self.buttonUnlockedText
                self.imageView.isHidden               = true
                self.dragPoint.backgroundColor      = self.buttonUnlockedColor
                self.dragPointButtonLabel.textColor = self.buttonUnlockedTextColor
                self.delegate?.buttonStatus(status: "Unlocked", sender: self)
            }
        }
    }
    
    //reset button animation (RESET)
    func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.dragPointWidth - self.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.dragPointButtonLabel.text      = self.buttonText
                self.imageView.isHidden               = false
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked                       = false
                //self.delegate?.buttonStatus("Locked")
            }
        }
    }
}

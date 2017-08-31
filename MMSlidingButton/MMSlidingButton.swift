//
//  MMSlidingButton.swift
//  MMSlidingButton
//
//  Created by Mohamed Maail on 6/7/16.
//  Copyright © 2016 Mohamed Maail. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SlideButtonDelegate{
    @available(*, unavailable, message: "Update to \"unlocked()\" delegate method")
    func buttonStatus(status:String, sender:MMSlidingButton)
    
    func unlocked(slidingButton: MMSlidingButton)
    
    @objc optional func didEnterUnlockRegion(slidingButton: MMSlidingButton)
    @objc optional func didExitUnlockRegion(slidingButton: MMSlidingButton)
    
}

@objc @IBDesignable class MMSlidingButton: UIView{
    
    weak var delegate: SlideButtonDelegate?
    
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
    
    @IBInspectable var offsetButtonTextByDragPointWidth: Bool = false {
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
    
    @IBInspectable var optionalButtonUnlockingText: String   = ""
    
    private(set) var dragPoint            = UIView()
    private(set) var buttonLabel          = UILabel()
    private(set) var dragPointButtonLabel = UILabel()
    private(set) var imageView            = UIImageView()
    private(set) var unlocked             = false
    private var layoutSet            = false
    
    private var isInsideUnlockRegion = false
    private var dispatchCounterFor_isInsideUnlockRegionDidChange : UInt16 = 0
    
    private var panGestureRecognizer : UIPanGestureRecognizer?
    
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
        else {
            let dragPointWidthDifference=(self.frame.size.width-self.dragPoint.frame.size.width);
            
            if (panGestureRecognizer?.state == UIGestureRecognizerState.began || panGestureRecognizer?.state == UIGestureRecognizerState.changed) {
                panGestureRecognizer?.isEnabled=false // NOTE: This is to cancel any current gesture during a rotation/resize.
                panGestureRecognizer?.isEnabled=true
                ////
                
                self.dragPoint.frame.origin.x=dragPointDefaultOriginX() + dragPointWidthDifference;
                
            }
            ////
            
            func fixWidths() {
                for (_, view) in [self.dragPoint, self.dragPointButtonLabel].enumerated() {
                    view.frame.size.width=view.frame.size.width + dragPointWidthDifference;
                    
                }
                
            }
            
            func fixOffsets() {
                self.dragPoint.frame.origin.x=self.dragPoint.frame.origin.x - dragPointWidthDifference;
                self.imageView.frame.origin.x=self.imageView.frame.origin.x + dragPointWidthDifference;
                
            }
            ////
            
            let widthsBeforeOffsets=(dragPointWidthDifference>=0);
            
            if (widthsBeforeOffsets) {
                fixWidths();
                
            } else {
                fixOffsets();
                
            }
            
            DispatchQueue.main.async {
                if (widthsBeforeOffsets) {
                    fixOffsets();
                    
                } else {
                    fixWidths();
                    
                }
                
            }
            
        }
        
    }
    
    private func dragPointButtonText() -> String {
        if (optionalButtonUnlockingText.count > 0) {
            return optionalButtonUnlockingText
            
        } else {
            return buttonText
            
        }
        
    }
    
    func setStyle(){
        self.buttonLabel.text               = self.buttonText
        self.dragPointButtonLabel.text      = dragPointButtonText()
        self.dragPoint.frame.size.width     = self.dragPointWidth
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.backgroundColor                = self.buttonColor
        self.imageView.image                = imageName
        self.buttonLabel.textColor          = self.buttonTextColor
        self.dragPointButtonLabel.textColor = self.dragPointTextColor
        
        self.dragPoint.layer.cornerRadius   = buttonCornerRadius
        self.layer.cornerRadius             = buttonCornerRadius
    }
    
    func dragPointDefaultOriginX() -> CGFloat {
        return dragPointWidth - self.frame.size.width;
        
    }
    
    func setUpButton(){
        
        self.backgroundColor              = self.buttonColor
        
        self.dragPoint                    = UIView(frame: CGRect(x: dragPointDefaultOriginX(), y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.dragPoint.autoresizingMask=[UIViewAutoresizing.flexibleHeight]
        
        self.dragPoint.backgroundColor    = dragPointColor
        self.dragPoint.layer.cornerRadius = buttonCornerRadius
        self.addSubview(self.dragPoint)
        
        if !self.buttonText.isEmpty{
            var dragPointX : CGFloat = 0;
            
            if offsetButtonTextByDragPointWidth
            {
                dragPointX=dragPointWidth;
                
            }
            ////
            
            self.buttonLabel               = UILabel(frame: CGRect(x: dragPointX, y: 0, width: self.frame.size.width - dragPointWidth, height: self.frame.size.height))
            self.buttonLabel.autoresizingMask=[UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            
            self.buttonLabel.textAlignment = .center
            self.buttonLabel.text          = buttonText
            self.buttonLabel.textColor     = UIColor.white
            self.buttonLabel.font          = self.buttonFont
            self.buttonLabel.textColor     = self.buttonTextColor
            self.addSubview(self.buttonLabel)
            
            self.dragPointButtonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.dragPointButtonLabel.textAlignment = .center
            self.dragPointButtonLabel.text          = dragPointButtonText()
            self.dragPointButtonLabel.textColor     = UIColor.white
            self.dragPointButtonLabel.font          = self.buttonFont
            self.dragPointButtonLabel.textColor     = self.dragPointTextColor
            self.dragPoint.addSubview(self.dragPointButtonLabel)
        }
        self.bringSubview(toFront: self.dragPoint)
        
        if self.imageName != UIImage(){
            self.imageView = UIImageView(frame: CGRect(x: self.frame.size.width - dragPointWidth, y: 0, width: self.dragPointWidth, height: self.frame.size.height))
            self.imageView.autoresizingMask=[UIViewAutoresizing.flexibleHeight]
            
            self.imageView.contentMode = .center
            self.imageView.image = self.imageName
            self.dragPoint.addSubview(self.imageView)
        }
        
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer!.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func panDetected(sender: UIPanGestureRecognizer){
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        sender.view?.frame.origin.x = min(0, max(dragPointWidth - self.frame.size.width, (dragPointWidth - self.frame.size.width) + translatedPoint.x));
        ////
        
        let velocityX=(sender.velocity(in: self).x * 0.2)
        
        let wasInsideUnlockRegion=isInsideUnlockRegion
        isInsideUnlockRegion=(((translatedPoint.x + velocityX) + self.dragPointWidth) > (self.frame.size.width - 60))
        
        if (wasInsideUnlockRegion != isInsideUnlockRegion) {
            isInsideUnlockRegionDidChange(newValue: isInsideUnlockRegion)
            
        }
        ////
        
        if (sender.state == .ended) {
            if (isInsideUnlockRegion) {
                unlocked = true
                self.unlock()
                
            }
            ////
            
            UIView.transition(with: self, duration: abs(Double(velocityX) * 0.0002) + 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                }, completion: { (Status) in
                    if Status {
                        self.animationFinished()
                    }
                    
            } )
            
        }
    }
    
    func animationFinished(){
        if !unlocked{
            self.reset()
        }
    }
    
    private func isInsideUnlockRegionDidChange(newValue : Bool) {
        dispatchCounterFor_isInsideUnlockRegionDidChange += 1
        let localCopyOf_dispatchCounterFor_isInsideUnlockRegionDidChange = dispatchCounterFor_isInsideUnlockRegionDidChange
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { // NOTE: This is meant to "debounce" the slide threshold.
            if (localCopyOf_dispatchCounterFor_isInsideUnlockRegionDidChange != self.dispatchCounterFor_isInsideUnlockRegionDidChange) {
                return
                
            }
            ////
            
            if (newValue) {
                self.delegate?.didEnterUnlockRegion?(slidingButton: self)
                
            } else {
                self.delegate?.didExitUnlockRegion?(slidingButton: self)
                
            }
            
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
                self.delegate?.unlocked(slidingButton: self)
            }
        }
    }
    
    //reset button animation (RESET)
    func reset(){
        if (isInsideUnlockRegion) {
            isInsideUnlockRegion=false
            ////
            
            isInsideUnlockRegionDidChange(newValue: false);
            
        }
        
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.dragPointWidth - self.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.dragPointButtonLabel.text      = self.dragPointButtonText()
                self.imageView.isHidden               = false
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked                       = false
            }
        }
    }
}

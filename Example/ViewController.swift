//
//  ViewController.swift
//  MMSlidingButton
//
//  Created by Mohamed Maail on 6/7/16.
//  Copyright © 2016 Mohamed Maail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //@IBOutlet weak var dragPoint: UIView!
    @IBOutlet weak var fullView: MMSlidingButton!
    
    var dragPoint =  UIView()
    
    var locked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.dragPoint = UIView(frame: CGRectMake(0, 0, 50, self.fullView.frame.size.height))
//        self.dragPoint.backgroundColor = UIColor(red: 0.275, green: 0.511, blue: 0.625, alpha: 1)
//        self.fullView.addSubview(self.dragPoint)
//        
//        
//        // start detecting pan gesture
//        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panDetected(_:)))
//        panGestureRecognizer.minimumNumberOfTouches = 1
//        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
        
        
        
    }
    
    
//    func panDetected(sender: UIPanGestureRecognizer){
//        print("pan detected")
//        
//        var firstX:CGFloat = 0
//        var firstY:CGFloat = 0
//        
//        var translatedPoint = sender.translationInView(self.fullView)
//        if sender.state == .Began{
//            firstX = 0
//            firstY = 0
//        }
//        translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + self.fullView.frame.size.height / 2)
//        
//         print("First X: \(firstX + translatedPoint.x)")
//        
//        
//        sender.view?.center = translatedPoint
//        
//        if sender.state == .Ended{
//            let velocityX = sender.velocityInView(self.fullView).x * 0.2
//            
//            var finalX = translatedPoint.x + velocityX
//            let finalY = firstY + self.fullView.frame.size.height / 2
//            
//            
//            if finalX < 0{
//                finalX = 0
//            }else if finalX  >  (self.fullView.frame.size.width - self.dragPoint.frame.size.width){
//                finalX = self.fullView.frame.size.width - self.dragPoint.frame.size.width
//                locked = true
//                self.lockPoint()
//            }else{
//                let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
//                
//                print("Animation Duration: \(animationDuration)")
//                print("Final X: \(finalX), FullWidth: \(self.fullView.frame.size.width - self.dragPoint.frame.size.width)")
//                
//                UIView.beginAnimations(nil, context: nil)
//                UIView.setAnimationDuration(animationDuration)
//                UIView.setAnimationCurve(.EaseOut)
//                UIView.setAnimationDelegate(self)
//                UIView.setAnimationDidStopSelector( #selector(ViewController.animationFinished))
//                sender.view?.center = CGPointMake(finalX, finalY)
//                UIView.commitAnimations()
//            }
//            
//          
//            
//            
//            
//        }
//    }
//    
//    func animationFinished(){
//        if !locked{
//           self.resetPoint()
//        }else{
//            self.lockPoint()
//        }
//    }
//    
//    func lockPoint(){
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.2)
//        UIView.setAnimationCurve(.EaseOut)
//        UIView.setAnimationDelegate(self)
//        self.dragPoint.frame = CGRectMake(self.fullView.frame.size.width - self.dragPoint.frame.size.width, 0, self.dragPoint.frame.size.width, self.dragPoint.frame.size.height)
//        UIView.commitAnimations()
//    }
//    
//    func resetPoint(){
//        self.locked = false
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.2)
//        UIView.setAnimationCurve(.EaseOut)
//        UIView.setAnimationDelegate(self)
//        self.dragPoint.frame = CGRectMake(0, 0, self.dragPoint.frame.size.width, self.dragPoint.frame.size.height)
//        UIView.commitAnimations()
//    }
    
    @IBAction func resetClicked(sender: AnyObject) {
        self.fullView.resetPoint()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    -(void)move:(id)sender {
//    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
//    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
//    
//    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//    firstX = [[sender view] center].x;
//    firstY = [[sender view] center].y;
//    }
//    
//    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
//    
//    [[sender view] setCenter:translatedPoint];
//    
//    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//    CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
//    
//    
//    CGFloat finalX = translatedPoint.x + velocityX;
//    CGFloat finalY = firstY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
//    
//    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
//        if (finalX < 0) {
//        //finalX = 0;
//        } else if (finalX > 768) {
//        //finalX = 768;
//        }
//        
//        if (finalY < 0) {
//            finalY = 0;
//        } else if (finalY > 1024) {
//            finalY = 1024;
//        }
//    } else {
//        if (finalX < 0) {
//        //finalX = 0;
//        } else if (finalX > 1024) {
//        //finalX = 768;
//        }
//        
//        if (finalY < 0) {
//            finalY = 0;
//        } else if (finalY > 768) {
//            finalY = 1024;
//        }
//    }
//    
//    CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
//    
//    NSLog(@"the duration is: %f", animationDuration);
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
//    [[sender view] setCenter:CGPointMake(finalX, finalY)];
//    [UIView commitAnimations];
//    }
//    }


}


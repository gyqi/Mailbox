//
//  ViewController.swift
//  Mailbox
//
//  Created by Grace Qi on 2/16/16.
//  Copyright © 2016 Grace Qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    
    
    var messageImageViewOriginalCenter: CGPoint!
    var messageImageViewSwipedCenter: CGPoint!
    
    var messageViewOriginalColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1435)
        
        messageViewOriginalColor = messageView.backgroundColor
        messageImageViewOriginalCenter = messageImageView.center
        messageImageViewSwipedCenter = CGPoint(x: messageImageViewOriginalCenter.x - 320, y: messageImageViewOriginalCenter.y)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            messageImageView.center = CGPoint(x: messageImageViewOriginalCenter.x + translation.x, y: messageImageViewOriginalCenter.y)

            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            messageImageView.center = CGPoint(x: messageImageViewOriginalCenter.x + translation.x, y: messageImageViewOriginalCenter.y)
            print("original center: \(messageImageViewOriginalCenter)")
            print("translation: \(translation)")
            print("location: \(location)")
            if location.x <= 80 && velocity.x < 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 210.0 / 255.0, green: 167.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
                })
            } else if location.x <= 180 && velocity.x < 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 247.0 / 255.0, green: 208.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
                })
                
            } else if location.x > 180 && velocity.x > 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = self.messageViewOriginalColor
                })
                
            } else if location.x > 80 && velocity.x > 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 247.0 / 255.0, green: 208.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
                })

            }
            
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if location.x <= 80 && velocity.x < 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.center = self.messageImageViewSwipedCenter
                    self.listImageView.alpha = 1
                    self.listImageView.hidden = false
                })
                
            } else if location.x <= 180 && velocity.x < 0 {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.center = self.messageImageViewSwipedCenter
                    self.rescheduleImageView.alpha = 1
                    self.rescheduleImageView.hidden = false
                })
            } else {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.center = self.messageImageViewOriginalCenter
                })
            }
            
        }
    }

}


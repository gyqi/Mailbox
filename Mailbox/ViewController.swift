//
//  ViewController.swift
//  Mailbox
//
//  Created by Grace Qi on 2/16/16.
//  Copyright © 2016 Grace Qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navControl: UISegmentedControl!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!

    @IBOutlet weak var swipeLeftIconView: UIView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var rescheduleIconImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    
    @IBOutlet weak var swipeRightIconView: UIView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    
    var contentViewOriginalCenter: CGPoint!
    var scrollViewOriginalCenter: CGPoint!
    var messageImageViewOriginalCenter: CGPoint!
    var messageImageViewSwipedLeftCenter: CGPoint!
    var messageImageViewSwipedRightCenter: CGPoint!
    var messageViewOriginalColor: UIColor!
    
    var swipeLeftIconViewOriginalCenter: CGPoint!
    var swipeRightIconViewOriginalCenter: CGPoint!
    
    var hasSwipe: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1435)
        contentViewOriginalCenter = contentView.center
        scrollViewOriginalCenter = scrollView.center
        
        // attributes of the message image view
        messageViewOriginalColor = messageView.backgroundColor
        messageImageViewOriginalCenter = messageImageView.center
        messageImageViewSwipedLeftCenter = CGPoint(x: messageImageViewOriginalCenter.x - 320, y: messageImageViewOriginalCenter.y)
        messageImageViewSwipedRightCenter = CGPoint(x: messageImageViewOriginalCenter.x + 320, y: messageImageViewOriginalCenter.y)
        
        // attributes of the icon view
        swipeLeftIconViewOriginalCenter = swipeLeftIconView.center
        swipeRightIconViewOriginalCenter = swipeRightIconView.center
        
        // add edge pan gesture recognizer
        var edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGestureRecognizer.edges = UIRectEdge.Left
        edgeGestureRecognizer.delegate = self
        view.addGestureRecognizer(edgeGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            hasSwipe = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.messageImageView.center = self.messageImageViewOriginalCenter
                self.messageView.alpha = 1
                self.messageView.hidden = false
                self.feedImageView.center = CGPoint(x: self.feedImageView.center.x, y: self.feedImageView.center.y + 86)
                self.scrollView.contentSize = CGSize(width: 320, height: 1435)
                print("shaken")
            })
        }

    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let location = sender.locationInView(contentView)
        let translation = sender.translationInView(contentView)
        let velocity = sender.velocityInView(contentView)
        
        print("translation: \(translation)")
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            contentView.center = CGPoint(x: contentViewOriginalCenter.x + translation.x, y: contentViewOriginalCenter.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.contentView.center = CGPoint(x: self.contentViewOriginalCenter.x + 320, y: self.contentViewOriginalCenter.y)
                } else if velocity.x < 0 {
                    self.contentView.center = CGPoint(x: self.contentViewOriginalCenter.x, y: self.contentViewOriginalCenter.y)
                }
            })
        }
    }

    @IBAction func didPan(sender: UIPanGestureRecognizer){
        let location = sender.locationInView(messageView)
        let translation = sender.translationInView(messageView)
        let velocity = sender.velocityInView(messageView)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            // make sure all icons are hidden
            rescheduleIconImageView.hidden = true
            rescheduleIconImageView.alpha = 0
            listIconImageView.hidden = true
            listIconImageView.alpha = 0
            archiveIconImageView.hidden = true
            archiveIconImageView.alpha = 0
            deleteIconImageView.hidden = true
            deleteIconImageView.alpha = 0

        } else if sender.state == UIGestureRecognizerState.Changed {
            
            messageImageView.center = CGPoint(x: messageImageViewOriginalCenter.x + translation.x, y: messageImageViewOriginalCenter.y)
            
            print("translation: \(translation)")
            print("location: \(location)")
            
            // reveal reschedule & list icons
            
            if (translation.x >= -60 && translation.x < 0) && velocity.x < 0 {
                let rescheduleAlpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                rescheduleIconImageView.hidden = false
                rescheduleIconImageView.alpha = -1 * rescheduleAlpha

            } else if (translation.x >= -180 && translation.x < -60) && velocity.x < 0 {
                showHide(rescheduleIconImageView, hideImage: listIconImageView)
                swipeLeftIconView.center = CGPoint(x: swipeLeftIconViewOriginalCenter.x + translation.x + 60, y: swipeLeftIconViewOriginalCenter.y)

            } else if (translation.x >= -320 && translation.x < -180) && velocity.x < 0 {
                showHide(listIconImageView, hideImage: rescheduleIconImageView)
                swipeLeftIconView.center = CGPoint(x: swipeLeftIconViewOriginalCenter.x + translation.x + 60, y: swipeLeftIconViewOriginalCenter.y)
            } else if (translation.x >= -180 && translation.x < -60) && velocity.x > 0 {
                showHide(rescheduleIconImageView, hideImage: listIconImageView)
                swipeLeftIconView.center = CGPoint(x: swipeLeftIconViewOriginalCenter.x + translation.x + 60, y: swipeLeftIconViewOriginalCenter.y)
                print("swipe left center: \(swipeLeftIconView.center.x)")
            } else if (translation.x >= -320 && translation.x < -180) && velocity.x > 0 {
                showHide(listIconImageView, hideImage: rescheduleIconImageView)
                swipeLeftIconView.center = CGPoint(x: swipeLeftIconViewOriginalCenter.x + translation.x + 60, y: swipeLeftIconViewOriginalCenter.y)
                print("swipe left center: \(swipeLeftIconView.center.x)")
            }
            
            // reveal archive and delete icons
            if (translation.x > 0 && translation.x <= 60) && velocity.x > 0 {
                let archiveAlpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                archiveIconImageView.hidden = false
                archiveIconImageView.alpha = archiveAlpha
                
            } else if (translation.x > 60 && translation.x <= 180) && velocity.x > 0 {
                showHide(archiveIconImageView, hideImage: deleteIconImageView)
                swipeRightIconView.center = CGPoint(x: swipeRightIconViewOriginalCenter.x + translation.x - 60, y: swipeRightIconViewOriginalCenter.y)
                
            } else if (translation.x > 180 && translation.x <= 320) && velocity.x > 0 {
                showHide(deleteIconImageView, hideImage: archiveIconImageView)
                swipeRightIconView.center = CGPoint(x: swipeRightIconViewOriginalCenter.x + translation.x - 60, y: swipeRightIconViewOriginalCenter.y)
                
            } else if (translation.x > 60 && translation.x <= 180) && velocity.x < 0 {
                showHide(archiveIconImageView, hideImage: deleteIconImageView)
                swipeRightIconView.center = CGPoint(x: swipeRightIconViewOriginalCenter.x + translation.x - 60, y: swipeRightIconViewOriginalCenter.y)
                
            } else if (translation.x > 180 && translation.x <= 320) && velocity.x < 0 {
                showHide(deleteIconImageView, hideImage: archiveIconImageView)
                swipeRightIconView.center = CGPoint(x: swipeRightIconViewOriginalCenter.x + translation.x - 60, y: swipeRightIconViewOriginalCenter.y)
            }
            
            
            // background color change for swipe left and right
            
            if translation.x >= -80 && translation.x < 0 {
                
                // background = gray
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = self.messageViewOriginalColor
                })
            } else if translation.x >= -180 && translation.x < -80 {
                
                // background = yellow
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 247.0 / 255.0, green: 208.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
                })
                
            } else if translation.x >= -320 && translation.x < -180 {
                
                // background = brown
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 210.0 / 255.0, green: 167.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
                })

            } else if translation.x > 0 && translation.x <= 80 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = self.messageViewOriginalColor
                })
                
            } else if translation.x > 80 && translation.x <= 180 {
                
                // background = green
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 137.0 / 255.0, green: 207.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
                })
                
            } else if translation.x > 180 && translation.x <= 320 {
                
                // background = red
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.backgroundColor = UIColor(red: 221.0 / 255.0, green: 101.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
                })
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
         
            // swipe left
            if translation.x >= -60 && translation.x < 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.swipeLeftIconView.center = CGPoint(x: self.swipeLeftIconViewOriginalCenter.x, y: self.swipeLeftIconViewOriginalCenter.y)
                    self.messageImageView.center = CGPoint(x:self.messageImageViewOriginalCenter.x, y: self.messageImageViewOriginalCenter.y)
                })

            } else if translation.x >= -180 && translation.x < -60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.showHide(self.rescheduleImageView, hideImage: self.listImageView)
                    self.messageImageView.center = self.messageImageViewSwipedLeftCenter
                    self.swipeLeftIconView.center = CGPoint(x: self.swipeLeftIconViewOriginalCenter.x - 320, y: self.swipeLeftIconViewOriginalCenter.y)
                })
                
            } else if translation.x >= -320 && translation.x < -180 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.showHide(self.listImageView, hideImage: self.rescheduleImageView)
                    self.messageImageView.center = self.messageImageViewSwipedLeftCenter
                    self.swipeLeftIconView.center = CGPoint(x: self.swipeLeftIconViewOriginalCenter.x - 320, y: self.swipeLeftIconViewOriginalCenter.y)
                })

            }
            
            // swipe right
            if translation.x > 0 && translation.x <= 60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.swipeRightIconView.center = CGPoint(x: self.swipeRightIconViewOriginalCenter.x, y: self.swipeRightIconViewOriginalCenter.y)
                    self.messageImageView.center = CGPoint(x:self.messageImageViewOriginalCenter.x, y: self.messageImageViewOriginalCenter.y)
                    
                })
            } else if translation.x > 60 && translation.x <= 180 {
                hasSwipe = true
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.center = self.messageImageViewSwipedRightCenter
                    self.swipeRightIconView.center = CGPoint(x: self.swipeRightIconViewOriginalCenter.x + 320, y: self.swipeRightIconViewOriginalCenter.y)
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.messageView.alpha = 0
                            self.messageView.hidden = true
                            self.feedImageView.center = CGPoint(x: self.feedImageView.center.x, y: self.feedImageView.center.y - 86)
                            self.scrollView.contentSize = CGSize(width: 320, height: 1349)
                        })
                })
                
            } else if translation.x > 180 && translation.x <= 320 {
                hasSwipe = true
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.center = self.messageImageViewSwipedRightCenter
                    self.swipeRightIconView.center = CGPoint(x:self.swipeRightIconViewOriginalCenter.x + 320, y: self.swipeRightIconViewOriginalCenter.y)
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.messageView.alpha = 0
                            self.messageView.hidden = true
                            self.feedImageView.center = CGPoint(x: self.feedImageView.center.x, y: self.feedImageView.center.y - 86)
                            self.scrollView.contentSize = CGSize(width: 320, height: 1349)
                        })

                })

            }
            
            
        }
    }
    
    @IBAction func didTapMenu(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.contentView.center = self.contentViewOriginalCenter
        }
    }
    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
        hasSwipe = true
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rescheduleImageView.alpha = 0
            self.rescheduleImageView.hidden = true
            self.messageView.alpha = 0
            self.messageView.hidden = true
            self.feedImageView.center = CGPoint(x: self.feedImageView.center.x, y: self.feedImageView.center.y - 86)
            self.scrollView.contentSize = CGSize(width: 320, height: 1349)
            
        }
        
    }
    
    @IBAction func didTapList(sender: UITapGestureRecognizer) {
        hasSwipe = true
        UIView.animateWithDuration(0.3) { () -> Void in
            self.listImageView.alpha = 0
            self.listImageView.hidden = true
            self.messageView.alpha = 0
            self.messageView.hidden = true
            self.feedImageView.center = CGPoint(x: self.feedImageView.center.x, y: self.feedImageView.center.y - 86)
            self.scrollView.contentSize = CGSize(width: 320, height: 1349)
        }
    }
    
    @IBAction func didTapNavControl(sender: AnyObject) {
        if navControl.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.center = CGPoint(x: self.scrollViewOriginalCenter.x + 320, y: self.scrollViewOriginalCenter.y)
                
            })
            
        } else if navControl.selectedSegmentIndex == 1 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.center = CGPoint(x: self.scrollViewOriginalCenter.x, y: self.scrollViewOriginalCenter.y)
                
            })
            
        } else if navControl.selectedSegmentIndex == 2 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.center = CGPoint(x: self.scrollViewOriginalCenter.x - 320, y: self.scrollViewOriginalCenter.y)
                
            })
            
        }
    }
    
    @IBAction func pressComposeButton(sender: AnyObject) {
        performSegueWithIdentifier("composeSegue", sender: self)

    }
    
    
    // helper functions
    func showHide (showImage: UIImageView, hideImage: UIImageView) {
        showImage.hidden = false
        showImage.alpha = 1
        hideImage.hidden = true
        hideImage.alpha = 0
    }
    

    

}


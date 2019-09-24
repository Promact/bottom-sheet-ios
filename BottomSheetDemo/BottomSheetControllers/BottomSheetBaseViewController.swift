//
//  BottomSheetBaseViewController.swift
//  Teetra
//
//  Created by Ravi Agrawal on 13/06/19.
//  Copyright © 2019 Promact. All rights reserved.
//

import UIKit

class BottomSheetBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var btnSwipeUpDown: UIButton!
    @IBOutlet var viewMainContainer: UIView!
    @IBOutlet var viewMainContainerHeightConst: NSLayoutConstraint!
    
    var lastDy = 0.0
    
    /**Flag Variable COMMENT
     Where it is used : it is used to check weather bottom sheet is hidden or not
     Value to be assigned : Boolean value
     **/
    var isHiddenBottomSheet : Bool = false
    
    var maxTotalHeight = 50
    
    /**Flag Variable COMMENT
     Where it is used : it is used to check weather scroll is required or not
     Value to be assigned : Boolean value
     **/
    var isScrollRequired : Bool = false
    var pan: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.viewMainContainer.addGestureRecognizer(pan)
        
        self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight)
        self.btnSwipeUpDown.isSelected = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        self.viewMainContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /** FUNCTION COMMENT
     Use : It is used to handle the pan gesture
     From where it is called : it is called when gesture detected
     Arguments : UIPanGestureRecognizer
     Return Type : Void
     **/
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        let dy = recognizer.translation(in: self.viewMainContainer).y
        let velocity : CGPoint = recognizer.velocity(in: self.viewMainContainer)
        
        /**IF/SWITCH COMMENT :
         What to check : to check the state of gesture
         **/
        switch recognizer.state {
        case .began:
            //            print("begin========", dy)
            break
        case .changed:
            if(velocity.y > 0) {
                self.lastDy = Double(dy)
                //                let height = self.viewMainContainerHeightConst.constant
                if  dy >= CGFloat(self.maxTotalHeight - 140){
                    //                    print("Hide limit reached")
                    if !self.isHiddenBottomSheet{
                        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
                    }
                    self.isHiddenBottomSheet = true
                } else {
                    self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight) - dy
                }
            } else {
                if  Int(dy) >= self.maxTotalHeight{
                    self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight)
                } else {
                    self.viewMainContainerHeightConst.constant = self.viewMainContainerHeightConst.constant + (CGFloat(self.lastDy) - dy)
                }
            }
            //            print("changed========", dy)
            
        case .failed, .ended, .cancelled:
            //            print("last========", dy)
            
            if !self.isHiddenBottomSheet
            {
                if  dy >= CGFloat(self.maxTotalHeight - 240){
                    self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
                } else {
                    self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight)
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
                
            }
            else{
                
            }
        default:
            break
        }
    }
    
    
    /** FUNCTION COMMENT
     Use : It is used recognize the gesture
     From where it is called : it is called when gesture detected
     Arguments : UIGestureRecognizer
     Return Type : Boolean
     **/
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

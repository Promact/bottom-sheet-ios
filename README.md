Steps to implement Bottom sheet in your project :

MaryPopin is an extension of UIViewController so you just need to copy past 2 files of objective-c in your project. If you are using an Objective-C project then you just need to use directly. If you are using swift project then you need to create a Bridging header to use.

Create a view controller with the design of popups in the storyboard like below.
 
![](https://github.com/RvAgrawal/bottom-sheet-ios/blob/master/popups_design.png)


Now create two different ViewControllers.swift files to accommodate the coding of these two popups. Also, I have created a base class for the bottom sheet with some common functionality. The common things like pan gesture and some common controls are declared in the base class.

To give same sliding functionality like instagram I have given the Pan gesture like given below.

```swift
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        let dy = recognizer.translation(in: self.viewMainContainer).y
        let velocity : CGPoint = recognizer.velocity(in: self.viewMainContainer)
        
        /**IF/SWITCH COMMENT :
         What to check : to check the state of gesture
         **/
        switch recognizer.state {
        case .began:
            break
        case .changed:
            if(velocity.y > 0) {
                self.lastDy = Double(dy)
                // when user sliding it down and if it reaches to the some value we will hide it automatically
                if  dy >= CGFloat(self.maxTotalHeight - 240){
                    if !self.isHiddenBottomSheet{
                        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
                    }
                    self.isHiddenBottomSheet = true
                } else {
                    self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight) - dy
                }
            } else {
                if  Int(dy) >= self.maxTotalHeight{
                    // when user sliding it down and if it reaches to the some value we will hide it automatically else setting it back to its original height
                    self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight)
                } else {
                    self.viewMainContainerHeightConst.constant = self.viewMainContainerHeightConst.constant + (CGFloat(self.lastDy) - dy)
                }
            }
        case .failed, .ended, .cancelled:
            if !self.isHiddenBottomSheet
            {
                // when user sliding it down and if it reaches to the some value we will hide it automatically
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
```


For detail explanation and understanding please download and check the code. The final result is like,

![](https://github.com/RvAgrawal/bottom-sheet-ios/blob/master/screen1.png) ![](https://github.com/RvAgrawal/bottom-sheet-ios/blob/master/screen2.png)


  

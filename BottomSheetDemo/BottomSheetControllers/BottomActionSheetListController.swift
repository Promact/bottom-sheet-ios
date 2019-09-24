//
//  BottomActionSheetViewController.swift
//  Teetra
//
//  Created by Ravi Agrawal on 30/05/19.
//  Copyright © 2019 Promact. All rights reserved.
//

import UIKit

protocol BottomActionSheetListDelegate {
    func btnDidSelectRow(obj : BottomActionSheetListController)
    func submitReportReasonOnSelectCell(obj : BottomActionSheetListController)
    func btnCloseClick()
}

class BottomActionSheetListController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet var btnSwipeUpDown: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewMainContainerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var constHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCancelTopConst: NSLayoutConstraint!
    
    var lastDy = 0.0
    
    /**Flag Variable COMMENT
     Where it is used : it is used to assign the index of table view for which the action is taken
     Value to be assigned : Int value
     **/
    var isHiddenBottomSheet : Bool = false
    
    var maxTotalHeight = 50
    
    /**Flag Variable COMMENT
     Where it is used : it is used to check weather scroll is required or not
     Value to be assigned : Boolean value
     **/
    var isScrollRequired : Bool = false
    var pan: UIPanGestureRecognizer!
    
    var arrOptions = ["Option 1", "Option 2", "Option 3", "Option 4"]  // Static array... You can also pass from the calling class
    
    var delegate: BottomActionSheetListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initially it was hidden as soon as the sheet visible we are setting its alpha to 1.0
        self.lblTitle.alpha = 0.0
        self.btnCancel.alpha = 0.0
        self.tblView.alpha = 0.0
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.viewMainContainer.addGestureRecognizer(pan)
        
        self.viewMainContainerHeightConst.constant = CGFloat(self.maxTotalHeight)
        self.btnSwipeUpDown.isSelected = true
        
        // You can call this method from the calling class to set the data and set the titles
        self.setupUIData(title: "Select Options", btnCancelTitle: "Cancel")
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //To set the rounded corners of view
        self.viewMainContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
    //MARK:- UIAction Methods
    
    @IBAction func btnSwipeUpDownAction(_ sender: Any) {
        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
    }
    
    
    
    //MARK:- Table View Delegate and Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsCell") as? OptionsCell {
            
            let strOptionText = self.arrOptions[indexPath.row]
            
            cell.tag = indexPath.row
            cell.lblTitle.text = strOptionText
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion : {
            self.delegate?.submitReportReasonOnSelectCell(obj: self)
        })
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        // Currently static height is given but you can give it according to your content
    }

    
    /** FUNCTION COMMENT
     Use : It is used to setup Title for buttons and labels
     From where it is called : it is called from the calling class
     Arguments : title,btnTakePhotoTitle,btnChoosePhotoTitle,btnCancelTitle in string
     Return Type : Void
     **/
    func setupUIData(title : String, btnCancelTitle : String)
    {
        self.lblTitle.text = title
        self.btnCancel.setTitle(btnCancelTitle, for: .normal)
        self.tblView.alpha = 1.0
        self.tblView.isScrollEnabled = self.isScrollRequired
        self.btnCancelTopConst.constant = 10
        
        //To set the alpha to 1 when sheet is visible.
        UIView.animate(withDuration: 0.2) {
            self.lblTitle.alpha = 1.0
            self.btnCancel.alpha = 1.0
        }
        
        // To set the data in array, you can call it from calling class and pass the array in it.
        self.setupArrayForData(arrOpt: self.arrOptions)
    }
    
    func setupArrayForData(arrOpt : [String])
    {
        // 240 is set here according to the content above the table and content below the table which is around 190. And 50 you need to give as we are using MaryPopin which includes the padding from top.
        
        var heightForTableView = self.calculateHeightForReportTexts(arrOpt : arrOpt)
        
        // After calculating the height of array we need to check if it is exceeding screen height or not.. if it exceeding then we need to enable the scrolling.
        if Int(heightForTableView + 240) >= self.maxTotalHeight {
            heightForTableView = CGFloat(self.maxTotalHeight - 240)
            self.isScrollRequired = true
        }
        self.constHeightTableView.constant = heightForTableView
        self.tblView.isScrollEnabled = self.isScrollRequired
        self.arrOptions = arrOpt
        self.tblView.reloadData()
    }
    
    func calculateHeightForReportTexts(arrOpt : [String]) -> CGFloat {
        var totHeight : CGFloat = 0.0
        
        for strOption in arrOpt{
//            let height = self.height(forText: strOption, font: UIFont(name: "Futura-Medium", size: 15.0), withinWidth: UIScreen.main.bounds.size.width - 100)
            totHeight = totHeight + 60
        }
        
        return totHeight
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


extension UIViewController {
    
    func height(forText text: String?, font: UIFont?, withinWidth width: CGFloat) -> CGFloat {
        
        let ctx = NSStringDrawingContext()
        let aString = NSAttributedString(string: text ?? "")
        
        let calculationView = UILabel()
        calculationView.attributedText = aString
        var textRect: CGRect? = nil
        if let aFont = font {
            textRect = calculationView.text?.boundingRect(with: CGSize(width: width, height: 1000.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: aFont], context: ctx)
        }
        
        return textRect?.size.height ?? 0.0
    }
}

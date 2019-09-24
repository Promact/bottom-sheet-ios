//
//  BottomActionSheetViewController.swift
//  Teetra
//
//  Created by Ravi Agrawal on 30/05/19.
//  Copyright © 2019 Promact. All rights reserved.
//

import UIKit

protocol BottomActionSheetDelegate {
    func btnTakePhotoClick(obj : BottomActionSheetViewController)
    func btnChoosPhotoClick(obj : BottomActionSheetViewController)
}

class BottomActionSheetViewController: BottomSheetBaseViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnTakePhoto: UIButton!
    @IBOutlet var btnChoosPhoto: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    var delegate: BottomActionSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblTitle.alpha = 0.0
        self.btnTakePhoto.alpha = 0.0
        self.btnChoosPhoto.alpha = 0.0
        self.btnCancel.alpha = 0.0
        
        /**IF/SWITCH COMMENT :
         What to check : To check if scroll is enable or disabled
         **/
        if self.isScrollRequired{
            self.containerScrollView.isScrollEnabled = true
        } else {
            self.containerScrollView.isScrollEnabled = false
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewMainContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
    //MARK:- UIAction Methods
    
    @IBAction func btnSwipeUpDownAction(_ sender: Any) {
        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
    }
    
    @IBAction func btnTakePhotoAction(_ sender: Any) {
        self.delegate?.btnTakePhotoClick(obj: self)
    }
    
    @IBAction func btnChoosPhotoAction(_ sender: Any) {
        self.delegate?.btnChoosPhotoClick(obj: self)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.presentingPopin()?.dismissCurrentPopinController(animated: true, completion: nil)
    }

    //MARK:- Custom Methods
    /** FUNCTION COMMENT
     Use : It is used to setup Title for buttons and labels
     From where it is called : it is called from the calling class
     Arguments : title,btnTakePhotoTitle,btnChoosePhotoTitle,btnCancelTitle in string
     Return Type : Void
     **/
    func setupUIData(title : String, btnTakePhotoTitle : String, btnChoosePhotoTitle : String, btnCancelTitle : String)
    {
        self.lblTitle.text = title
        self.btnTakePhoto.setTitle(btnTakePhotoTitle, for: .normal)
        self.btnChoosPhoto.setTitle(btnChoosePhotoTitle, for: .normal)
        self.btnCancel.setTitle(btnCancelTitle, for: .normal)
        
        UIView.animate(withDuration: 0.2) {
            self.lblTitle.alpha = 1.0
            self.btnTakePhoto.alpha = 1.0
            self.btnChoosPhoto.alpha = 1.0
            self.btnCancel.alpha = 1.0
        }
    }
}

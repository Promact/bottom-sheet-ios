//
//  ViewController.swift
//  BottomSheetDemo
//
//  Created by Ravi Agrawal on 20/09/19.
//  Copyright © 2019 Ravi Agrawal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BottomActionSheetDelegate, BottomActionSheetListDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - BottomActionSheetListDelegate
    
    func btnDidSelectRow(obj : BottomActionSheetListController)
    {
        
    }
    
    func submitReportReasonOnSelectCell(obj : BottomActionSheetListController)
    {
        
    }
    
    func btnCloseClick()
    {
        
    }
    
    
    //MARK: - BottomActionSheetDelegate
    
    func btnTakePhotoClick(obj : BottomActionSheetViewController)
    {
        
    }
    
    func btnChoosPhotoClick(obj : BottomActionSheetViewController)
    {
        
    }

    @IBAction func btnTakePhotoAction(_ sender: Any) {
        self.openActionSheetForImage()
    }
    
    @IBAction func btnOptiosAction(_ sender: Any) {
        self.openActionSheetForOptions()
    }
    
    
    func openActionSheetForImage(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "BottomActionSheetViewController") as! BottomActionSheetViewController
        
        contentVC.setPopinTransitionStyle(BKTPopinTransitionStyle.slide)
        contentVC.setPopinTransitionDirection(BKTPopinTransitionDirection.bottom)
        
        contentVC.delegate = self
        let heightTotal = 380
        contentVC.maxTotalHeight = 380
        contentVC.isScrollRequired = false
        
        let presentationRect: CGRect = CGRect.init(x: -20, y: Int(UIScreen.main.bounds.size.height) - (Int(heightTotal) - 20) , width: Int(UIScreen.main.bounds.size.width + 40), height: heightTotal)
        self.presentPopinController(contentVC, from: presentationRect, animated: true) {
            
            contentVC.setupUIData(title: "Choose Option", btnTakePhotoTitle: "Take Photo", btnChoosePhotoTitle: "Select Photo", btnCancelTitle: "Cancel")
        }
    }
    
    func openActionSheetForOptions(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "BottomActionSheetListController") as! BottomActionSheetListController
        
        contentVC.setPopinTransitionStyle(BKTPopinTransitionStyle.slide)
        contentVC.setPopinTransitionDirection(BKTPopinTransitionDirection.bottom)
        
        contentVC.delegate = self
        let heightTotal = 500  // currently it is fix here.. you can calculate from the size of array and if excceds with height of screen then limit it to some static height and enable scrolling of tableview
        contentVC.maxTotalHeight = heightTotal
        contentVC.isScrollRequired = false
        
        let presentationRect: CGRect = CGRect.init(x: -20, y: Int(UIScreen.main.bounds.size.height) - (Int(heightTotal) - 20) , width: Int(UIScreen.main.bounds.size.width + 40), height: heightTotal)
        self.presentPopinController(contentVC, from: presentationRect, animated: true) {
            
//            contentVC.setupUIData(title: "Choose Option", btnTakePhotoTitle: "Take Photo", btnChoosePhotoTitle: "Select Photo", btnCancelTitle: "Cancel")
        }
    }
}


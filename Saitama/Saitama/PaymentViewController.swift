//
//  PaymentViewController.swift
//  Saitama
//
//  Created by Mohamed Adly on 6/4/16.
//  Copyright © 2016 mohamedadly. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import MBProgressHUD
import EZAlertController
import Alamofire
import BFKit

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set navigation bar buttons
        let payButton : UIBarButtonItem = UIBarButtonItem(title: "Pay", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PaymentViewController.payButtonClicked(_:)))
        let cancelButton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PaymentViewController.cancelButtonClicked(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = payButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setTransparent(true)
    }
    
    func payButtonClicked(sender: UIBarButtonItem){
        view.endEditing(true)
        let number = numberTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let name = nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let expiration = expirationTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let cvv = cvvTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if number?.characters.count > 0 && name?.characters.count > 0 && expiration?.characters.count > 0 && cvv?.characters.count > 0{
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            let headers = [
                "Authorization":SaitamaNetwordManager.sharedInstance.getToken(),
                "Accept": "application/json"
            ]
            
            let parameters = [
                "number": number!,
                "name":name!,
                "expiration":expiration!,
                "code":cvv!
            ]
            
            if SaitamaNetwordManager.sharedInstance.isReachable() {
                Alamofire.request(.POST, SaitamaNetwordManager.paymentServiceURL, parameters: parameters, encoding: .JSON, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success(let JSON):
                            let responseJSON = JSON as! NSDictionary
                            if(responseJSON.objectForKey("message") != nil){
                                EZAlertController.alert("Success", message: responseJSON.objectForKey("message") as! String, acceptMessage: "OK"){ () -> () in
                                    self.dismissPayment()
                                }
                            }else if(responseJSON.objectForKey("code") != nil){
                                EZAlertController.alert("Error", message: responseJSON.objectForKey("message") as! String)
                            }
                        case .Failure(let error):
                            print(error)
                            EZAlertController.alert("Error", message: "service unavailable, please try again later")
                        }
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                EZAlertController.alert("Error", message: "check your connectivity to the internet")
            }
        }
    }
    
    func cancelButtonClicked(sender: UIBarButtonItem){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissPayment(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
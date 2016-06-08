//
//  ViewController.swift
//  Saitama
//
//  Created by Mohamed Adly on 6/4/16.
//  Copyright © 2016 mohamedadly. All rights reserved.
//

import UIKit
import ChameleonFramework
import MBProgressHUD
import EZAlertController
import Alamofire
import BFKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if user is logged in
        if SaitamaNetwordManager.sharedInstance.isLoggedIn() {
            loadHomePage()
        }
        
        //set some colors
        view.backgroundColor = UIColor.flatWhiteColor()
        mainLabel.textColor = UIColor.flatBlackColor()
        emailTextField.textColor = UIColor.flatBlackColor()
        passwordTextField.textColor = UIColor.flatBlackColor()
        loginButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.flatBlackColor(), forState: UIControlState.Normal)
        
        //customize buttons
        loginButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setTransparent(true)
        title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginButtonClicked(sender: AnyObject) {
        //validate email and password
        let email = emailTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if(email?.characters.count > 0 && password?.characters.count > 0){
            
            if(!DataValidator.isEmailValid(email!)){
                EZAlertController.alert("Error", message: "Invalid Email")
                return
            }
            
            if(!DataValidator.isPasswordValid(password!)){
                EZAlertController.alert("Error", message: "Invalid Password")
                return
            }
            
            //all goood
            if SaitamaNetwordManager.sharedInstance.isReachable() {
                MBProgressHUD.showHUDAddedTo(view, animated: true)
                
                //send request
                let parameters = [
                    "email": email!,
                    "password":password!
                ]
                Alamofire.request(.POST, SaitamaNetwordManager.authServiceURL, parameters: parameters, encoding: .JSON)
                    .responseJSON { response in
                        switch response.result {
                        case .Success(let JSON):
                            let responseJSON = JSON as! NSDictionary
                            if(responseJSON.objectForKey("accessToken") != nil){
                                SaitamaNetwordManager.sharedInstance.saveToken(responseJSON.objectForKey("accessToken") as! String)
                                self.loadHomePage()
                            }else if(responseJSON.objectForKey("message") != nil){
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
    
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        //validate email and password
        let email = emailTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if(email?.characters.count > 0 && password?.characters.count > 0){
            
            if(!DataValidator.isEmailValid(email!)){
                EZAlertController.alert("Error", message: "Invalid Email")
                return
            }
            
            if(!DataValidator.isPasswordValid(password!)){
                EZAlertController.alert("Error", message: "Invalid Password")
                return
            }
            
            //all goood
            if SaitamaNetwordManager.sharedInstance.isReachable() {
                MBProgressHUD.showHUDAddedTo(view, animated: true)
                
                //send request
                let parameters = [
                    "email": email!,
                    "password":password!
                ]
                Alamofire.request(.POST, SaitamaNetwordManager.registerServiceURL, parameters: parameters, encoding: .JSON)
                    .responseJSON { response in
                        switch response.result {
                        case .Success(let JSON):
                            let responseJSON = JSON as! NSDictionary
                            if(responseJSON.objectForKey("accessToken") != nil){
                                SaitamaNetwordManager.sharedInstance.saveToken(responseJSON.objectForKey("accessToken") as! String)
                                self.loadHomePage()
                            }else if(responseJSON.objectForKey("message") != nil){
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
    
    
    private func loadHomePage(){
        //push home page
        performSegueWithIdentifier("homepagesegue", sender: self)
    }
    
}


//
//  NetworkManager.swift
//  Saitama
//
//  Created by Mohamed Adly on 6/4/16.
//  Copyright © 2016 mohamedadly. All rights reserved.
//

import Foundation
import Alamofire


public class SaitamaNetwordManager {
    
    static let sharedInstance = SaitamaNetwordManager()
    private let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    
    //Backend Server url
    public static let ServerURL = "http://192.168.100.230:8080"
    
    //services url
    public static let registerServiceURL = SaitamaNetwordManager.ServerURL + "/api/v1/register"
    public static let authServiceURL = SaitamaNetwordManager.ServerURL + "/api/v1/auth"
    public static let locationsServiceURL = SaitamaNetwordManager.ServerURL + "/api/v1/places"
    public static let paymentServiceURL = SaitamaNetwordManager.ServerURL + "/api/v1/rent"
    

    //Start Reachability Manager
    public func startReachabilityManager(){
        reachabilityManager?.startListening()
    }
    
    //is Reachable
    public func isReachable() -> Bool {
        return (reachabilityManager?.isReachable)!
    }
    
    
    //save token
    public func saveToken(token : String){
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "accessToken");
    }
    
    //check if logged in
    public func isLoggedIn() -> Bool{
        if (NSUserDefaults.standardUserDefaults().objectForKey("accessToken") != nil) {
            return true;
        }
        return false;
    }
    
    //get token
    public func getToken() -> String{
        return NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
    }
}

//
//  HomeViewController.swift
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
import GoogleMaps

class HomeViewController: UIViewController, GMSMapViewDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set some colors
        view.backgroundColor = UIColor.flatWhiteColor()
        
        
        //display map
        let camera = GMSCameraPosition.cameraWithLatitude(35.9155169,
                                                          longitude: 139.5086715, zoom: 10)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        
        //load locations
        let headers = [
            "Authorization":SaitamaNetwordManager.sharedInstance.getToken(),
            "Accept": "application/json"
        ]
        
        if SaitamaNetwordManager.sharedInstance.isReachable() {
            Alamofire.request(.GET, SaitamaNetwordManager.locationsServiceURL, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success(let JSON):
                        let responseJSON = JSON as! NSDictionary
                        if(responseJSON.objectForKey("results") != nil){
                            let results = responseJSON.objectForKey("results") as! NSArray
                            for item in results{
                                let name = item.objectForKey("name");
                                let location = item.objectForKey("location") as! NSDictionary
                                let lat = location.objectForKey("lat")
                                let lng = location.objectForKey("lng")
                                
                                //create marker
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                                marker.title = name as? String
                                marker.icon = GMSMarker.markerImageWithColor(UIColor.flatBlackColor())
                                marker.flat = true
                                marker.map = mapView
                                
                            }
                        }else if(responseJSON.objectForKey("message") != nil){
                            EZAlertController.alert("Error", message: responseJSON.objectForKey("message") as! String)
                        }
                    case .Failure(let error):
                        print(error)
                        EZAlertController.alert("Error", message: "service unavailable, please try again later")
                    }
            }
        }else{
            EZAlertController.alert("Error", message: "check your connectivity to the internet")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.setTransparent(true)
    }
    
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let actionSheet = UIAlertController(title: nil, message: marker.title, preferredStyle: .ActionSheet)
        actionSheet.view.tintColor = FlatBlack()
        
        let rentAction = UIAlertAction(title: "Rent", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showPaymentVC()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        actionSheet.addAction(rentAction)
        actionSheet.addAction(cancelAction)
        
        //ipad
        if let popoverController = actionSheet.popoverPresentationController{
            popoverController.sourceView = mapView
            popoverController.sourceRect =  CGRectMake(marker.infoWindowAnchor.x, marker.infoWindowAnchor.y, 0, 0)
        }
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    private func showPaymentVC(){
        performSegueWithIdentifier("paymentsegue", sender: self)
    }
    
}
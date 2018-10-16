//
//  MapViewController.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class MapViewController: UIViewController, GMSMapViewDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Variables
    var mapType: MapType = .Single
    var lists = Lists()
    var listInfo = ListInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMapViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set default menuview hide.
        menuView.isHidden = true
    }
    
    func initMapViewController() {
        
        // Add pin on mapview.
        addPin()
        
        // Add SwipeRightGesture for go to back.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shopButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Shop
        self.menuView.isHidden = true
        perfoemGetData()
    }
    
    @IBAction func eatButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Eat
        self.menuView.isHidden = true
        perfoemGetData()
    }
    
    @IBAction func drinkButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Drink
        self.menuView.isHidden = true
        perfoemGetData()
    }
    
    @IBAction func beautifyButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Beautify
        self.menuView.isHidden = true
        perfoemGetData()
    }
    
    @IBAction func mapButtonClicked(_ sender: Any) {
        self.menuView.isHidden = true
    }
    
    // MARK: - Custom methods.
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    // Add pin to mapview.
    func addPin() {
        // Clear all pin on mapview.
        mapView.clear()
        
        // Check mapview type.
        if mapType == .Single {
            processToAddPin()
        } else {
            for listInfo in lists.lists {
                self.listInfo = listInfo
                processToAddPin()
            }
        }
    }
    
    // process to add pin on google mapview.
    func processToAddPin() {
        
        let camera = GMSCameraPosition.camera(withLatitude: listInfo.lat,
                                              longitude: listInfo.long, zoom: 6)
        self.mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(listInfo.lat, listInfo.long)
        marker.title = listInfo.title
        marker.snippet = listInfo.address
        
        // Set pin image according to landingtype.
        switch Globals.shared.landingType {
        case .Shop:
            marker.icon = UIImage(named: "mark-shop")
            break
        case .Eat:
            marker.icon = UIImage(named: "mark-eat")
            break
        case .Drink:
            marker.icon = UIImage(named: "mark-drink")
            break
        case .Beautify:
            marker.icon = UIImage(named: "mark-beautify")
            break
        }
        marker.map = mapView
    }
    
    // Get all data from JSON file.
    func perfoemGetData() {
        var path = ""
        switch Globals.shared.landingType {
        case .Shop:
            path = Bundle.main.path(forResource: "Shop", ofType: "json")!
            break
        case .Eat:
            path = Bundle.main.path(forResource: "Eat", ofType: "json")!
            break
        case .Drink:
            path = Bundle.main.path(forResource: "Drink", ofType: "json")!
            break
        case .Beautify:
            path = Bundle.main.path(forResource: "Beautify", ofType: "json")!
            break
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            let jsonResult = JSON(data)
            
            if let result = jsonResult.dictionaryObject {
                if let dataList = result["list"] as? Array<Any> {
                    lists.lists.removeAll()
                    lists = Lists(results: dataList)
                }
            }
            mapType = .Multiple
            addPin()
        } catch {
            // handle error
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

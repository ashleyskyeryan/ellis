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
    private lazy var markers = [GMSMarker]()
    
    // MARK: - Variables
    var mapType: MapType = .All
    var allLists = [Lists]()
    var lists = Lists()
    var listInfo = ListInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMapViewController()
    }
	
	func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
		for list in self.allLists {
			if let index = list.lists.index(where: { $0.address == marker.snippet }) {
				let item = list.lists[index]
				let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
				controller.listInfo = item
				controller.mapViewController = self
				self.navigationController?.pushViewController(controller, animated: true)
				return
			}
		}
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
        lists = performGetData()
        mapType = .Multiple
        addPin()
    }
	
	func reload() {
		lists = performGetData()
		mapType = .Multiple
		addPin()
	}
	
    @IBAction func eatButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Eat
        self.menuView.isHidden = true
        lists = performGetData()
        mapType = .Multiple
        addPin()
    }
    
    @IBAction func drinkButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Drink
        self.menuView.isHidden = true
        lists = performGetData()
        mapType = .Multiple
        addPin()
    }
    
    @IBAction func beautifyButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Rest
        self.menuView.isHidden = true
        lists = performGetData()
        mapType = .Multiple
        addPin()
    }
    
    @IBAction func mapButtonClicked(_ sender: Any) {
        self.menuView.isHidden = true
        mapType = .All
        addPin()
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
        markers = []
        
        // Check mapview type.
        switch mapType {
        case .Single:
            processToAddPin(listInfo: self.listInfo)
        case .Multiple:
            for listInfo in lists.lists {
				processToAddPin(listInfo: listInfo)
            }
        case .All:
            allLists = []
            for type in LandingType.allCases {
                allLists.append(performGetData(landingType: type))
            }
            for list in allLists {
                for listInfo in list.lists {
                    self.listInfo = listInfo
                    processToAddPin(listInfo: listInfo)
                }
            }
        }
        
        if markers.count == 1 {
            let camera = GMSCameraPosition.camera(withLatitude: listInfo.lat,
                                                  longitude: listInfo.long, zoom: 16)
            self.mapView.camera = camera
        } else {
            var bounds = GMSCoordinateBounds()
            for marker in markers {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds)
            self.mapView.moveCamera(update)
        }
    }
    
    // process to add pin on google mapview.
	func processToAddPin(listInfo: ListInfo) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(listInfo.lat, listInfo.long)
        marker.title = listInfo.title
        marker.snippet = listInfo.address
        
        // Set pin image according to landingtype.
        switch listInfo.landingType {
        case .Shop:
            marker.icon = UIImage(named: "mark-shop")
            break
        case .Eat:
            marker.icon = UIImage(named: "mark-eat")
            break
        case .Drink:
            marker.icon = UIImage(named: "mark-drink")
            break
        case .Rest:
            marker.icon = UIImage(named: "mark-beautify")
            break
        }
        marker.map = mapView
        markers.append(marker)
    }
    
    // Get all data from JSON file.
    func performGetData(landingType: LandingType = Globals.shared.landingType) -> Lists {
        let stringLandingType = landingType.rawValue
        let path = Bundle.main.path(forResource: stringLandingType, ofType: "json")!
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            let jsonResult = JSON(data)
            
            if let result = jsonResult.dictionaryObject {
                if let dataList = result["list"] as? Array<Any> {
                    lists.lists.removeAll()
                    return Lists(results: dataList, landingType: landingType)
                }
            }
        } catch {
            // handle error
        }
        
        return Lists()
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

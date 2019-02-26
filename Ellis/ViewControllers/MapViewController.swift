//
//  MapViewController.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var menuView: UIView!
	@IBOutlet var mapView: MKMapView!
    private lazy var markers = [EllisMarker]()

	// MARK: - Variables
    var mapType: MapType = .All
    var allLists = [Lists]()
    var lists = Lists(landingType: Globals.shared.landingType)
    var listInfo = ListInfo(landingType: Globals.shared.landingType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMapViewController()
    }
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set default menuview hide.
        menuView.isHidden = true
    }
    
    func initMapViewController() {
		self.mapView = MKMapView(frame: self.view.bounds)
		self.view.insertSubview(self.mapView, at: 0)
		self.mapView.delegate = self
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
		self.resetAnnotations()
        addPin()
    }
	
	var currentAnnotations: [EllisMarker] = []
	func resetAnnotations() {
		self.mapView?.removeAnnotations(self.currentAnnotations)
		self.currentAnnotations = []
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
		self.resetAnnotations()
      	addPin()
    }
    
    @IBAction func drinkButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Drink
        self.menuView.isHidden = true
        lists = performGetData()
        mapType = .Multiple
		self.resetAnnotations()
       	addPin()
    }
    
    @IBAction func beautifyButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Rest
        self.menuView.isHidden = true
        lists = performGetData()
        mapType = .Multiple
		self.resetAnnotations()
        addPin()
    }
	
	
	@IBAction func favoritesButtonClicked(_ sender: Any) {
		Globals.shared.landingType = .Favorites
		self.menuView.isHidden = true
		lists = performGetData()
		mapType = .Multiple
		self.resetAnnotations()
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
        markers = []
		
		var firstListInfo: ListInfo?
        // Check mapview type.
        switch mapType {
        case .Single:
            processToAddPin(listInfo: self.listInfo)
        case .Multiple:
            for listInfo in lists.lists {
				if firstListInfo == nil { firstListInfo = listInfo }
				processToAddPin(listInfo: listInfo)
            }
        case .All:
            allLists = []
            for type in LandingType.allCases {
                allLists.append(performGetData(landingType: type))
            }
            for list in allLists {
                for listInfo in list.lists {
					if firstListInfo == nil { firstListInfo = listInfo }
                   self.listInfo = listInfo
                    processToAddPin(listInfo: listInfo)
                }
            }
        }
		
		let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        if markers.count == 1 {
				let region = MKCoordinateRegion(center: listInfo.coordinate, span: span)
				self.mapView.setRegion(region, animated: false)
        } else if let listInfo = firstListInfo {
				let region = MKCoordinateRegion(center: listInfo.coordinate, span: span)
				self.mapView.setRegion(region, animated: false)
        }
    }
    
    // process to add pin on google mapview.
	func processToAddPin(listInfo: ListInfo) {
        let marker = EllisMarker()
		marker.listInfo = listInfo
        marker.title = listInfo.title
//        marker.snippet = listInfo.address
		
	//	marker.icon = listInfo.annotationImage

		self.mapView.addAnnotation(marker)
		self.currentAnnotations.append(marker)
		markers.append(marker)
    }
    
    // Get all data from JSON file.
    func performGetData(landingType: LandingType = Globals.shared.landingType) -> Lists {
		if landingType == .Favorites {
			return Favorites.instance.lists
		}

		return ListManager.instance.fetchItems(for: Globals.shared.landingType)
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

extension MapViewController: MKMapViewDelegate {
	public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let anno = annotation as? EllisMarker {
			let view = MKAnnotationView(annotation: anno, reuseIdentifier: anno.title!)
			
			view.canShowCallout = true
			view.image = anno.listInfo?.annotationImage
			return view
		}
		return nil
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(calloutTapped))
		view.addGestureRecognizer(gesture)
	}
	
	@objc func calloutTapped(sender:UITapGestureRecognizer) {
		guard let annotation = (sender.view as? MKAnnotationView)?.annotation as? EllisMarker, let info = annotation.listInfo else { return }
		
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
		controller.listInfo = info
		controller.mapViewController = self
		self.navigationController?.pushViewController(controller, animated: true)
	}

}

class EllisMarker: NSObject, MKAnnotation {
	var listInfo: ListInfo?
	
	var coordinate: CLLocationCoordinate2D {
		return self.listInfo?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
	}
	
	var title: String? {
		get { return self.listInfo?.title }
		set { }
	}

	var subtitle: String? {
		get { return self.listInfo?.address }
		set { }
	}
}


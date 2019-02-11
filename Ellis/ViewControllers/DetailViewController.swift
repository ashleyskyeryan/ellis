//
//  DetailViewController.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    
    // MARK: - Variables
    var listViewController: ListViewController?
	var mapViewController: MapViewController?
    var listInfo = ListInfo(landingType: Globals.shared.landingType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDetailViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide menuview
        menuView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Default method
    func initDetailViewController() {
        
        // Set title.
        switch Globals.shared.landingType {
        case .Shop:
            lblTitle.text = "Shop"
			
        case .Eat:
            lblTitle.text = "Eat"
			
        case .Drink:
            lblTitle.text = "Drink"
			
        case .Rest:
            lblTitle.text = "Beautify"
			
		case .Favorites: break
        }
        
        // Add SwipeRightGesture for go to back.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        // Set tableview row height dynamically.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // MARK: - IBAction methods
    
	@IBAction func menuButtonClicked(_ sender: Any) {
		menuView.isHidden = !menuView.isHidden
	}
	
	@IBAction func websiteAndHoursButtonClicked(_ sender: Any) {
		if let url = URL(string: listInfo.website) {
			let controller = SFSafariViewController(url: url)
			
			self.present(controller, animated: true, completion: nil)
		}
	}
	
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewMapButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.CellIdentifier.init().mapPage, sender: self)
    }
    
    @IBAction func shopButtonClicked(_ sender: Any) {
        setListViewController(.Shop)
    }
    
    @IBAction func eatButtonClicked(_ sender: Any) {
        setListViewController(.Eat)
    }
    
    @IBAction func drinkButtonClicked(_ sender: Any) {
        setListViewController(.Drink)
    }
    
    @IBAction func beautifyButtonClicked(_ sender: Any) {
        setListViewController(.Rest)
    }
	
	
	@IBAction func favoritesButtonClicked(_ sender: Any) {
		setListViewController(.Favorites)
	}

    @IBAction func mapButtonClicked(_ sender: Any) {
        menuView.isHidden = true
        self.performSegue(withIdentifier: Constants.CellIdentifier.init().mapPage, sender: self)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewTableCell
        
        cell.lblTitle.text = listInfo.title
        cell.imgView.image = UIImage(named: listInfo.image)
		
		var text = listInfo.detail
		if !listInfo.street_address.isEmpty {
			text = text + "\n\n" + listInfo.street_address
		}
		if !listInfo.hours.isEmpty {
			text = text + "\n\nHours: " + listInfo.hours
		}

        cell.lblDetail.text = text
        cell.lblAttribution.text = listInfo.attribution
        
        return cell
    }
    
    // MARK: - Custom method
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        // Check gesture is nill or not.
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            // If yes then check direction of SwipeGesture.
            switch swipeGesture.direction {
                
                // If SwipeGesture equal to right then go to back view.
            case UISwipeGestureRecognizerDirection.right:
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
    
    // Set listviewcontroller data when menu button clicked.
    func setListViewController(_ landingType: LandingType) {
        
        // Set landingtype.
        Globals.shared.landingType = landingType
        // Set listdata according to selected landingtype.
		listViewController?.reload()
		mapViewController?.reload()
        // Set menuview to hide.
        menuView.isHidden = true
        // pop to back view.
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MapViewController {
            controller.listInfo = listInfo
            controller.mapType = .Single
        }
    }
    

}

//
//  ListViewController.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    // For store and manage list.
    var lists: Lists = Lists(landingType: Globals.shared.landingType)
    
    // For get selected list from listarray.
    var selectedIndexPath = IndexPath()
    
    // For search flag.
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.rowHeight = 201

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initListViewController()
    }
    
    // Default method.
    func initListViewController() {
        
        // Navigation
        self.navigationController?.navigationBar.isHidden = true
        
        // menuview and searchbar set hide when page load first time.
        menuView.isHidden = true
        searchBar.isHidden = true
        
        // Get all list data from JSON file.
        performGetData()
        
        // Add SwipeRightGesture for go to back.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
		swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - IBAction
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        // Check and set menuview hide property.
        menuView.isHidden = !menuView.isHidden
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        // Set searchbar default text.
        searchBar.text = ""
        // Show searchbar.
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func shopButtonClicked(_ sender: Any) {
        // Set landingtype.
        Globals.shared.landingType = .Shop
        // Get all list data from JSON file.
        performGetData()
        // Set menuview to hide
        menuView.isHidden = true
    }
    
    @IBAction func eatButtonClicked(_ sender: Any) {
        // Set landingtype.
        Globals.shared.landingType = .Eat
        // Get all list data from JSON file.
        performGetData()
        // Set menuview to hide
        menuView.isHidden = true
    }
    
    @IBAction func drinkButtonClicked(_ sender: Any) {
        // Set landingtype.
        Globals.shared.landingType = .Drink
        // Get all list data from JSON file.
        performGetData()
        // Set menuview to hide
        menuView.isHidden = true
    }

	
	@IBAction func favoritesButtonClicked(_ sender: Any) {
		Globals.shared.landingType = .Favorites
		performGetData()
		// Set menuview to hide
		menuView.isHidden = true
	}

    @IBAction func beautifyButtonClicked(_ sender: Any) {
        // Set landingtype.
        Globals.shared.landingType = .Rest
        // Get all list data from JSON file.
        performGetData()
        // Set menuview to hide
        menuView.isHidden = true
    }
    
    @IBAction func mapButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: Constants.CellIdentifier.init().mapPage, sender: self)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check search flag.
        if isSearch {
            // Return searchlist only.
            return lists.searchList.count
        } else {
            // Return all list.
            return lists.lists.count
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListViewTableCell
        
        // Check search flag.
        if isSearch {
            cell.lblTitle.text = lists.searchList[indexPath.row].title
            cell.lblAddress.text = lists.searchList[indexPath.row].address
            cell.imgView.image = UIImage(named: lists.searchList[indexPath.row].image)
        } else {
            cell.lblTitle.text = lists.lists[indexPath.row].title
            cell.lblAddress.text = lists.lists[indexPath.row].address
            cell.imgView.image = UIImage(named: lists.lists[indexPath.row].image)
        }
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: Constants.CellIdentifier.init().detailPage, sender: self)
    }
    
    // MARK: - SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Check search text isEmpty or not.
        if searchText.isEmpty {
            // set search flag to flase.
            isSearch = false
        } else {
            // set search flag to true.
            isSearch = true
            // get list by searchtext.
            lists.getListByTitle(searchText)
        }
        // Reload all table row.
        self.tableView.reloadData()
    }
    
    // Call method when clicked on cancel button.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
        lists.searchList.removeAll()
        isSearch = false
        self.tableView.reloadData()
    }
    
    // MARK: - Custom Methods
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        // Check gesture is nill or not.
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            // If yes then check direction of SwipeGesture.
            switch swipeGesture.direction {
                
                // If SwipeGesture equal to right then go to back view.
				case UISwipeGestureRecognizer.Direction.right:
                searchBar.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }

    func reload() {
        performGetData()
    }
	
	@available(iOS 11.0, *)
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		if isSearch { return nil }
		
		let item = self.lists.lists[indexPath.row]
		let isFavorite = item.isFavorite
		let action = UIContextualAction(style: .normal, title: isFavorite ? "Remove as Favorite" : "Add as Favorite") { action, view, completion in
			if isFavorite {
				Favorites.instance.removeFavorite(item: item)
				if Globals.shared.landingType == .Favorites, let index = self.lists.lists.index(of: item) {
					tableView.beginUpdates()
					self.lists.lists.remove(at: index)
					tableView.deleteRows(at: [indexPath], with: .automatic)
					tableView.endUpdates()
					completion(true)
					return
				}
			} else {
				Favorites.instance.addFavorite(item: item)
			}
			completion(false)
		}
		
		action.backgroundColor = .black
		return UISwipeActionsConfiguration(actions: [action])
	}
	
    // Function for get all list from JSON file.
    func performGetData() {
		self.lblTitle.text = Globals.shared.landingType.rawValue
		self.lists = ListManager.instance.fetchItems(for: Globals.shared.landingType)
		self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.CellIdentifier.init().detailPage {
            if let controller = segue.destination as? DetailViewController {
                controller.listViewController = self
                controller.listInfo = lists.lists[selectedIndexPath.row]
            }
        }
        
        if segue.identifier == Constants.CellIdentifier.init().mapPage {
            if let controller = segue.destination as? MapViewController {
                controller.lists = lists
                controller.mapType = .Multiple
            }
        }
    }

}

//
//  HomeViewController.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var landingType: LandingType = .Shop
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    
        //My code ends here (and added the file background to assets)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Methods.
    
    // For ShopButton.
    @IBAction func shopButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Shop
        openNavigationController()
    }
    
    // For EatButton.
    @IBAction func EatButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Eat
        openNavigationController()
    }
    
    // For DrinkButton.
    @IBAction func drinkButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Drink
        openNavigationController()
    }
    
    // For BeautifyButton.
    @IBAction func beautifyButtonClicked(_ sender: Any) {
        Globals.shared.landingType = .Beautify
        openNavigationController()
    }
    
    private func openNavigationController() {
        if let navigationViewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
        {
            present(navigationViewcontroller, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

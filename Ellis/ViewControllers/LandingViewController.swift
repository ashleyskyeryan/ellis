//
//  LandingViewController.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
import SwiftyJSON

class LandingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initLandingViewController()
    }
    
    // Default Method.
    func initLandingViewController() {
        
        // Get image from JSON file.
        performGetImage()
        
        // Add SwipeRightGesture for go to back.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        // Add SwipeUpGesture for go to list screen.
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
    }

    // MARK: - Custom Methods.
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        // Check gesture is nill or not.
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            // If yes then check direction of SwipeGesture.
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                
                // If SwipeGesture equal to right then go back to home screen.
                self.navigationController?.popViewController(animated: true)
            case UISwipeGestureRecognizerDirection.up:
                
                // If SwipeGesture equal to up then go to list screen.
                if let navigationViewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
                {
                    present(navigationViewcontroller, animated: true, completion: nil)
                }
                break
            default:
                break
            }
        }
    }
    
    // Function for getImage from JSON file.
    func performGetImage() {
        
        var path = ""
        
        switch Globals.shared.landingType {
        case .Shop:
            lblTitle.text = "Shop"
            path = Bundle.main.path(forResource: "Shop", ofType: "json")!
            break
        case .Eat:
            lblTitle.text = "Eat"
            path = Bundle.main.path(forResource: "Eat", ofType: "json")!
            break
        case .Drink:
            lblTitle.text = "Drink"
            path = Bundle.main.path(forResource: "Drink", ofType: "json")!
            break
        case .Beautify:
            lblTitle.text = "Beautify"
            path = Bundle.main.path(forResource: "Beautify", ofType: "json")!
            break
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            let jsonResult = JSON(data)
            
            if let result = jsonResult.dictionaryObject {
                if let imageName = result["image"] as? String {
                    imgView.image = UIImage(named: imageName)
                }
            }
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

//
//  ViewController.swift
//  MealApp
//
//  Created by James Lea on 3/27/22.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDessserts()
//        fetchDessert()
    }
    
    func fetchDessserts(){
        NetworkManager.shared.fetchDesserts { result in
            switch result {
                
            case .success(let desserts):
                print(desserts)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchDessert(){
        NetworkManager.shared.fetchDessert(mealID: "52910") { result in
            switch result {
            case .success(let meal):
                print(meal)
                break
            case .failure(let error):
                print(error)
            }
        }
    }


}


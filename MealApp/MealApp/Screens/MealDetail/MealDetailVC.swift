//
//  MealDetailVC.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class MealDetailVC: UIViewController {
    
    let mealImageView       = UIImageView()
    let ingredientTableView = UITableView()
    let instructionsLabel   = MealBodyLabel(textAlignment: .center)
    var meal: Meal?
    var dessert: Dessert? {
        didSet {
            showLoadingView()
            guard let dessert = dessert else { return }
            NetworkManager.shared.fetchDessert(mealID: dessert.idMeal) {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let meal):
                    self.meal = meal
                case .failure(let error):
                    let errorController = UIAlertController(title: "Something went wrong.", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(errorController, animated: true)
                }
                self.dismissLoadingView()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}//End of Class

extension MealDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = meal?.ingredients else { return 1 }
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredients = meal?.ingredients,
              let measurements = meal?.measurements else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID, for: indexPath) as! IngredientCell
        
        cell.set(ingredient: ingredients[indexPath.row], measurement: measurements[indexPath.row])
        return cell
    }
    
    
}

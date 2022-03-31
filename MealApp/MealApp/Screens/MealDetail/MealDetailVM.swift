//
//  MealDetailVM.swift
//  MealApp
//
//  Created by James Lea on 3/30/22.
//

import UIKit

class Section {
    let title: String
    var isOpened: Bool = false
    
    init(title: String, isOpened: Bool = false) {
        self.title      = title
        self.isOpened   = isOpened
    }
}

class MealDetailVM {
    
    var sections = [Section(title: "Section1")]
    var meal: Meal?
    var dessert: Dessert? {
        didSet {
            guard let dessert = dessert else { return }
//            self.showLoadingView()
//            ^Not sure how to pass the VC into a computed property
            DispatchQueue.main.async {
                NetworkManager.shared.fetchMeal(mealID: dessert.idMeal) {
                    [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let meal):
                        DispatchQueue.main.async {
                            self.meal = meal
                            self.updateProperties()
                        }
                    case .failure(let error):
                        let errorController = UIAlertController(title: "Something went wrong.", message: error.localizedDescription, preferredStyle: .alert)
//                        present(errorController, animated: true)
                    }
//                    self.dismissLoadingView()
                }
            }
        }
    }
    
    var mealName = Box(" ")
    var instructions = Box("Loading...")
    var mealImage: Box<UIImage?> = Box(nil)
    func updateProperties(){
        guard let meal = meal else { return }
        let tempImageView = UIImageView()
        tempImageView.downloadImage(from: meal.strMealThumb)
        mealName.value = meal.strMeal
        instructions.value = meal.strInstructions
        mealImage.value = tempImageView.image
    }
    
}//End of Class

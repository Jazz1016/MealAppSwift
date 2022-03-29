//
//  Meal.swift
//  MealApp
//
//  Created by James Lea on 3/27/22.
//

import Foundation

struct Meal: Codable, Hashable {
    let idMeal          : String
    let strMeal         : String
    let strInstructions : String
    let strMealThumb    : String
    let strYoutube      : String?
    var ingredients     : [String]?
    var measurements    : [String]?
}

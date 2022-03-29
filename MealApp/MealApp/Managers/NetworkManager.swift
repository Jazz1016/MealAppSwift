//
//  NetworkManager.swift
//  MealApp
//
//  Created by James Lea on 3/27/22.
//

import UIKit

public class NetworkManager {
    public static let shared    = NetworkManager()
    
    let cache                   = NSCache<NSString, UIImage>()
    
    private let baseUrl = "https://www.themealdb.com/api/json/v1/1/"
    //Fetch Desserts https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert
    //Fetch Dessert  https://www.themealdb.com/api/json/v1/1/lookup.php?i=53049
    
    private init() {}
    
    func fetchDesserts(completed: @escaping (Result<[Dessert], NetworkError>) -> Void){
        let endpoint = baseUrl + "filter.php?c=Dessert"
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completed(.failure(.thrownError(error)))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToDecode))
                return
            }
            
            guard let data = data else {
                completed(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode([String : [Dessert]].self, from: data)
                guard let desserts = topLevelObject["meals"] else { return }
                completed(.success(desserts))
            } catch {
                completed(.failure(.thrownError(error)))
            }
            
        }
        task.resume()
    }

    func fetchDessert(mealID: String, completed: @escaping (Result<Meal, NetworkError>) -> Void) {
        let endpoint = baseUrl + "lookup.php?i=\(mealID)"
        guard let url = URL(string: endpoint) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completed(.failure(.thrownError(error)))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToDecode))
                return
            }

            guard let data = data else {
                completed(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode([String : [Meal]].self, from: data)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : [[String: AnyObject]]]
                guard let tempArray = topLevelObject["meals"] else { return }
                let tempMeal = tempArray[0]
                var ingredients : [[String : AnyObject]] = []
                var measurements: [[String : AnyObject]] = []
                let mealDict = json?["meals"]
                
                mealDict?.forEach({ prop in
                    for (key, value) in prop {
                        if key.contains("strIngredient") && "\(value)" != "" {
                            ingredients.append([key : value])
                        } else if key.contains("strMeasure") && "\(value)" != "" {
                            measurements.append([key : value])
                        }
                    }
                })
                
                let tempIngredients: [String] = ingredients.sorted { lhs, rhs in
                    return lhs.keys.first ?? "" < rhs.keys.first ?? ""
                }.map({ el in
                    for (_, value) in el {
                        return "\(value)"
                    }
                    return ""
                })
                
                let tempMeasurements: [String] = measurements.sorted { lhs, rhs in
                    return lhs.keys.first ?? "" < rhs.keys.first ?? ""
                }.map({ el in
                    for (_, value) in el {
                        return "\(value)"
                    }
                    return ""
                })
                
                completed(.success(Meal(idMeal: tempMeal.idMeal, strMeal: tempMeal.strMeal, strInstructions: tempMeal.strInstructions, strMealThumb: tempMeal.strMealThumb, strYoutube: tempMeal.strYoutube, ingredients: tempIngredients, measurements: tempMeasurements)))
            } catch {
                completed(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }

}//End of Class

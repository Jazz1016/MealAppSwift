//
//  MealDetailVC.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class MealDetailVC: UIViewController {
    
    class Section {
        let title: String
        var isOpened: Bool = false
        
        init(title: String, isOpened: Bool = false) {
            self.title      = title
            self.isOpened   = isOpened
        }
    }
        
    private var sections = [Section]()
    
    let mealImageView       = UIImageView()
    let ingredientTableView = UITableView()
    let scrollView          = UIScrollView()
    let mealLabel           = MealTitleLabel(textAlignment: .left, fontSize: 20)
    let instructionsLabel   = MealBodyLabel(textAlignment: .left)
    var meal: Meal?
    var dessert: Dessert? {
        didSet {
            guard let dessert = dessert else { return }
            showLoadingView()
            DispatchQueue.main.async {
                NetworkManager.shared.fetchDessert(mealID: dessert.idMeal) {
                    [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let meal):
                        DispatchQueue.main.async {
                            self.meal = meal
                            self.setupUIElements()
                        }
                    case .failure(let error):
                        let errorController = UIAlertController(title: "Something went wrong.", message: error.localizedDescription, preferredStyle: .alert)
                        self.present(errorController, animated: true)
                    }
                    self.dismissLoadingView()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        layoutUI()
        sections = [Section(title: "Section1")]
    }
    
    func layoutUI(){
        view.addSubview(mealImageView)
        view.addSubview(mealLabel)
        view.addSubview(scrollView)
        view.addSubview(ingredientTableView)
        view.addSubview(instructionsLabel)
        
        mealImageView.translatesAutoresizingMaskIntoConstraints         = false
        mealLabel.translatesAutoresizingMaskIntoConstraints             = false
        scrollView.translatesAutoresizingMaskIntoConstraints            = false
        ingredientTableView.translatesAutoresizingMaskIntoConstraints   = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints     = false
        
//        mealImageView.backgroundColor       = .blue
//        instructionsLabel.backgroundColor   = .green
//        ingredientTableView.backgroundColor = .systemMint
//        mealLabel.backgroundColor           = .systemOrange
        scrollView.backgroundColor = .systemGray6
//
        let padding: CGFloat    = 20
        let rowHeight: CGFloat  = 400
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mealImageView.heightAnchor.constraint(equalToConstant: 140),
            mealImageView.widthAnchor.constraint(equalToConstant: 140),
            
            mealLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: padding),
            mealLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            mealLabel.heightAnchor.constraint(equalToConstant: 32),
            
            scrollView.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: padding),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            scrollView.heightAnchor.constraint(equalTo: instructionsLabel.heightAnchor, multiplier: 1.1),
            
            instructionsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            instructionsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            instructionsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            instructionsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            
            ingredientTableView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: padding), ///FIX MEEEEEE
            ingredientTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            ingredientTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ingredientTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: rowHeight)
        ])
    }
    
    func configureTableView(){
        ingredientTableView.delegate    = self
        ingredientTableView.dataSource  = self
        
        ingredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ingredientTableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.reuseID)
    }
    
    func setupUIElements() {
        guard let meal = meal else { return }
        mealImageView.downloadImage(from: meal.strMealThumb)
        
        ingredientTableView.rowHeight = 80
        ingredientTableView.backgroundColor = .systemBackground
        
        mealLabel.text = meal.strMeal
        instructionsLabel.text = meal.strInstructions
        instructionsLabel.adjustsFontSizeToFitWidth = true
        instructionsLabel.numberOfLines = 0
        
        ingredientTableView.reloadData()
    }

}//End of Class

extension MealDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = meal?.ingredients else { return 1 }
        let section = sections[section]
        
        if section.isOpened {
            return ingredients.count + 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let section = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            section.textLabel?.text = "Ingredients"
//            section.textLabel?.
            return section
        }
        guard let ingredients = meal?.ingredients,
              let measurements = meal?.measurements else { return UITableViewCell() }
        if indexPath.row == 1 {
            let sectionHead = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID, for: indexPath) as! IngredientCell
            sectionHead.set(ingredient: "Ingredient", measurement: "Measurement")
            return sectionHead
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID, for: indexPath) as! IngredientCell
        
        cell.set(ingredient: ingredients[indexPath.row - 2], measurement: measurements[indexPath.row - 2])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
    
}

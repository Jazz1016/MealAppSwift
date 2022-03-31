//
//  MealDetailVC.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class MealDetailVC: UIViewController {
    
    var mealImageView           = UIImageView()
    let ingredientTableView     = UITableView()
    let scrollView              = UIScrollView()
    let mealLabel               = MealTitleLabel(textAlignment: .left, fontSize: 20)
    let instructionsTitleLabel  = MealTitleLabel(textAlignment: .center, fontSize: 16)
    let instructionsLabel       = MealBodyLabel(textAlignment: .left)
    
    var viewModel = MealDetailVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.mealName.bind { [weak self] mealName in
            self?.mealLabel.text = mealName
        }
        viewModel.instructions.bind { [weak self] instructions in
            self?.instructionsLabel.text = instructions
        }
        viewModel.mealImage.bind { [weak self] mealImage in
            self?.mealImageView.image = mealImage
        }
        configureTableView()
        layoutUI()
        instructionsTitleLabel.text = "Instructions"
    }
    
    func layoutUI(){
        view.addSubview(mealImageView)
        view.addSubview(mealLabel)
        view.addSubview(scrollView)
        view.addSubview(ingredientTableView)
        scrollView.addSubview(instructionsLabel)
        
        mealImageView.translatesAutoresizingMaskIntoConstraints         = false
        mealLabel.translatesAutoresizingMaskIntoConstraints             = false
        scrollView.translatesAutoresizingMaskIntoConstraints            = false
        ingredientTableView.translatesAutoresizingMaskIntoConstraints   = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints     = false
        
        view.backgroundColor                        = .systemBackground
        
        scrollView.backgroundColor                  = .systemGray6
        scrollView.showsVerticalScrollIndicator     = true

        ingredientTableView.rowHeight               = 40
        ingredientTableView.backgroundColor         = .systemBackground
        
        instructionsLabel.adjustsFontSizeToFitWidth = true
        instructionsLabel.numberOfLines             = 0

        ingredientTableView.reloadData()
        
        scrollView.backgroundColor      = .systemGray6
        
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
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            instructionsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            instructionsLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            instructionsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 1),
            instructionsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            
            ingredientTableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: padding),
            ingredientTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            ingredientTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ingredientTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: rowHeight),
            ingredientTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36)
        ])
    }
    
    func configureTableView(){
        ingredientTableView.delegate    = self
        ingredientTableView.dataSource  = self
        
        ingredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ingredientTableView.register(IngredientHeadCell.self, forCellReuseIdentifier: IngredientHeadCell.reuseID)
        ingredientTableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.reuseID)
    }

}//End of Class

extension MealDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = viewModel.meal?.ingredients else { return 1 }
        let section = viewModel.sections[section]
        
        if section.isOpened {
            return ingredients.count + 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let section = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            section.backgroundColor = .systemGray4
            section.textLabel?.text = "Ingredients"
            section.accessoryType = .detailButton
            return section
        }
        
        guard let ingredients = viewModel.meal?.ingredients,
              let measurements = viewModel.meal?.measurements else { return UITableViewCell() }
        
        if indexPath.row == 1 {
            let sectionHead = tableView.dequeueReusableCell(withIdentifier: IngredientHeadCell.reuseID, for: indexPath) as! IngredientHeadCell
            sectionHead.set(ingredient: "Ingredient", measurement: "Measurement")
            sectionHead.backgroundColor = .systemGray4
            return sectionHead
        }
        
        print("ingredients", ingredients[indexPath.row - 2], indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID, for: indexPath) as! IngredientCell
        
        cell.set(ingredient: ingredients[indexPath.row - 2], measurement: measurements[indexPath.row - 2])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.sections[indexPath.section].isOpened = !viewModel.sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
}//End of Extension

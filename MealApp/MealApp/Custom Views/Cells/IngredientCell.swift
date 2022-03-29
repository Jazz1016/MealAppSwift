//
//  IngredientCell.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    static let reuseID      = "ingredientCell"
    let ingredientLabel = MealTitleLabel(textAlignment: .left, fontSize: 16)
    let measurementLabel = MealTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(ingredient: String, measurement: String) {
        ingredientLabel.text    = ingredient
        measurementLabel.text   = measurement
    }
    
    func configure(){
        addSubview(ingredientLabel)
        addSubview(measurementLabel)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            ingredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
        ])
    }

}//End of Class

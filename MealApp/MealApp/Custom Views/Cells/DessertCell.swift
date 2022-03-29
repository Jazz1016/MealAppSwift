//
//  DessertCell.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class DessertCell: UITableViewCell {
    
    static let reuseID      = "dessert"
    let dessertImageView    = UIImageView()
    let dessertLabel        = MealTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(dessert: Dessert) {
        dessertImageView.downloadImage(from: dessert.strMealThumb)
        dessertLabel.text = dessert.strMeal
    }
    
    private func configure() {
        addSubview(dessertImageView)
        addSubview(dessertLabel)
        
        accessoryType                       = .disclosureIndicator
        
        dessertImageView.layer.cornerRadius = 10
        dessertImageView.clipsToBounds      = true
        
        dessertImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            dessertImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dessertImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dessertImageView.trailingAnchor.constraint(equalTo: dessertImageView.trailingAnchor),
            dessertImageView.heightAnchor.constraint(equalToConstant: 30),
            dessertImageView.widthAnchor.constraint(equalToConstant: 30),
            
//            dessertLabel.topAnchor.constraint(equalTo: dessertImageView.topAnchor),
            dessertLabel.centerYAnchor.constraint(equalTo: dessertImageView.centerYAnchor),
            dessertLabel.leadingAnchor.constraint(equalTo: dessertImageView.trailingAnchor, constant: 6),
            dessertLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding),
            dessertLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}//End of Class

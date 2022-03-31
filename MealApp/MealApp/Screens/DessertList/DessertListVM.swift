//
//  DessertListVM.swift
//  MealApp
//
//  Created by James Lea on 3/30/22.
//

import UIKit

class DessertListVM {
    
    enum Section { case main }
    
    var desserts: [Dessert] = []
    
    func fetchDessserts(viewController: UIViewController, tableView: UITableView){
        DispatchQueue.main.async {
            viewController.showLoadingView()
            NetworkManager.shared.fetchDesserts { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let desserts):
                    self.desserts  = desserts
                    DispatchQueue.main.async {
                        viewController.dismissLoadingView()
                        tableView.reloadData()
                    }
                case .failure(let error):
                    let errorController = UIAlertController(title: "Something went wrong. Please try again 😅.", message: error.localizedDescription,  preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    errorController.addAction(doneAction)
                    DispatchQueue.main.async {
                        viewController.dismissLoadingView()
                        viewController.present(errorController, animated: true)
                    }
                }
                
            }
        }
    }
 
    func configureTableView(viewController: UIViewController, tableView: UITableView){
        viewController.view.addSubview(tableView)
        tableView.frame = viewController.view.bounds
        tableView.rowHeight = 80
        tableView.delegate = viewController as? UITableViewDelegate
        tableView.dataSource = viewController as? UITableViewDataSource
        
        tableView.register(DessertCell.self, forCellReuseIdentifier: DessertCell.reuseID)
    }
}

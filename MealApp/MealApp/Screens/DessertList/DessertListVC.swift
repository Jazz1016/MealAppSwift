//
//  DessertListVC.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class DessertListVC: UIViewController {
    
    let viewModel = DessertListVM()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDessserts(viewController: self, tableView: tableView)
        configureTableView()
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DessertCell.self, forCellReuseIdentifier: DessertCell.reuseID)
    }

}//End of Class

extension DessertListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.desserts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DessertCell.reuseID, for: indexPath) as! DessertCell
        let dessert = self.viewModel.desserts[indexPath.row]
        cell.set(dessert: dessert)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dessert = viewModel.desserts[indexPath.row]
        let destVC  = MealDetailVC()
        destVC.viewModel.dessert = dessert
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
}//End of Extension

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
        viewModel.configureTableView(viewController: self, tableView: tableView)
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

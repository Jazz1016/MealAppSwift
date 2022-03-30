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
        viewController.showLoadingView()
        DispatchQueue.main.async {
            NetworkManager.shared.fetchDesserts { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let desserts):
                    self.desserts  = desserts
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                case .failure(let error):
                    let errorController = UIAlertController(title: "Something went wrong.", message: error.localizedDescription,  preferredStyle: .alert)
                    viewController.present(errorController, animated: true)
                }
                viewController.dismissLoadingView()
            }
        }
    }
    
}//End of Class

//extension DessertListVM: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return desserts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: DessertCell.reuseID, for: indexPath) as! DessertCell
//        let dessert = self.desserts[indexPath.row]
//        cell.set(dessert: dessert)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dessert = desserts[indexPath.row]
//        let destVC  = MealDetailVC()
//        destVC.viewModel.dessert = dessert
//
//        navigationController?.pushViewController(destVC, animated: true)
//    }
//}

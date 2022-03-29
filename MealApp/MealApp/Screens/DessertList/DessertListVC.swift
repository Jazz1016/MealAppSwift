//
//  DessertListVC.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

class DessertListVC: UIViewController {
    
    enum Section { case main }
    
    let tableView = UITableView()
    var desserts: [Dessert] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDessserts()
        configureTableView()
    }
    
    func fetchDessserts(){
        showLoadingView()
        NetworkManager.shared.fetchDesserts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let desserts):
                self.desserts  = desserts
                self.updateData(on: self.desserts)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                let errorController = UIAlertController(title: "Something went wrong.", message: error.localizedDescription, preferredStyle: .alert)
                self.present(errorController, animated: true)
            }
            self.dismissLoadingView()
        }
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DessertCell.self, forCellReuseIdentifier: DessertCell.reuseID)
    }
    
    ///BRBs
//    func configureDataSource() {
//        dataSource = UITableViewDiffableDataSource<Section, Dessert>(tableView: tableView, cellProvider: { tableView, indexPath, dessert in
//            let cell = tableView.dequeueReusableCell(withIdentifier: DessertCell.reuseID, for: indexPath) as! DessertCell
//            cell.set(dessert: dessert)
//            return cell
//        })
//    }
    
    func updateData(on desserts: [Dessert]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Dessert>()
        snapshot.appendSections([.main])
        snapshot.appendItems(desserts)
        
//        DispatchQueue.main.async { self.dataSource!.apply(snapshot, animatingDifferences: true) }
    }


}//End of Class

extension DessertListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desserts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DessertCell.reuseID, for: indexPath) as! DessertCell
        let dessert = self.desserts[indexPath.row]
        cell.set(dessert: dessert)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dessert = desserts[indexPath.row]
        let destVC  = MealDetailVC()
        destVC.dessert = dessert
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
}//End of Extension

//
//  KIChatDialoguesListVC.swift
//  KIUIKit
//
//  Created by Macbook on 9/26/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIChatDialoguesListVC: UIViewController {
    
    private var tableView = UITableView()
    private var searchController = UISearchController(searchResultsController: nil)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        setupViews()
    }
    
    private func setupViews() {
        title = "history"
        navigationController?.hidesBarsOnSwipe = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
//        searchController.searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(KIChatDialoguesListCell.self, forCellReuseIdentifier: KIChatDialoguesListCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            [tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach({$0.isActive = true})
        } else {
            [tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)].forEach({$0.isActive = true})
        }
        
    }
    
}

extension KIChatDialoguesListVC: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KIChatDialoguesListCell.reuseIdentifier, for: indexPath) as! KIChatDialoguesListCell
        cell.set(viewModel: nil, type: .group, width: view.frame.width)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension KIChatDialoguesListVC: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
    
    
}

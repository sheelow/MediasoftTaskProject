//
//  TableViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit

class TableViewController: UIViewController {

    var viewModel: TableViewViewModelProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TableViewViewModel()
        configureView()
    }
    
    private func configureView() {
        self.navigationItem.title = "Table View"
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    
}

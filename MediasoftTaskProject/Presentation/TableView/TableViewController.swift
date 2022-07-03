//
//  TableViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit

//MARK: - TableViewProtocol
protocol TableViewProtocol: AnyObject {
    func configureTableView()
    func reloadData()
}

//MARK: - TableViewController
class TableViewController: UIViewController {
    
    //MARK: - Properties
    private var presenter: TableViewPresenterProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //MARK: - Init
    init(presenter: TableViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        configureSearchBar()
        configureTableView()
        self.navigationItem.title = "Table View"
        view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTableView()
    }
    
    //MARK: - Methods
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.isActive = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    private func animateTableView() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableViewHeights = tableView.bounds.height
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeights)
            
            UIView.animate(withDuration: 1.1,
                           delay: delay * 0.05,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { cell.transform = CGAffineTransform.identity },
                           completion: nil)
            delay += 1
        }
    }
}

//MARK: - TableMenuViewProtocol
extension TableViewController: TableViewProtocol {
    
    func configureTableView() {
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.cellForRow(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
}

//MARK: - UITableViewDelegate
extension TableViewController: UITableViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let indicator = UIActivityIndicatorView(style: .medium)
        
        let position = tableView.contentOffset.y
        let tableHeight = tableView.contentSize.height
        if position + tableView.frame.size.height >= tableHeight {
            indicator.frame = CGRect(x: CGFloat(0), y: 0, width: tableView.bounds.width, height: 44)
            
            tableView.tableFooterView = indicator
            indicator.startAnimating()
            tableView.tableFooterView?.isHidden = false
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                guard let self = self else { return }
                self.presenter.appendData()
                indicator.stopAnimating()
                self.tableView.tableFooterView?.isHidden = true
            })
        }
    }
}

//MARK: - UISearchBarDelegate
extension TableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presenter.searchResults(searchText: searchText)
        }
    }
}

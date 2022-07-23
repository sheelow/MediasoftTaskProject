//
//  TableViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit

//MARK: - TableViewProtocol
protocol ProfilesViewProtocol: AnyObject {
    func configureTableView()
    func reloadData()
}

//MARK: - TableViewController
final class ProfilesViewController: UIViewController {

    //MARK: - Properties
    private var presenter: ProfilesPresenterProtocol

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfilesViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private var isSearching = false

    //MARK: - Init
    init(presenter: ProfilesPresenterProtocol) {
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
        self.navigationItem.title = "Profiles"
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
extension ProfilesViewController: ProfilesViewProtocol {

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
extension ProfilesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ProfilesViewCell
        guard let cell = cell else { return UITableViewCell() }

        cell.delegate = self

        if isSearching {
            cell.model = ProfilesViewCellModel(
                id: presenter.filteredData[indexPath.row].id ?? "",
                name: presenter.filteredData[indexPath.row].user?.firstName ?? "",
                secondName: presenter.filteredData[indexPath.row].user?.lastName ?? "",
                description: presenter.filteredData[indexPath.row].description ?? "",
                photo: presenter.filteredData[indexPath.row].urls?.regular ?? "")
        } else {
            cell.model = ProfilesViewCellModel(
                id: presenter.model[indexPath.row].id ?? "",
                name: presenter.model[indexPath.row].user?.firstName ?? "",
                secondName: presenter.model[indexPath.row].user?.lastName ?? "",
                description: presenter.model[indexPath.row].description ?? "",                                    
                photo: presenter.model[indexPath.row].urls?.regular ?? "")
        }

        if let model = SQLiteCommands.presentRows() {

            for i in model {
                if cell.model?.id == i.id {
                    cell.isSelectedButton = true
                    cell.favouritesButton.tintColor = .systemYellow
                }
            }
        }

        cell.setContent()
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        self.isSearching = presenter.isSearching

        if isSearching {
            return presenter.filteredData.count
        } else {
            return presenter.model.count
        }
    }
}

//MARK: - UITableViewDelegate
extension ProfilesViewController: UITableViewDelegate {

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
extension ProfilesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presenter.searchResults(searchText: searchText)
        }
    }
}

//MARK: - TableViewCellProtocol
extension ProfilesViewController: ProfilesViewCellProtocol {

    func didPressProfilesViewCellFavouritesButton(isSelected: Bool, model: ProfilesViewCellModel) {

        if isSelected {
            let databaseModel = SQLiteCommands.presentRows()
            guard let databaseModel = databaseModel else { return }

            for i in databaseModel {
                if model.id == i.id { return }
            }

            let data = Data(model.photo.utf8)
            SQLiteCommands.insertRow(DatabaseModel(id: model.id, firstName: model.name, lastName: model.secondName, photo: data))
        } else {
            SQLiteCommands.deleteRow(profileId: model.id)
        }
    }
}

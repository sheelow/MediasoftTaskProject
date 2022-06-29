//
//  TableViewPresenter.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation
import UIKit
import CoreAudio

//MARK: - TableViewPresenterProtocol
protocol TableViewPresenterProtocol: AnyObject {
    var view: TableViewProtocol? { get set }
    var filteredData: [ResultPhoto] { get set }
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func cellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func searchResults(searchText: String)
    func appendData()
}

//MARK: - TableViewPresenter
class TableViewPresenter: TableViewPresenterProtocol {
    
    //MARK: - Properties
    weak var view: TableViewProtocol?
    var filteredData: [ResultPhoto] = []
    private var service: NetworkService?
    private var model: [ResultPhoto] = []
    private var pageCount = 2
    private var isSearching = false
    
    //MARK: - Init
    init() {
        self.service = NetworkService()
    }
    
    //MARK: - Methods
    func viewDidLoad() {
        fetchData()
        view?.configureTableView()
    }
    
    func numberOfRowsInSection() -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return model.count
        }
        
    }
    
    func cellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        if isSearching {
            cell.model = TableViewCellModel(name: filteredData[indexPath.row].user?.firstName ?? "",
                                            secondName: filteredData[indexPath.row].user?.lastName ?? "",
                                            description: filteredData[indexPath.row].description ?? "",
                                            photo: filteredData[indexPath.row].urls?.regular ?? "")
        } else {
            cell.model = TableViewCellModel(name: model[indexPath.row].user?.firstName ?? "",
                                            secondName: model[indexPath.row].user?.lastName ?? "",
                                            description: model[indexPath.row].description ?? "",
                                            photo: model[indexPath.row].urls?.regular ?? "")
        }
        
        cell.setContent()
        return cell
    }
    
    func searchResults(searchText: String) {
        self.filteredData.removeAll()
        guard searchText.isEmpty || searchText != " " else {
            print("empty search")
            return
        }
        
        for item in model {
            let text = searchText.lowercased()
            let isArrayCountainName = item.user?.firstName?.lowercased().range(of: text)
            let isArrayCountainLastName = item.user?.lastName?.lowercased().range(of: text)
            if isArrayCountainName != nil || isArrayCountainLastName != nil {
                print("Search complete")
                self.filteredData.append(item)
            }
        }
        print(filteredData)
        
        if searchText == "" {
            isSearching = false
            view?.reloadData()
        } else {
            isSearching = true
            view?.reloadData()
        }
    }
    
    func appendData() {
        service?.fetchData(page: pageCount) { [weak self] profiles in
            guard let self = self else { return }
            self.model.append(contentsOf: profiles)
            self.view?.reloadData()
            self.pageCount += 1
        }
    }
    
    private func fetchData() {
        service?.fetchData(page: 1) { [weak self] profiles in
            guard let self = self else { return }
            self.model = profiles
            self.view?.reloadData()
        }
    }
}

extension TableViewPresenter: TableViewCellProtocol {
    
    func didPressTableViewCellFavouritesTutton(isSelected: Bool, model: TableViewCellModel) {
        if isSelected == true {
            print("selected - TRUE")
            DatabaseService.shared.appendElements(profile: model)
            print (DatabaseService.shared.model)
        } else {
            print("selected - FALSE")
        }
    }
}

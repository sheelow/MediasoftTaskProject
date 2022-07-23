//
//  TableViewPresenter.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation

//MARK: - TableViewPresenterProtocol
protocol ProfilesPresenterProtocol: AnyObject {

    var view: ProfilesViewProtocol? { get set }
    var model: [ResultPhoto] { get set }
    var filteredData: [ResultPhoto] { get set }
    var isSearching: Bool { get set }
    func viewDidLoad()
    func searchResults(searchText: String)
    func appendData()
}

//MARK: - TableViewPresenter
final class ProfilesPresenter: ProfilesPresenterProtocol {

    //MARK: - Properties
    weak var view: ProfilesViewProtocol?

    var model: [ResultPhoto] = []

    var filteredData: [ResultPhoto] = []

    var service: NetworkServiceProtocol

    var isSearching = false

    private var pageCount = 2

    //MARK: - Init
    init(service: NetworkServiceProtocol) {
        self.service = service
    }

    //MARK: - Methods
    func viewDidLoad() {
        createTable()
        fetchData()
        view?.configureTableView()
    }

    func searchResults(searchText: String) {
        self.filteredData.removeAll()
        guard searchText.isEmpty || searchText != " " else {
            return
        }

        for item in model {
            let text = searchText.lowercased()
            let isArrayCountainName = item.user?.firstName?.lowercased().range(of: text)
            let isArrayCountainLastName = item.user?.lastName?.lowercased().range(of: text)
            if isArrayCountainName != nil || isArrayCountainLastName != nil {
                self.filteredData.append(item)
            }
        }

        if searchText == "" {
            isSearching = false
            view?.reloadData()
        } else {
            isSearching = true
            view?.reloadData()
        }
    }

    func appendData() {
        service.fetchData(page: pageCount) { [weak self] profiles in
            guard let self = self else { return }
            self.model.append(contentsOf: profiles)
            self.view?.reloadData()
            self.pageCount += 1
        }
    }

    private func createTable() {
        let database = SQLiteDatabase.shared
        database.createTable()
    }

    private func fetchData() {
        service.fetchData(page: 1) { [weak self] profiles in
            guard let self = self else { return }
            self.model = profiles
            self.view?.reloadData()
        }
    }
}

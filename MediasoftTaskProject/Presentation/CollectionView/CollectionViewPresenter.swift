//
//  CollectionViewPresenter.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation
import UIKit

//MARK: - CollectionViewPresenterProtocol
protocol CollectionViewPresenterProtocol: AnyObject {
    var view: CollectionViewProtocol? { get set }
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

//MARK: - CollectionViewPresenter
final class CollectionViewPresenter: CollectionViewPresenterProtocol {
    
    //MARK: - Properties
//    var mockData: TableViewCellModel = TableViewCellModel.init(name: "Lox", secondName: "Ebaniy", description: "YA TAKOY", photo: "https://images.unsplash.com/photo-1517841905240-472988babdf9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNDE1MDF8MHwxfHNlYXJjaHwzfHxwZW9wbGV8ZW58MHx8fHwxNjU2NTE5NDYy&ixlib=rb-1.2.1&q=80&w=1080")
    weak var view: CollectionViewProtocol?
    private var service: DatabaseService?
    private var model: [TableViewCellModel] = []
//    DatabaseService.shared.model
    
    init() {
        self.service = DatabaseService()
    }
    
    //MARK: - Methods
    func viewDidLoad() {
//        model.append(mockData)
//        fetchData()
        model = DatabaseService.shared.model
        view?.configureCollectionView()
        print(model.first?.name)
    }
    
    func numberOfRowsInSection() -> Int {
        return model.count
    }
    
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.model = CollectionViewCellModel(name: model[indexPath.row].name,
                                             secondName: model[indexPath.row].secondName,
                                             photo: model[indexPath.row].photo)
        cell.setContent()
        return cell
    }
}

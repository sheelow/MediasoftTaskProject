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
    func configureModel()
}

//MARK: - CollectionViewPresenter
final class CollectionViewPresenter: CollectionViewPresenterProtocol {
    
    //MARK: - Properties
    weak var view: CollectionViewProtocol?
    
    private var cellModel: [CollectionViewCellModel] = []
    
    //MARK: - Methods
    func viewDidLoad() {
        createTable()
    }
    
    func numberOfRowsInSection() -> Int {
        return cellModel.count
    }
    
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.model = CollectionViewCellModel(id: cellModel[indexPath.row].id,
                                             name: cellModel[indexPath.row].name,
                                             secondName: cellModel[indexPath.row].secondName,
                                             photo: cellModel[indexPath.row].photo)
        cell.delegate = self
        cell.setContent()
        return cell
    }
    
    func configureModel() {
        conversionModel { [weak self] data in
            guard let self = self else { return }
            self.cellModel = data
            self.view?.reloadCollectionView()
        }
    }
    
    private func createTable() {
        let database = SQLiteDatabase.shared
        database.createTable()
    }
    
    private func conversionModel(completion: @escaping ([CollectionViewCellModel]) -> Void) {
        
        let model: [DatabaseModel] = SQLiteCommands.presentRows() ?? []
        var cellModel: [CollectionViewCellModel] = []
        
        for item in model {
            let string = String(decoding: item.photo, as: UTF8.self)
            cellModel.append(CollectionViewCellModel(id: item.id, name: item.firstName, secondName: item.lastName, photo: string))
        }
        completion(cellModel)
    }
}

//MARK: - CollectionViewCellProtocol
extension CollectionViewPresenter: CollectionViewCellProtocol {
    
    func didPressCollectionViewCellDeleteButton(model: CollectionViewCellModel) {
        SQLiteCommands.deleteRow(profileId: model.id)
        self.conversionModel { [weak self] data in
            guard let self = self else { return }
            self.cellModel = data
            self.view?.reloadCollectionView()
        }
    }
}

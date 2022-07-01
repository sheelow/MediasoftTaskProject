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
    
    private var model: [CollectionViewCellModel] = []
    
    //MARK: - Methods
    func viewDidLoad() {
        createTable()
        view?.configureCollectionView()
    }
    
    func numberOfRowsInSection() -> Int {
        return model.count
    }
    
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.delegate = self
        
        cell.model = CollectionViewCellModel(id: model[indexPath.row].id,
                                             name: model[indexPath.row].name,
                                             secondName: model[indexPath.row].secondName,
                                             photo: model[indexPath.row].photo)
        cell.setContent()
        return cell
    }
    
    func configureModel() {
        conversionModel { [weak self] data in
            self?.model = data
            self?.view?.reloadCollectionView()
        }
    }
    
    private func createTable() {
        let database = SQLiteDatabase.shared
        database.createTable()
    }
    
    private func conversionModel(completion: @escaping ([CollectionViewCellModel]) -> Void) {
        
        let model: [DatabaseModel] = SQLiteCommands.presentRows() ?? []
        var cellModel: [CollectionViewCellModel] = []
        
        for x in model {
            let string = String(decoding: x.photo, as: UTF8.self)
            cellModel.append(CollectionViewCellModel(id: x.id, name: x.firstName, secondName: x.lastName, photo: string))
        }
        completion(cellModel)
    }
}

//MARK: - CollectionViewCellProtocol
extension CollectionViewPresenter: CollectionViewCellProtocol {
    
    func didPressCollectionViewCellDeleteButton(model: CollectionViewCellModel) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            SQLiteCommands.deleteRow(profileId: model.id)
            self.conversionModel { [weak self] data in
                self?.model = data
                self?.view?.reloadCollectionView()
            }
        }
    }
}

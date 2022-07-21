//
//  CollectionViewPresenter.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation

//MARK: - CollectionViewPresenterProtocol
protocol FavouritesPresenterProtocol: AnyObject {

    var view: FavouritesViewProtocol? { get set }
    var cellModel: [FavouritesViewCellModel] { get set }
    func configureModel()
    func conversionModel(completion: @escaping ([FavouritesViewCellModel]) -> Void)
}

//MARK: - CollectionViewPresenter
final class FavouritesPresenter: FavouritesPresenterProtocol {

    //MARK: - Properties
    weak var view: FavouritesViewProtocol?

    var cellModel: [FavouritesViewCellModel] = []

    //MARK: - Methods
    func configureModel() {
        conversionModel { [weak self] data in
            guard let self = self else { return }
            self.cellModel = data
            self.view?.reloadCollectionView()
        }
    }

    func conversionModel(completion: @escaping ([FavouritesViewCellModel]) -> Void) {

        let model: [DatabaseModel] = SQLiteCommands.presentRows() ?? []
        var cellModel: [FavouritesViewCellModel] = []

        for item in model {
            let string = String(decoding: item.photo, as: UTF8.self)
            cellModel.append(FavouritesViewCellModel(id: item.id,
                                                     name: item.firstName,
                                                     secondName: item.lastName,
                                                     photo: string))
        }
        completion(cellModel)
    }
}

//
//  CollectionViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit

//MARK: - CollectionViewProtocol
protocol FavouritesViewProtocol: AnyObject {
    func reloadCollectionView()
}

//MARK: - CollectionViewController
final class FavouritesViewController: UIViewController {

    //MARK: - Properties
    private var presenter: FavouritesPresenterProtocol

    private lazy var сollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width / 2.1, height: view.frame.size.height / 4)
        let сollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        сollectionView.register(FavouritesViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        сollectionView.dataSource = self
        return сollectionView
    }()

    //MARK: - Init
    init(presenter: FavouritesPresenterProtocol) {
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
        configureCollectionView()
        self.navigationItem.title = "Favourites"
        view.layoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionView()
        presenter.configureModel()
    }

    private func configureCollectionView() {
        view.addSubview(сollectionView)
        сollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - CollectionViewProtocol
extension FavouritesViewController: FavouritesViewProtocol {

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.сollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension FavouritesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.cellModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? FavouritesViewCell
        guard let cell = cell else { return UICollectionViewCell() }

        cell.model = FavouritesViewCellModel(
            id: presenter.cellModel[indexPath.row].id,
            name: presenter.cellModel[indexPath.row].name,
            secondName: presenter.cellModel[indexPath.row].secondName,
            photo: presenter.cellModel[indexPath.row].photo)
        
        cell.delegate = self
        cell.setContent()
        return cell
    }
}

//MARK: - CollectionViewCellProtocol
extension FavouritesViewController: FavouritesViewCellProtocol {

    func didPressFavouritesViewCellDeleteButton(model: FavouritesViewCellModel) {
        SQLiteCommands.deleteRow(profileId: model.id)
        self.presenter.conversionModel { [weak self] data in
            guard let self = self else { return }
            self.presenter.cellModel = data
            self.presenter.view?.reloadCollectionView()
        }
    }
}

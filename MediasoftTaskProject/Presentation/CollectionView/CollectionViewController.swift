//
//  CollectionViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit

//MARK: - CollectionViewProtocol
protocol CollectionViewProtocol: AnyObject {
    func configureCollectionView()
    func reloadCollectionView()
}

//MARK: - CollectionViewController
class CollectionViewController: UIViewController {
    
    //MARK: - Properties
    private var presenter: CollectionViewPresenterProtocol
    
    private lazy var сollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/2.1, height: view.bounds.size.height/4)
        let сollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        сollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        сollectionView.dataSource = self
        return сollectionView
    }()
    
    //MARK: - Init
    init(presenter: CollectionViewPresenterProtocol) {
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
        configureCollectionView()
        self.navigationItem.title = "Collection View"
        view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionView()
        presenter.configureModel()
    }
}

//MARK: - CollectionViewProtocol
extension CollectionViewController: CollectionViewProtocol {
    
    func configureCollectionView() {
        view.addSubview(сollectionView)
        сollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.сollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        presenter.cellForItemAt(collectionView, cellForItemAt: indexPath)
    }
}

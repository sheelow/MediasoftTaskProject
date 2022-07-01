//
//  CollectionViewCell.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit
import Kingfisher

//MARK: - CollectionViewCellModel
struct CollectionViewCellModel {
    let id: String
    let name: String
    let secondName: String
    let photo: String
}

//MARK: - CollectionViewCellProtocol
protocol CollectionViewCellProtocol: AnyObject {
    func didPressCollectionViewCellDeleteButton(model: CollectionViewCellModel)
}

//MARK: - CollectionViewCell
class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    weak var delegate: CollectionViewCellProtocol?
    var model: CollectionViewCellModel?
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFit
        return photoImageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
//        favouritesButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        favouritesButton.tintColor = .systemGray
        favouritesButton.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        return favouritesButton
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configurePhotoImage()
        configureNameLabel()
        configureFavouritesButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.tintColor = .systemGray
    }
    
    func setContent() {
        nameLabel.text = (self.model?.name ?? "") + " " + (self.model?.secondName ?? "")
        self.photoImageView.kf.setImage(with: URL(string: model?.photo  ?? ""), placeholder: nil)
    }
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
        clipsToBounds = false
    }
    
    private func configurePhotoImage() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(50)
            make.height.width.equalTo(200)
        }
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(50)
            make.top.equalTo(photoImageView.snp.bottom)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func configureFavouritesButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.height.equalTo(30)
        }
    }
    
    @objc
    private func favouritesButtonTapped() {
        deleteButton.tintColor = .systemRed
        guard let model = model else { return }
        delegate?.didPressCollectionViewCellDeleteButton(model: model)
    }
}

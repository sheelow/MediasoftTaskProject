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
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        deleteButton.tintColor = .systemGray
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return deleteButton
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
        guard let name = model?.name, let secondName = model?.secondName, let image = model?.photo else { return }
        
        nameLabel.text = "\(name) \(secondName)"
        photoImageView.kf.setImage(with: URL(string: image), placeholder: nil)
    }
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = contentView.frame.height / 10
        contentView.layer.shadowRadius = contentView.frame.height / 5
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
    private func deleteButtonTapped() {
        guard let model = model else { return }
        deleteButton.tintColor = .systemRed
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.didPressCollectionViewCellDeleteButton(model: model)
        }
    }
}

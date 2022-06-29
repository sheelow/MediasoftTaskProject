//
//  TableViewCell.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit
import Kingfisher

//MARK: - TableViewCellModel
struct TableViewCellModel {
    let name: String
    let secondName: String
    let description: String
    let photo: String
}

protocol TableViewCellProtocol: AnyObject {
    func didPressTableViewCellFavouritesTutton(isSelected: Bool, model: TableViewCellModel)
}


//MARK: - TableViewCell
class TableViewCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: TableViewCellProtocol?
    var model: TableViewCellModel?
    
    private lazy var favouritesButton: UIButton = {
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        favouritesButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        favouritesButton.tintColor = .systemGray
        favouritesButton.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        return favouritesButton
    }()
    
    private var isSelectedButton = false
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 4
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 60
        photoImageView.layer.masksToBounds = true

        return photoImageView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelectedButton = false
        favouritesButton.tintColor = .systemGray
    }
    func setContent() {
        nameLabel.text = (self.model?.name ?? "") + " " + (self.model?.secondName ?? "")
        descriptionLabel.text = self.model?.description
        self.photoImageView.kf.setImage(with: URL(string: model?.photo  ?? ""), placeholder: nil)
    }
    
    private func configureCell() {
        accessoryView = favouritesButton
        configurePhotoImage()
        configureNameLabel()
        configureFavouritesButton()
        configureDescriptionLabel()
    }
    
    private func configurePhotoImage() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(photoImageView.snp.right).offset(20)
            make.top.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(120)
        }
    }
    
    private func configureFavouritesButton() {
        accessoryView = favouritesButton
//        addSubview(favouritesButton)
//        favouritesButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().inset(20)
//        }
    }
    
    private func configureDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(photoImageView.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(120)
        }
    }
    
    @objc
    private func favouritesButtonTapped() {
//        print("favouritesButton tapped")
        isSelectedButton.toggle()
        favouritesButton.tintColor = isSelectedButton ? .systemYellow : .systemGray
        guard let model = model else { return }
        delegate?.didPressTableViewCellFavouritesTutton(isSelected: isSelectedButton, model: model)
    }
}

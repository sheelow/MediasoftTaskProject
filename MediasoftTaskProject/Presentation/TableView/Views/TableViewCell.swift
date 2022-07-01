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
    let id: String
    let name: String
    let secondName: String
    let description: String
    let photo: String
    let isSelectedButton: Bool
}

//MARK: - TableViewCellProtocol
protocol TableViewCellProtocol: AnyObject {
    func didPressTableViewCellFavouritesButton(isSelected: Bool, model: TableViewCellModel)
}


//MARK: - TableViewCell
class TableViewCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: TableViewCellProtocol?
    var model: TableViewCellModel?
    var isSelectedButton = false
    
    lazy var favouritesButton: UIButton = {
        let favouritesButton = UIButton(type: .custom)
        favouritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        favouritesButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        favouritesButton.tintColor = isSelectedButton ? .systemYellow : .systemGray
        favouritesButton.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        return favouritesButton
    }()
    
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
        favouritesButton.tintColor = isSelectedButton ? .systemYellow : .systemGray
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
        isSelectedButton.toggle()
        favouritesButton.tintColor = isSelectedButton ? .systemYellow : .systemGray
        guard let model = model else { return }
        delegate?.didPressTableViewCellFavouritesButton(isSelected: isSelectedButton, model: model)
    }
}
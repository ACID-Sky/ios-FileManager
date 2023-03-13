//
//  CollectionViewCell.swift
//  FileManager
//
//  Created by Лёха Небесный on 13.03.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    let image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        self.contentView.backgroundColor = .systemBackground
        self.setupImage()
    }

    private func setupImage() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill

        self.contentView.addSubview(image)

        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }

    func setup(with image: UIImage){
        self.image.image = image
    }
}

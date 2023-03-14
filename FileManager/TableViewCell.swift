//
//  CollectionViewCell.swift
//  FileManager
//
//  Created by Лёха Небесный on 13.03.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    let image = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
        self.urlImage = nil
    }

    private func setupContentView() {
        self.contentView.backgroundColor = .systemBackground
        self.setupImage()
    }

    private func setupImage() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true

        self.contentView.addSubview(image)

        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.image.heightAnchor.constraint(equalToConstant: (self.contentView.frame.size.width * 9 / 16)),
            self.image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    func setup(with image: UIImage){
        self.image.image = image
    }
}

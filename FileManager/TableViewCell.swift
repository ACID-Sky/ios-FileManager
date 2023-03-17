//
//  CollectionViewCell.swift
//  FileManager
//
//  Created by Лёха Небесный on 13.03.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    let image = UIImageView()
    let fileName = UILabel()
    let fileCreationDateAndTime = UILabel()
    let fileSize = UILabel()

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
    }

    private func setupContentView() {
        self.contentView.backgroundColor = .systemBackground
        self.setupImage()
        setupfileName()
        setupfileCreationDateAndTime()
        setupfileSize()
    }

    private func setupImage() {
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.image.contentMode = .scaleToFill
        self.image.clipsToBounds = true

        self.contentView.addSubview(image)

        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.image.heightAnchor.constraint(equalToConstant: (self.contentView.frame.size.width * 9 / 16)),
        ])
    }

    private func setupfileName() {
        self.fileName.textColor = .black
        self.fileName.numberOfLines = 0
        self.fileName.font = UIFont.systemFont(ofSize: 14)
        self.fileName.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(fileName)

        NSLayoutConstraint.activate([
            self.fileName.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 8),
            self.fileName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.fileName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }

    private func setupfileCreationDateAndTime() {
        self.fileCreationDateAndTime.textColor = .black
        self.fileCreationDateAndTime.numberOfLines = 0
        self.fileCreationDateAndTime.font = UIFont.systemFont(ofSize: 14)
        self.fileCreationDateAndTime.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(fileCreationDateAndTime)

        NSLayoutConstraint.activate([
            self.fileCreationDateAndTime.topAnchor.constraint(equalTo: self.fileName.bottomAnchor, constant: 8),
            self.fileCreationDateAndTime.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.fileCreationDateAndTime.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }

    private func setupfileSize() {
        self.fileSize.textColor = .black
        self.fileSize.numberOfLines = 0
        self.fileSize.font = UIFont.systemFont(ofSize: 14)
        self.fileSize.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(fileSize)

        NSLayoutConstraint.activate([
            self.fileSize.topAnchor.constraint(equalTo: self.fileCreationDateAndTime.bottomAnchor, constant: 8),
            self.fileSize.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.fileSize.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.fileSize.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }

    func setup(with image: UIImage, name: String, creationDateAndTime: String, size: String){
        self.image.image = image
        self.fileName.text = "Название файла: " + name
        self.fileCreationDateAndTime.text = "Дата и время создания файла: " + creationDateAndTime
        self.fileSize.text = "Размер файла: " + size + "байт."
    }
}

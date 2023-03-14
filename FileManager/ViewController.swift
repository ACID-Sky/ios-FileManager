//
//  ViewController.swift
//  FileManager
//
//  Created by Лёха Небесный on 13.03.2023.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController {

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var collectionOfFiles: [URL] = []
    private let manager = FileManager.default
    private lazy var number = 0



    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
        reloadData()
        setupTableView()
    }

    private func setupSettingsView() {
        self.view.backgroundColor = .systemBackground

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Documents/"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        self.navigationItem.rightBarButtonItem = addButton
    }

    private func reloadData(){
        do {

            let documentsUrl = try self.manager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false
            )
            let files = try self.manager.contentsOfDirectory(at: documentsUrl,
                                                             includingPropertiesForKeys: nil,
                                                             options: [.skipsHiddenFiles]
            )
            self.collectionOfFiles = files
        } catch let error {
            print(error)
        }
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCellID")
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "tabelViewCellID")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc private func addPhoto() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }

    private func addImage(image: UIImage) {
        do {
            let documentsUrl = try self.manager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false
            )
            var imageUrl = documentsUrl.appendingPathComponent("Image_0.jpg")
            repeat {
                let name = "Image_" + String(self.number) + ".jpg"
                imageUrl = documentsUrl.appendingPathComponent(name)
                self.number += 1
            } while self.manager.fileExists(atPath: imageUrl.path)

            let data = image.jpegData(compressionQuality: 1.0)
            self.manager.createFile(atPath: imageUrl.path, contents: data)
            self.reloadData()
            self.tableView.reloadData()
        } catch let error {
            print(error)
        }

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionOfFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCellID", for: indexPath)
        for (index, file) in collectionOfFiles.enumerated() where indexPath[1] == index {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tabelViewCellID", for: indexPath) as? TableViewCell else {
                return defultCell
            }
            guard let data = self.manager.contents(atPath: file.path) else {
                return defultCell
            }
            guard let image = UIImage(data: data) else {
                return defultCell
            }
            cell.setup(with: image)
            return cell
        }
        return defultCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let urlPath = collectionOfFiles[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            do {
                try self.manager.removeItem(atPath: urlPath.path)
                self.reloadData()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error {
                print(error)
            }
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
               configuration.performsFirstActionWithFullSwipe = true
               return configuration
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        for (_, result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] file, error in
                guard error == nil else {
                    return

                }
                guard let image = file as? UIImage, error == nil else {
                    return

                }
                DispatchQueue.main.sync {
                    self?.addImage(image: image)
                }
            }
        }
        picker.dismiss(animated: true)
    }
}


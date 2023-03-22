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

    private let userDefaults = UserDefaults.standard
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var filemanagerService = MyFileManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
        setupTableView()
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification,
                                               object: nil,
                                               queue: nil
        ) { _ in
            self.tableView.reloadData()
        }
    }

    private func setupSettingsView() {
        self.view.backgroundColor = .systemBackground

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Documents/"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        self.navigationItem.rightBarButtonItem = addButton
//        let logOutButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(logOut))
//        self.navigationItem.leftBarButtonItem = logOutButton
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

//    @objc private func logOut() {
//        print("logout")
//    }

    private func addImage(image: UIImage) {
        self.filemanagerService.addImage(image: image)
        self.tableView.reloadData()
    }

    private func sortArray(array: [URL]) -> [URL] {
        var newArray: [URL] = []

        if (self.userDefaults.bool(forKey: KeysForUserDefaults.didChange) &&
            self.userDefaults.bool(forKey: KeysForUserDefaults.sortIsOn)) ||
            self.userDefaults.bool(forKey: KeysForUserDefaults.didChange) == false {

            var stringArray: [String] = []
            for (_, fileUrl) in array.enumerated() {
                let stringUrl = fileUrl.absoluteString
                stringArray.append(stringUrl)
            }
            var sortStringArray: [String] = []

            if self.userDefaults.string(forKey: KeysForUserDefaults.TypeOfSort) == TypeForSortFile.fromAToZ ||
                self.userDefaults.string(forKey: KeysForUserDefaults.TypeOfSort) == nil {
                sortStringArray = stringArray.sorted(by: <)
            } else {
                sortStringArray = stringArray.sorted(by: >)
            }

            for (_, stringUrl) in sortStringArray.enumerated() {
                let fileUrl = URL(string: stringUrl) ?? URL(string: "file:///Users/")!
                newArray.append(fileUrl)
            }
        } else {
            newArray = array
        }
        return newArray
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filemanagerService.collectionOfFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortArray = self.sortArray(array: self.filemanagerService.collectionOfFiles)
        let defultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCellID", for: indexPath)
        for (index, fileUrl) in sortArray.enumerated() where indexPath[1] == index {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tabelViewCellID", for: indexPath) as? TableViewCell else {
                return defultCell
            }
            let fileData = self.filemanagerService.getData(fileUrl: fileUrl.path)

            guard let image = fileData["image"] as? UIImage else {
                return defultCell
            }
            guard let name = fileData["name"] as? String else {
                return defultCell
            }
            guard let creationDateAndTime = fileData["creationDateAndTime"] as? String else {
                return defultCell
            }
            guard let size = fileData["size"] as? String else {
                return defultCell
            }

            cell.setup(with: image, name: name, creationDateAndTime: creationDateAndTime, size: size)
            return cell
        }
        return defultCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let urlPath = self.filemanagerService.collectionOfFiles[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            self.filemanagerService.deleteImage(url: urlPath.path)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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


//
//  ViewController.swift
//  FileManager
//
//  Created by Лёха Небесный on 13.03.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: self.layout
    )
    private lazy var collectionOfFiles: [URL] = []
    private lazy var baseURL: URL? = nil
    private let manager = FileManager.default



    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
        loadData()
        setupLoyoutCollectionView()
        setupCollectionView()
    }

    private func setupSettingsView() {
        self.view.backgroundColor = .systemBackground

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Documents/"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        self.navigationItem.rightBarButtonItem = addButton
    }

    private func loadData(){
        do {

            let documentsUrl = try self.manager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false
            )
            baseURL = documentsUrl

            let files = try self.manager.contentsOfDirectory(at: documentsUrl,
                                                             includingPropertiesForKeys: nil,
                                                             options: [.skipsHiddenFiles]
            )
            collectionOfFiles = files
            //            for file in files {
            ////                let filePath = documentsUrl.appending(path: file)
            ////                        print("🍋 File path: \(filePath)")
            //
            //                print("🍋", manager.contents(atPath: file.path))//, file.path, "OR ", file)
            //                }
        } catch let error {
            print(error)
        }

    }

    private func setupLoyoutCollectionView() {
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
    }

    private func setupCollectionView() {
        //        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCellID")
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCellID")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //        collectionView.showsVerticalScrollIndicator = false

        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    //    private func openPicker() {
    //        let picker = UIPickerView()
    ////        picker.didFinishPicking { [unowned picker] items, _ in
    ////            if let photo = items.singlePhoto {
    ////                print(photo.fromCamera) // Image source (camera or library)
    ////                print(photo.image) // Final image selected by the user
    ////                print(photo.originalImage) // original image selected by the user, unfiltered
    ////                print(photo.modifiedImage) // Transformed image, can be nil
    ////                print(photo.exifMeta) // Print exif meta data of original image.
    ////            }
    ////            picker.dismiss(animated: true, completion: nil)
    ////        }
    //        present(picker, animated: true, completion: nil)
    //    }

    @objc private func addPhoto() {

    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionOfFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCellID", for: indexPath)
        for (index, file) in collectionOfFiles.enumerated() where indexPath.item == index {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellID", for: indexPath) as? CollectionViewCell else {
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

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  self.view.frame.width < self.view.frame.height {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        } else {
            return CGSize(width: self.view.frame.height, height: self.view.frame.height)
        }
    }
}


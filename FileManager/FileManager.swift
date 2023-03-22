//
//  FileManager.swift
//  FileManager
//
//  Created by Лёха Небесный on 17.03.2023.
//

import Foundation
import UIKit

final class MyFileManager {

    lazy var collectionOfFiles: [URL] = []
    private let manager = FileManager.default
    private lazy var number = 0

    init() {
        reloadData()
    }

    private func reloadData() {
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

    func getData(fileUrl: String) -> [String: Any] {
        var fileData = ["image":UIImage(systemName: "photo.fill")!,
                        "name":"Unknow data",
                        "creationDateAndTime":"Unknow data",
                        "size":"Unknow data"
        ] as! [String : Any]
        guard let data = self.manager.contents(atPath: fileUrl) else {
            return fileData
        }
        guard let image = UIImage(data: data) else {
            return fileData
        }
        fileData["image"] = image
        fileData["name"] = self.manager.displayName(atPath: fileUrl)
        do {
            let attributes = try self.manager.attributesOfItem(atPath: fileUrl)
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "YYYY MMMM dd HH:mm"
            let creationDateAndTime: Date = attributes[.creationDate] as? Date ?? Date()
            fileData["creationDateAndTime"] = dateFormater.string(from: creationDateAndTime)
            let size: Int = attributes[.size] as? Int ?? 0
            fileData["size"] = String(size)
        } catch let error {
            print(error)
        }
        return fileData
    }

    func addImage(image: UIImage) {
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
        } catch let error {
            print(error)
        }
    }

    func deleteImage(url: String) {
        do {
            try self.manager.removeItem(atPath: url)
            self.reloadData()
        } catch let error {
            print(error)
        }
    }
}

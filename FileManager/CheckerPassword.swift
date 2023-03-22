//
//  CheckerPassword.swift
//  FileManager
//
//  Created by Лёха Небесный on 22.03.2023.
//

import Locksmith
import UIKit

final class CheckerPassword {

    private var password: String
    var buttonTitle: String
    lazy var changePass: Bool = false

    init(){
        if let dictonary = Locksmith.loadDataForUserAccount(userAccount: Resources.service) {
            self.buttonTitle = Resources.singIn
            self.password = dictonary[Resources.key] as? String ?? ""
        } else {
            self.buttonTitle = Resources.create
            self.password = ""
        }
        print("🔐", self.password)
    }

    func buttonTapped (buttonTitle: String, passwordText: String?) throws -> (String, Bool?) {
        var title = ""
        var openView: Bool? = false
        switch buttonTitle {
        case Resources.singIn:
            if changePass {
                guard let password = passwordText else {
                    throw AlertsMessage.wrongOriginPass
                }
                self.password = password
                title = Resources.change
            } else {
                guard self.password == passwordText else {
                    throw AlertsMessage.wrongOriginPass
                }
                title = Resources.singIn
                openView = true
            }

        case Resources.create:
            guard let password = passwordText else {
                throw AlertsMessage.fewCharacters
              }
            self.password = password
            title = Resources.repeatPass

        case Resources.repeatPass:
            guard self.password == passwordText else {
                self.password = ""
                throw AlertsMessage.wrongNewPass
              }

            do {
                try Locksmith.saveData(data: [Resources.key:self.password], forUserAccount: Resources.service)

                title = Resources.singIn
                openView = true

            } catch let error {
                print(error)
            }

        case Resources.change:
            guard self.password == passwordText else {
                self.password = ""
                throw AlertsMessage.wrongNewPass
              }
            do {
                try Locksmith.updateData(data: [Resources.key:self.password], forUserAccount: Resources.service)

                title = Resources.singIn
                openView = nil
                print("🔐", self.password)

            } catch let error {
                print(error)
            }

        default:
            print("не удалось распознать название")
        }
        return (title, openView)
    }

    func openView() -> UITabBarController {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .secondarySystemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .secondarySystemBackground
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            // Fallback on earlier versions
        }

        let tabBarController = UITabBarController()
        let infoViewController = UINavigationController(rootViewController: InfoViewController())
        let viewController = UINavigationController(rootViewController: ViewController())


        tabBarController.viewControllers = [
            viewController,
            infoViewController
        ]
        viewController.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "externaldrive.fill.badge.person.crop"), tag: 0)
        infoViewController.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)

         return tabBarController
    }
}

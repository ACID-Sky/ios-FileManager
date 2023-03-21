//
//  InfoViewController.swift
//  FileManager
//
//  Created by Лёха Небесный on 20.03.2023.
//

import UIKit

class InfoViewController: UIViewController {

    private let userDefaults = UserDefaults.standard
    private lazy var label = UILabel()
    private lazy var switcher = UISwitch()
    private lazy var checkBox = UIButton()
    private lazy var changePasswordButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userDefaults.string(forKey: KeysForUserDefaults.TypeOfSort) == nil {
            self.userDefaults.setValue(TypeForSortFile.fromAToZ, forKey: KeysForUserDefaults.TypeOfSort)
        }
        self.setupSettingsView()
        self.setupLabel()
        self.setupSwitcher()
        self.setupCheckBox()
        self.setupChangePasswordButton()

        // Do any additional setup after loading the view.
    }

    private func setupSettingsView() {
        self.view.backgroundColor = .systemBackground

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Настройки"
    }

    private func setupLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textColor = .systemBlue
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 14)
        self.label.text = "Сортировка файлов по имени."

        self.view.addSubview(label)

        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }

    private func setupSwitcher() {
        let state: Bool = { if self.userDefaults.bool(forKey: "didChange") == false {
                            return true
                        } else {
                            return self.userDefaults.bool(forKey: "sortIsOn")
                        }
        }()
        
        self.switcher.translatesAutoresizingMaskIntoConstraints = false
        self.switcher.addTarget(self, action: #selector(self.changeSettings), for: .valueChanged)
        self.switcher.setOn(state, animated: true)

        self.view.addSubview(switcher)

        NSLayoutConstraint.activate([
            self.switcher.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 8),
            self.switcher.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
        ])
    }

    private func setupCheckBox() {

        let optionClosure = {(action : UIAction) in
            self.userDefaults.setValue(action.title, forKey: KeysForUserDefaults.TypeOfSort)}

        if self.userDefaults.string(forKey: KeysForUserDefaults.TypeOfSort) == TypeForSortFile.fromZToA {
            self.checkBox.menu = UIMenu(children : [
                UIAction(title : TypeForSortFile.fromZToA, state : .on,handler : optionClosure),
                UIAction(title : TypeForSortFile.fromAToZ, handler : optionClosure),
                    ])
        } else {
            self.checkBox.menu = UIMenu(children : [
                UIAction(title : TypeForSortFile.fromZToA, handler : optionClosure),
                UIAction(title : TypeForSortFile.fromAToZ, state : .on,handler : optionClosure),
                    ])
        }

        self.checkBox.showsMenuAsPrimaryAction = true
        self.checkBox.changesSelectionAsPrimaryAction = true
        self.checkBox.translatesAutoresizingMaskIntoConstraints = false
        self.checkBox.setTitleColor(.purple, for: .normal)
        self.checkBox.layer.cornerRadius = 10
        self.checkBox.layer.borderWidth = 0.5
        self.checkBox.layer.borderColor = UIColor.lightGray.cgColor

        self.view.addSubview(checkBox)

        NSLayoutConstraint.activate([
            self.checkBox.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 8),
            self.checkBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.checkBox.trailingAnchor.constraint(equalTo: self.switcher.leadingAnchor, constant: -8),
        ])
    }

    private func setupChangePasswordButton() {
        self.changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.changePasswordButton.setTitle("Сменить пароль", for: .normal)
        self.changePasswordButton.backgroundColor = .purple
        self.changePasswordButton.layer.cornerRadius = 10
        self.changePasswordButton.layer.borderWidth = 0.5
        self.changePasswordButton.layer.borderColor = UIColor.lightGray.cgColor
        self.changePasswordButton.addTarget(self, action:  #selector(buttonPresed), for: .touchUpInside)

        self.view.addSubview(changePasswordButton)

        NSLayoutConstraint.activate([
            self.changePasswordButton.topAnchor.constraint(equalTo: self.checkBox.bottomAnchor, constant: 8),
            self.changePasswordButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.changePasswordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
        ])
    }

    @objc private func changeSettings() {
        if self.switcher.isOn == true {
            self.checkBox.setTitleColor(.purple, for: .normal)
            self.checkBox.backgroundColor = .systemBackground
            self.checkBox.isUserInteractionEnabled = true
        } else {
            self.checkBox.setTitleColor(.systemBackground, for: .normal)
            self.checkBox.backgroundColor = .systemGray
            self.checkBox.isUserInteractionEnabled = false
        }
        if self.userDefaults.bool(forKey: KeysForUserDefaults.didChange) == false {
            self.userDefaults.set(true, forKey: KeysForUserDefaults.didChange)
        }
        self.userDefaults.setValue(self.switcher.isOn, forKey: KeysForUserDefaults.sortIsOn)
        self.userDefaults.setValue(self.checkBox.titleLabel?.text, forKey: KeysForUserDefaults.TypeOfSort)
    }

    @objc private func buttonPresed() {
        let vc = LoginViewController()
        vc.changePass = true
        let viewController = UINavigationController(rootViewController: vc)
        present(viewController, animated: true)
    }

}




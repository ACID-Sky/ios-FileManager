//
//  LoginViewController.swift
//  FileManager
//
//  Created by Лёха Небесный on 17.03.2023.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {

    private lazy var password = ""
    lazy var changePass: Bool = false

    private lazy var scrollView = UIScrollView()
    private lazy var logoView = UIImageView()
    private lazy var stackView = UIStackView()
    private lazy var passwordTextField = TextFieldWithPadding()
    private lazy var loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupScrollView()
        self.setupLogoView()
        self.setupStackView()
        self.setupGestures()
//        Оставил код для стирания инфы
//        do {
//            try Locksmith.deleteDataForUserAccount(userAccount: Resources.service)
//            print("Удалили")
//        } catch let error {
//            print(error)
//        }
//
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: KeysForUserDefaults.didChange)
//        userDefaults.removeObject(forKey: KeysForUserDefaults.TypeOfSort)
//        userDefaults.removeObject(forKey: KeysForUserDefaults.sortIsOn)
//        print("Удалили")
//        openView()
        self.loadPass()
        print("🔐", password)
    }

    override func viewDidLayoutSubviews() {
        self.offsetOfScrollView()
    }

    private func setupScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupLogoView() {
        self.logoView.translatesAutoresizingMaskIntoConstraints = false
        self.logoView.image = UIImage(systemName: "key.viewfinder")
        self.logoView.clipsToBounds = true
        self.logoView.image?.withTintColor(.systemPurple)

        self.scrollView.addSubview(logoView)

        NSLayoutConstraint.activate([
            self.logoView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            self.logoView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoView.widthAnchor.constraint(equalToConstant: 100),
            self.logoView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func setupStackView() {
        self.stackView.axis = .vertical
        self.stackView.spacing = 16
        self.stackView.clipsToBounds = true
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        self.scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 120),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),
        ])

        self.setupPasswordTextField()
        self.setupLoginButton()
    }

    private func setupPasswordTextField() {
        let borderColor = UIColor.lightGray
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.tag = 0
        self.passwordTextField.backgroundColor = .systemGray6
        self.passwordTextField.textColor = .black
        self.passwordTextField.font = UIFont.systemFont(ofSize: 16)
        self.passwordTextField.autocapitalizationType = .none
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.passwordTextField.delegate = self
        self.passwordTextField.font = passwordTextField.font?.withSize(15)
        self.passwordTextField.layer.borderWidth = 0.5
        self.passwordTextField.layer.borderColor = borderColor.cgColor
        self.passwordTextField.layer.cornerRadius = 10

        self.stackView.addArrangedSubview(passwordTextField)

        NSLayoutConstraint.activate([
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupLoginButton() {
        self.loginButton.setTitle("Login in", for: .normal)
        self.loginButton.tintColor = .white
        self.loginButton.backgroundColor = .systemPurple
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.layer.cornerRadius = 10
        self.loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        self.stackView.addArrangedSubview(loginButton)

        NSLayoutConstraint.activate([
            self.loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func offsetOfScrollView() {
        let loginInButtonBottomPointY = self.stackView.frame.origin.y + self.loginButton.frame.origin.y + self.loginButton.frame.height
        let screenOriginY = self.scrollView.frame.origin.y + self.scrollView.frame.height

        let yOffset = screenOriginY < loginInButtonBottomPointY + 16
        ? loginInButtonBottomPointY - screenOriginY + 16
        : 0

        self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)

    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    private func loadPass() {
        if let dictonary = Locksmith.loadDataForUserAccount(userAccount: Resources.service) {
            self.loginButton.setTitle(Resources.singIn, for: .normal)
            password = dictonary[Resources.key] as? String ?? ""
        } else {
            self.loginButton.setTitle(Resources.create, for: .normal)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func openView() {
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

        self.navigationController?.pushViewController(tabBarController, animated: true)
    }

    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let loginInButtonBottomPointY = self.stackView.frame.origin.y + self.loginButton.frame.origin.y + self.loginButton.frame.height

            let keyboardOriginY = self.scrollView.frame.origin.y + self.scrollView.frame.height - keyboardHeight

            let yOffset = keyboardOriginY < loginInButtonBottomPointY + 16
            ? loginInButtonBottomPointY - keyboardOriginY + 16
            : 0

            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }

    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }

    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.offsetOfScrollView()
    }

    @objc private func buttonTapped () {
        switch self.loginButton.titleLabel?.text {
        case Resources.singIn:
            if changePass {
                guard let password = self.passwordTextField.text, password.count >= 4 else {
                    self.passwordTextField.text = nil
                    let alert = Alerts().showAlert(name: AlertsMessage.wrongOriginPass)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.password = password
                self.passwordTextField.text = nil
                self.loginButton.setTitle(Resources.change, for: .normal)
            } else {
                guard self.password == self.passwordTextField.text, self.password.count > 0 else {
                    self.passwordTextField.text = nil
                    let alert = Alerts().showAlert(name: AlertsMessage.wrongOriginPass)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                openView()
            }

        case Resources.create:
            guard let password = self.passwordTextField.text, password.count >= 4 else {
                self.passwordTextField.text = nil
                let alert = Alerts().showAlert(name: AlertsMessage.fewCharacters)
                self.present(alert, animated: true, completion: nil)
                return
              }
            self.password = password
            self.passwordTextField.text = nil
            self.loginButton.setTitle(Resources.repeatPass, for: .normal)

        case Resources.repeatPass:
            guard self.password == self.passwordTextField.text else {
                self.passwordTextField.text = nil
                self.password = ""
                self.loginButton.setTitle(Resources.create, for: .normal)
                let alert = Alerts().showAlert(name: AlertsMessage.wrongNewPass)
                self.present(alert, animated: true, completion: nil)
                return
              }

            do {
                try Locksmith.saveData(data: [Resources.key:self.password], forUserAccount: Resources.service)

                self.passwordTextField.text = nil
                self.loginButton.setTitle(Resources.singIn, for: .normal)

                openView()

            }catch let error {
                print(error)
            }

        case Resources.change:
            guard self.password == self.passwordTextField.text else {
                self.passwordTextField.text = nil
                self.password = ""
                self.loginButton.setTitle(Resources.singIn, for: .normal)
                let alert = Alerts().showAlert(name: AlertsMessage.wrongNewPass)
                self.present(alert, animated: true, completion: nil)
                return
              }
            do {
                try Locksmith.updateData(data: [Resources.key:self.password], forUserAccount: Resources.service)

                self.passwordTextField.text = nil
                self.loginButton.setTitle(Resources.singIn, for: .normal)
                print("🔐", self.password)

                dismiss(animated: true)

            }catch let error {
                print(error)
            }

        default:
            print("не удалось распознать название")
        }

    }

}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.forcedHidingKeyboard()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldDidChangeSelection(_ textField: UITextField) {

    }

}

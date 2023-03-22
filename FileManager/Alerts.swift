//
//  Alerts.swift
//  FileManager
//
//  Created by Лёха Небесный on 20.03.2023.
//

import Foundation
import UIKit

struct Alerts {

    func showAlert(name: AlertsMessage) -> UIAlertController {

        var title = ""
        var message = ""

        switch name {
        case .fewCharacters:
            title = "Мало символов!"
            message = "Пароль должен быть не короче 4-х символов"
        case .wrongNewPass:
            title = "Введен неверный пароль."
            message = "При повторе пароля Вы ввели другой пароль. Попробуйте сначала!"
        case .wrongOriginPass:
            title = "Не верный пароль!"
            message = "Введенный пароль не соответствует сохраненному! Попробуйте снова"
        case _:
            title = "Ошибка."
            message = "Упс, что-то пошло не так"
        }

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert
        )



        let yesAction = UIAlertAction(title: "Ok", style: .default)

        alert.addAction(yesAction)

        return alert
    }
}

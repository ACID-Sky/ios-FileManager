//
//  Resources.swift
//  FileManager
//
//  Created by Лёха Небесный on 20.03.2023.
//

import Foundation

enum Resources {
    static let create = "Создать пароль"
    static let repeatPass = "Повторите пароль"
    static let singIn = "Введите пароль"
    static let change = "Сохранить"

    static let service = "UserAccount"
    static let key = "password"

}

enum KeysForUserDefaults {
    static let didChange = "didChange"
    static let sortIsOn = "sortIsOn"
    static let TypeOfSort = "TypeOfSort"
}

enum TypeForSortFile {
    static let fromAToZ = "Сортировка от А до Я"
    static let fromZToA = "Сортировка от Я до А"
}

enum AlertsMessage {
    case fewCharacters
    case wrongOriginPass
    case wrongNewPass

}

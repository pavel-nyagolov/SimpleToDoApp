//
//  FactoryStorage.swift
//  SimpleToDoApp
//
//  Created by Pavel on 10.03.23.
//

import Foundation
import RealmSwift

class FactoryStorage {
    static let realm = try! Realm(configuration: realmConfig)
    
    static var realmConfig: Realm.Configuration {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = 1
        return config
    }
    
    static func addList(_ list: ListModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.add(list)
        try? FactoryStorage.realm.commitWrite()
        NotificationCenter.default.post(name: .updateListNotification, object: nil)
    }
    
    static func addTask(_ list: ListModel, task: TaskModel) {
        try! FactoryStorage.realm.write {
            list.tasks.append(task)
        }
        NotificationCenter.default.post(name: .updateTaskNotification, object: nil)
    }
    
    static func deleteList(_ list: ListModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.delete(list)
        try? FactoryStorage.realm.commitWrite()
    }
    
    static func deleteTask(_ task: TaskModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.delete(task)
        try? FactoryStorage.realm.commitWrite()
    }
    
    static func getLists() -> [ListModel]? {
        return Array(FactoryStorage.realm.objects(ListModel.self).sorted(byKeyPath: "id", ascending: true))
    }
    
    static func getList(id: ObjectId) -> ListModel? {
        return FactoryStorage.realm.objects(ListModel.self).first(where: {$0.id == id})
    }
}

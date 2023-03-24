//
//  List.swift
//  SimpleToDoApp
//
//  Created by Pavel on 10.03.23.
//

import Foundation
import RealmSwift

class ListModel: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var tasks: List<TaskModel>
}

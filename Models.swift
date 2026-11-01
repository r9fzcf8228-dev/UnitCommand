import Foundation
import SwiftData

@Model
final class Soldier {
    var id: UUID
    var name: String
    var rank: String
    var militaryNumber: String
    var status: String
    var duties: [Duty] = []
    var missions: [Mission] = []

    init(name: String, rank: String, militaryNumber: String, status: String = "حاضر") {
        self.id = UUID()
        self.name = name
        self.rank = rank
        self.militaryNumber = militaryNumber
        self.status = status
    }
}

@Model
final class Duty {
    var id: UUID
    var date: Date
    var type: String
    var soldier: Soldier?

    init(date: Date, type: String, soldier: Soldier? = nil) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.soldier = soldier
    }
}

@Model
final class Mission {
    var id: UUID
    var title: String
    var assignedTo: Soldier?
    var dueDate: Date
    var isCompleted: Bool
    var notes: String

    init(title: String, assignedTo: Soldier? = nil, dueDate: Date = Date(), notes: String = "") {
        self.id = UUID()
        self.title = title
        self.assignedTo = assignedTo
        self.dueDate = dueDate
        self.isCompleted = false
        self.notes = notes
    }
}

import Foundation
import SwiftData

@Model
final class Soldier {
    var id: UUID
    var name: String
    var rank: String
    var militaryNumber: String
    var status: String
    var bloodType: String
    var medicalNotes: String
    
    init(name: String, rank: String, militaryNumber: String, status: String = "حاضر", bloodType: String = "غير محدد", medicalNotes: String = "") {
        self.id = UUID()
        self.name = name
        self.rank = rank
        self.militaryNumber = militaryNumber
        self.status = status
        self.bloodType = bloodType
        self.medicalNotes = medicalNotes
    }
}

@Model
final class Duty {
    var id: UUID
    var date: Date
    var type: String
    var soldier: Soldier?
    init(date: Date, type: String, soldier: Soldier? = nil) {
        self.id = UUID(); self.date = date; self.type = type; self.soldier = soldier
    }
}

@Model
final class Mission {
    var id: UUID
    var title: String
    var assignedTo: Soldier?
    var dueDate: Date
    var isCompleted: Bool
    init(title: String, assignedTo: Soldier? = nil, dueDate: Date = Date()) {
        self.id = UUID(); self.title = title; self.assignedTo = assignedTo; self.dueDate = dueDate; self.isCompleted = false
    }
}

@Model
final class Weapon {
    var id: UUID
    var name: String
    var serialNumber: String
    var status: String
    var assignedTo: Soldier?
    init(name: String, serialNumber: String, status: String = "جاهز", assignedTo: Soldier? = nil) {
        self.id = UUID(); self.name = name; self.serialNumber = serialNumber; self.status = status; self.assignedTo = assignedTo
    }
}

// جديد: الذخيرة
@Model
final class Ammo {
    var id: UUID
    var type: String // عيار 5.56، 7.62...
    var quantity: Int
    init(type: String, quantity: Int) {
        self.id = UUID(); self.type = type; self.quantity = quantity
    }
}

// جديد: الآليات
@Model
final class Vehicle {
    var id: UUID
    var name: String // هامفي، نيسان...
    var plateNumber: String
    var status: String // جاهزة، صيانة، خارج الخدمة
    init(name: String, plateNumber: String, status: String = "جاهزة") {
        self.id = UUID(); self.name = name; self.plateNumber = plateNumber; self.status = status
    }
}

// جديد: السجل اليومي
@Model
final class DailyLog {
    var id: UUID
    var date: Date
    var content: String
    init(date: Date = Date(), content: String) {
        self.id = UUID(); self.date = date; self.content = content
    }
}

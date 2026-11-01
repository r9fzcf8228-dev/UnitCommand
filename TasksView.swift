import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Mission.dueDate) private var missions: [Mission]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(missions) { mission in
                    HStack {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(mission.title)
                                .strikethrough(mission.isCompleted)
                            Text("مسند إلى: \(mission.assignedTo?.name ?? "غير محدد")")
                                .font(.caption)
                            Text(mission.dueDate, style: .date).font(.caption2)
                        }
                        Spacer()
                        Button {
                            mission.isCompleted.toggle()
                        } label: {
                            Image(systemName: mission.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(mission.isCompleted ? .green : .gray)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("المهام")
            .toolbar {
                Button("إضافة", systemImage: "plus") { showingAdd = true }
            }
            .sheet(isPresented: $showingAdd) {
                AddMissionView()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { context.delete(missions[index]) }
    }
}

struct AddMissionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var soldiers: [Soldier]
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var selectedSoldier: Soldier?

    var body: some View {
        NavigationStack {
            Form {
                TextField("عنوان المهمة", text: $title)
                TextField("ملاحظات", text: $notes)
                DatePicker("تاريخ الإنجاز", selection: $dueDate, displayedComponents: .date)
                Picker("الفرد", selection: $selectedSoldier) {
                    Text("بدون").tag(Soldier?.none)
                    ForEach(soldiers) { s in
                        Text(s.name).tag(Optional(s))
                    }
                }
            }
            .navigationTitle("مهمة جديدة")
            .toolbar {
                Button("حفظ") {
                    let mission = Mission(title: title, assignedTo: selectedSoldier, dueDate: dueDate, notes: notes)
                    context.insert(mission)
                    dismiss()
                }
                .disabled(title.isEmpty)
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

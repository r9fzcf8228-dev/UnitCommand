import SwiftUI
import SwiftData

struct RosterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Soldier.name) private var soldiers: [Soldier]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(soldiers) { soldier in
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(soldier.name).font(.headline)
                        HStack {
                            Text(soldier.rank)
                            Text("•")
                            Text(soldier.militaryNumber)
                            Spacer()
                            Text(soldier.status)
                                .font(.caption)
                                .padding(4)
                                .background(statusColor(soldier.status).opacity(0.2))
                                .cornerRadius(4)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("سجل الأفراد")
            .toolbar {
                Button("إضافة", systemImage: "plus") { showingAdd = true }
            }
            .sheet(isPresented: $showingAdd) {
                AddSoldierView()
            }
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "حاضر": return .green
        case "غائب": return .orange
        case "مريض": return .red
        default: return .gray
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { context.delete(soldiers[index]) }
    }
}

struct AddSoldierView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var rank = "جندي"
    @State private var number = ""
    @State private var status = "حاضر"

    let ranks = ["جندي", "جندي أول", "نائب عريف", "عريف", "رئيس عرفاء", "ملازم", "ملازم أول", "نقيب", "رائد", "مقدم", "عقيد"]
    let statuses = ["حاضر", "غائب", "مريض", "دورة"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("الاسم الكامل", text: $name)
                TextField("الرقم الاحصائي", text: $number)
                Picker("الرتبة", selection: $rank) {
                    ForEach(ranks, id: \.self) { Text($0) }
                }
                Picker("الحالة", selection: $status) {
                    ForEach(statuses, id: \.self) { Text($0) }
                }
            }
            .navigationTitle("فرد جديد")
            .toolbar {
                Button("حفظ") {
                    let soldier = Soldier(name: name, rank: rank, militaryNumber: number, status: status)
                    context.insert(soldier)
                    dismiss()
                }
                .disabled(name.isEmpty || number.isEmpty)
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

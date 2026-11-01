import SwiftUI
import SwiftData

struct DutyRosterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Duty.date) private var duties: [Duty]
    @Query private var soldiers: [Soldier]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(duties) { duty in
                    VStack(alignment: .trailing, spacing: 6) {
                        Text(duty.type).font(.headline)
                        Text(duty.date, style: .date)
                        Text(duty.soldier?.name ?? "غير معين")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("مأموريات")
            .toolbar {
                Button("إضافة", systemImage: "plus") { showingAdd = true }
            }
            .sheet(isPresented: $showingAdd) {
                AddDutyView()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { context.delete(duties[index]) }
    }
}

struct AddDutyView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var soldiers: [Soldier]
    @State private var date = Date()
    @State private var type = "مأمورية"
    @State private var selectedSoldier: Soldier?

    let types = ["مأمورية", "حرس", "واجب", "دورية"]

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("التاريخ", selection: $date, displayedComponents: .date)
                Picker("النوع", selection: $type) {
                    ForEach(types, id: \.self) { Text($0) }
                }
                Picker("الفرد", selection: $selectedSoldier) {
                    Text("بدون").tag(Soldier?.none)
                    ForEach(soldiers) { s in
                        Text(s.name).tag(Optional(s))
                    }
                }
            }
            .navigationTitle("واجب جديدة")
            .toolbar {
                Button("حفظ") {
                    let duty = Duty(date: date, type: type, soldier: selectedSoldier)
                    context.insert(duty)
                    dismiss()
                }
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

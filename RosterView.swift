import SwiftUI
import SwiftData

struct RosterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Soldier.name) private var soldiers: [Soldier]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                List {
                    ForEach(soldiers) { soldier in
                        HStack(spacing: 15) {
                            Circle()
                                .fill(statusColor(soldier.status).gradient)
                                .frame(width: 15, height: 15)
                                .shadow(color: statusColor(soldier.status).opacity(0.5), radius: 5, x: 0, y: 0)
                            
                            VStack(alignment: .trailing, spacing: 6) {
                                Text(soldier.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Text(soldier.rank)
                                    Text("•")
                                    Text(soldier.militaryNumber)
                                    Spacer()
                                    Text(soldier.status)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(statusColor(soldier.status).opacity(0.2))
                                        .foregroundColor(statusColor(soldier.status))
                                        .cornerRadius(10)
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 10)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: soldiers)
            }
            .navigationTitle("سجل الأفراد")
            .toolbar {
                Button {
                    showingAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddSoldierView()
            }
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "حاضر": return .green
        case "مأذونية": return .orange
        case "مريض": return .red
        case "دورة": return .blue
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
    let statuses = ["حاضر", "مأذونية", "مريض", "دورة"]

    var body: some View {
        NavigationStack {
            Form {
                Section("المعلومات الأساسية") {
                    TextField("الاسم الكامل", text: $name)
                    TextField("الرقم العسكري", text: $number)
                }
                
                Section("الرتبة والحالة") {
                    Picker("الرتبة", selection: $rank) {
                        ForEach(ranks, id: \.self) { Text($0) }
                    }
                    Picker("الحالة", selection: $status) {
                        ForEach(statuses, id: \.self) { Text($0) }
                    }
                }
            }
            .navigationTitle("فرد جديد")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("حفظ") {
                        let soldier = Soldier(name: name, rank: rank, militaryNumber: number, status: status)
                        context.insert(soldier)
                        dismiss()
                    }
                    .disabled(name.isEmpty || number.isEmpty)
                    .bold()
                }
            }
        }
    }
}

import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Mission.dueDate) private var missions: [Mission]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                List {
                    ForEach(missions) { mission in
                        HStack {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(mission.title)
                                    .font(.headline)
                                    .strikethrough(mission.isCompleted)
                                Text("مسند إلى: \(mission.assignedTo?.name ?? "غير محدد")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(mission.dueDate, style: .date).font(.caption2)
                            }
                            Spacer()
                            Button {
                                withAnimation {
                                    mission.isCompleted.toggle()
                                }
                            } label: {
                                Image(systemName: mission.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(mission.isCompleted ? .green : .gray)
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
            }
            .navigationTitle("المهام")
            .toolbar {
                Button { showingAdd = true } label: {
                    Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.green)
                }
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
    @State private var dueDate = Date()
    @State private var selectedSoldier: Soldier?

    var body: some View {
        NavigationStack {
            Form {
                TextField("عنوان المهمة", text: $title)
                DatePicker("تاريخ الإنجاز", selection: $dueDate, displayedComponents: .date)
                Picker("الفرد", selection: $selectedSoldier) {
                    Text("بدون").tag(Soldier?.none)
                    ForEach(soldiers) { s in
                        Text(s.name).tag(Optional(s))
                    }
                }
            }
            .navigationTitle("مهمة جديدة")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("حفظ") {
                        // هنا قمنا بحذف كلمة notes لكي تتطابق مع قاعدة البيانات
                        let mission = Mission(title: title, assignedTo: selectedSoldier, dueDate: dueDate)
                        context.insert(mission)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .bold()
                }
            }
        }
    }
}

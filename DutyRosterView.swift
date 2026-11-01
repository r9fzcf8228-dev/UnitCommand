import SwiftUI
import SwiftData

struct DutyRosterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Duty.date) private var duties: [Duty]
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
            .navigationTitle("واجبات")
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
    @State private var type = "واجبات"
    @State private var selectedSoldier: Soldier?
    
    // متغير جديد لحفظ النوع المخصص الذي يكتبه المستخدم
    @State private var customType = ""

    // أضفنا خيار "أخرى" إلى القائمة
    let types = ["واجب", "حرس", "واجب", "دورية", "أخرى"]

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("التاريخ", selection: $date, displayedComponents: .date)
                
                Picker("النوع", selection: $type) {
                    ForEach(types, id: \.self) { Text($0) }
                }
                
                // إذا اختار المستخدم "أخرى"، يظهر مربع الكتابة
                if type == "أخرى" {
                    TextField("اكتب نوع الواجب هنا...", text: $customType)
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
                    // إذا كان الخيار "أخرى"، نأخذ النص المكتوب، وإلا نأخذ النوع المختار من القائمة
                    let finalType = type == "أخرى" ? (customType.isEmpty ? "غير محدد" : customType) : type
                    
                    let duty = Duty(date: date, type: finalType, soldier: selectedSoldier)
                    context.insert(duty)
                    dismiss()
                }
                // يمنع الحفظ إذا اختار "أخرى" ولم يكتب شيئاً
                .disabled(type == "أخرى" && customType.isEmpty)
                
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

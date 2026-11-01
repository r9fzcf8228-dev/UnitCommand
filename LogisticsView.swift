import SwiftUI
import SwiftData

struct LogisticsView: View {
    @State private var selectedSegment = 0
    let segments = ["الأسلحة", "الذخيرة", "الآليات"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { Text(segments[$0]) }
                }
                .pickerStyle(.segmented)
                .padding()
                
                TabView(selection: $selectedSegment) {
                    WeaponsListView().tag(0)
                    AmmoListView().tag(1)
                    VehiclesListView().tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: selectedSegment)
            }
            .navigationTitle("اللوجستيات")
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
    }
}

// الأسلحة
struct WeaponsListView: View {
    @Environment(\.modelContext) private var context
    @Query private var weapons: [Weapon]
    @State private var showAdd = false
    
    var body: some View {
        List {
            ForEach(weapons) { w in
                VStack(alignment: .trailing) {
                    Text(w.name).font(.headline)
                    Text("تسلسلي: \(w.serialNumber) • \(w.status)").font(.caption).foregroundColor(.secondary)
                }
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                .listRowSeparator(.hidden)
            }
            .onDelete { for i in $0 { context.delete(weapons[i]) } }
        }
        .listStyle(.plain)
        .overlay(alignment: .bottomTrailing) {
            Button { showAdd = true } label: {
                Image(systemName: "plus.circle.fill").font(.system(size: 50)).foregroundColor(.blue).padding()
            }
        }
        .sheet(isPresented: $showAdd) { AddWeaponView() }
    }
}

struct AddWeaponView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var serial = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("اسم السلاح", text: $name)
                TextField("الرقم التسلسلي", text: $serial)
            }
            .navigationTitle("سلاح جديد")
            .toolbar {
                Button("حفظ") {
                    context.insert(Weapon(name: name, serialNumber: serial))
                    dismiss()
                }.disabled(name.isEmpty)
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

// الذخيرة
struct AmmoListView: View {
    @Environment(\.modelContext) private var context
    @Query private var ammos: [Ammo]
    @State private var showAdd = false
    
    var body: some View {
        List {
            ForEach(ammos) { a in
                HStack {
                    Image(systemName: "burst.fill").foregroundColor(.orange)
                    Text(a.type).font(.headline)
                    Spacer()
                    Text("\(a.quantity) طلقة").badgeStyle(color: .orange)
                }
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                .listRowSeparator(.hidden)
            }
            .onDelete { for i in $0 { context.delete(ammos[i]) } }
        }
        .listStyle(.plain)
        .overlay(alignment: .bottomTrailing) {
            Button { showAdd = true } label: {
                Image(systemName: "plus.circle.fill").font(.system(size: 50)).foregroundColor(.orange).padding()
            }
        }
        .sheet(isPresented: $showAdd) { AddAmmoView() }
    }
}

struct AddAmmoView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var type = ""
    @State private var qty = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("نوع الذخيرة (عيار)", text: $type)
                TextField("الكمية", text: $qty).keyboardType(.numberPad)
            }
            .navigationTitle("ذخيرة جديدة")
            .toolbar {
                Button("حفظ") {
                    if let q = Int(qty) { context.insert(Ammo(type: type, quantity: q)) }
                    dismiss()
                }.disabled(type.isEmpty || qty.isEmpty)
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

// الآليات
struct VehiclesListView: View {
    @Environment(\.modelContext) private var context
    @Query private var vehicles: [Vehicle]
    @State private var showAdd = false
    
    var body: some View {
        List {
            ForEach(vehicles) { v in
                HStack {
                    Image(systemName: "car.fill").foregroundColor(.purple)
                    VStack(alignment: .trailing) {
                        Text(v.name).font(.headline)
                        Text(v.plateNumber).font(.caption)
                    }
                    Spacer()
                    Text(v.status).badgeStyle(color: v.status == "جاهزة" ? .green : .red)
                }
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                .listRowSeparator(.hidden)
            }
            .onDelete { for i in $0 { context.delete(vehicles[i]) } }
        }
        .listStyle(.plain)
        .overlay(alignment: .bottomTrailing) {
            Button { showAdd = true } label: {
                Image(systemName: "plus.circle.fill").font(.system(size: 50)).foregroundColor(.purple).padding()
            }
        }
        .sheet(isPresented: $showAdd) { AddVehicleView() }
    }
}

struct AddVehicleView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var plate = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("نوع الآلية", text: $name)
                TextField("رقم اللوحة/العجلة", text: $plate)
            }
            .navigationTitle("آلية جديدة")
            .toolbar {
                Button("حفظ") {
                    context.insert(Vehicle(name: name, plateNumber: plate))
                    dismiss()
                }.disabled(name.isEmpty)
                Button("إلغاء") { dismiss() }
            }
        }
    }
}

// تنسيق صغير للحالة
extension View {
    func badgeStyle(color: Color) -> some View {
        self.font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

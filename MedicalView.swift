import SwiftUI
import SwiftData

struct MedicalView: View {
    @Query(sort: \Soldier.name) private var soldiers: [Soldier]
    @State private var selectedSoldier: Soldier?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.08, blue: 0.05).ignoresSafeArea()
                
                if soldiers.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "staroflife.fill").font(.system(size: 60)).foregroundColor(.red.opacity(0.5))
                        Text("لا يوجد أفراد مسجلين").font(.headline).foregroundColor(.gray)
                        Text("أضف أفراداً من شاشة (الأفراد) أولاً").font(.caption).foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(soldiers) { soldier in
                            VStack(alignment: .trailing, spacing: 8) {
                                HStack {
                                    Image(systemName: "staroflife.fill").foregroundColor(.red)
                                    Text(soldier.name).font(.headline).foregroundColor(.white)
                                    Spacer()
                                    Text(soldier.bloodType).font(.system(size: 14, weight: .bold))
                                        .padding(.horizontal, 10).padding(.vertical, 4)
                                        .background(Color.red.opacity(0.2)).foregroundColor(.red).cornerRadius(8)
                                }
                                
                                if !soldier.medicalNotes.isEmpty {
                                    Text(soldier.medicalNotes).font(.subheadline).foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    // تم تفتيح اللون هنا
                                    Text("لا توجد ملاحظات طبية").font(.caption).foregroundColor(.gray.opacity(0.8))
                                }
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color(red: 0.1, green: 0.15, blue: 0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green.opacity(0.3), lineWidth: 1))
                            )
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                selectedSoldier = soldier
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("السجل الطبي").toolbarColorScheme(.dark, for: .navigationBar)
            // هذا هو التعديل الأهم لضمان ظهور الشاشة
            .sheet(item: $selectedSoldier) { soldier in
                EditMedicalView(soldier: soldier)
            }
        }
    }
}

struct EditMedicalView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var soldier: Soldier
    @State private var bloodType: String = ""
    @State private var notes: String = ""
    let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "غير محدد"]

    var body: some View {
        NavigationStack {
            Form {
                Section("بيانات الجندي") {
                    Text(soldier.name).font(.headline)
                    Text(soldier.rank).font(.subheadline)
                }
                Section("البيانات الطبية") {
                    Picker("زمرة الدم", selection: $bloodType) { 
                        ForEach(bloodTypes, id: \.self) { Text($0) } 
                    }
                    TextField("ملاحظات (حساسية...)", text: $notes, axis: .vertical).lineLimit(3...6)
                }
            }
            .navigationTitle("تعديل السجل").navigationBarTitleDisplayMode(.inline)
            .onAppear { 
                bloodType = soldier.bloodType
                notes = soldier.medicalNotes 
            }
            .toolbar {
                Button("حفظ") {
                    soldier.bloodType = bloodType
                    soldier.medicalNotes = notes
                    dismiss()
                }.bold()
            }
        }
    }
}

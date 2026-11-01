import SwiftUI
import SwiftData

struct MedicalView: View {
    @Query(sort: \Soldier.name) private var soldiers: [Soldier]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                List {
                    ForEach(soldiers) { soldier in
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack {
                                Image(systemName: "cross.case.fill")
                                    .foregroundColor(.red)
                                Text(soldier.name).font(.headline)
                                Spacer()
                                Text(soldier.bloodType)
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            if !soldier.medicalNotes.isEmpty {
                                Text(soldier.medicalNotes)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            } else {
                                Text("لا توجد ملاحظات طبية")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("السجل الطبي")
        }
    }
}

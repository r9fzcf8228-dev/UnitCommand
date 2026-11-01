import SwiftUI
import SwiftData

struct OperationsView: View {
    @State private var selectedSegment = 0
    let segments = ["المناوبات", "المهام", "السجل اليومي"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { Text(segments[$0]) }
                }
                .pickerStyle(.segmented)
                .padding()
                
                TabView(selection: $selectedSegment) {
                    DutyRosterView().tag(0)
                    TasksView().tag(1)
                    DailyLogView().tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: selectedSegment)
            }
            .navigationTitle("العمليات")
        }
    }
}

// السجل اليومي الجديد
struct DailyLogView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DailyLog.date, order: .reverse) private var logs: [DailyLog]
    @State private var showAdd = false
    @State private var newLogText = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(logs) { log in
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(log.date, style: .date).font(.caption).foregroundColor(.gray)
                        Text(log.content).font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                    .listRowSeparator(.hidden)
                }
                .onDelete { for i in $0 { context.delete(logs[i]) } }
            }
            .listStyle(.plain)
            
            // شريط كتابة سريع
            HStack {
                TextField("تدوين حدث جديد...", text: $newLogText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    if !newLogText.isEmpty {
                        context.insert(DailyLog(content: newLogText))
                        newLogText = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill").padding(10).background(Color.green).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

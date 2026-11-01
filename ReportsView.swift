import SwiftUI
import SwiftData
import UIKit

struct ReportsView: View {
    @Query private var soldiers: [Soldier]
    @Query private var duties: [Duty]
    @Query private var missions: [Mission]

    var body: some View {
        NavigationStack {
            Form {
                Section("ملخص الوحدة") {
                    Text("عدد الأفراد: \(soldiers.count)")
                    Text("الحاضرون: \(soldiers.filter { $0.status == "حاضر" }.count)")
                    Text("الواجبات المسجلة: \(duties.count)")
                    Text("المهام غير المنجزة: \(missions.filter { !$0.isCompleted }.count)")
                }

                Section {
                    Button("توليد تقرير PDF") {
                        generatePDF()
                    }
                }
            }
            .navigationTitle("التقارير")
        }
    }

    private func generatePDF() {
        let content = """
        تقرير الوحدة
        ------------
        عدد الأفراد: \(soldiers.count)
        الحاضرون: \(soldiers.filter { $0.status == "حاضر" }.count)
        غائب: \(soldiers.filter { $0.status == "غائب" }.count)
        المرضى: \(soldiers.filter { $0.status == "مريض" }.count)
        إجمالي الواجبات: \(duties.count)
        المهام المعلقة: \(missions.filter { !$0.isCompleted }.count)
        """

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            content.draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ])
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("تقرير_الوحدة.pdf")
        try? data.write(to: tempURL)

        let activity = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            root.present(activity, animated: true)
        }
    }
}

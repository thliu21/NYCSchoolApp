import SwiftUI

struct SchoolSingleScoreNAView: View {
    let title: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack() {
                Text(title)
                Spacer()
                Text("(Unavailable)")
                    .foregroundColor(.gray)
            }
            ProgressBarView(progress: 0, color: color)
        }
    }
}

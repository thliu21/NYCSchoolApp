import SwiftUI

/// If I got more time, this will be merged into SchoolSingleScoreDetailView
/// to make it cleaner.
struct SchoolSingleScoreNAView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack() {
                Text(title)
                Spacer()
                Text("(Unavailable)")
                    .foregroundColor(.gray)
            }
        }
    }
}

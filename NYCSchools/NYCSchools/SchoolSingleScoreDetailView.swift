import SwiftUI

struct SchoolSingleScoreDetailView: View {
    let title: String
    let score: Int
    let totalScore: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack() {
                Text(title)
                Spacer()
                HStack(spacing: 0) {
                    Text("\(score)")
                        .bold()
                    Text("/\(totalScore)")
                }
            }
            ProgressBarView(value: CGFloat(score) / CGFloat(totalScore), color: color)
        }
    }
}

struct SchoolSingleScoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolSingleScoreDetailView(title: "Critical Reading", score: 678, totalScore: 800, color: .blue)
    }
}

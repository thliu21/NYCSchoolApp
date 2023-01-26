import SwiftUI

struct SchoolSingleScoreDetailView: View {
    let title: String
    let score: Int
    let totalScore: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                Text(title)
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    Text("\(score)")
                        .font(.system(.title2))
                        .bold()
                    Text("/\(totalScore)")
                }
            }
            ProgressBarView(progress: CGFloat(score) / CGFloat(totalScore), color: color)
        }
    }
}

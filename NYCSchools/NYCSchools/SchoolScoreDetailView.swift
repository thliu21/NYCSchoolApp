import SwiftUI

struct SchoolScoreDetailView: View {
    let scoreInfo: SchoolSATScoreInfo
    private static let totalScore = 800
    private static let colors: [Color] = [.blue, .pink, .green]
    private static let subjects: [String] = ["Critical Reading", "Math", "Writing"]
    
    var body: some View {
        /// There should be a cleaner way to make this DRY, but considering there's only three
        /// subjects, doing that feels a bit over-engineering.
        /// Also, it seems that if one score is missing, other two are also likely to be
        /// missing. However there's no document indicating that's always the case.
        if let criticalReadingScoreStr = scoreInfo.criticalReadingScore,
           let criticalReadingScore = Int(criticalReadingScoreStr) {
            SchoolSingleScoreDetailView(
                title: Self.subjects[0], score: criticalReadingScore, totalScore: Self.totalScore, color: Self.colors[0]
            )
            .padding(4.0)
        } else {
            SchoolSingleScoreNAView(title: Self.subjects[0])
        }
        if let mathScoreStr = scoreInfo.mathScore,
           let mathScore = Int(mathScoreStr) {
            SchoolSingleScoreDetailView(
                title: Self.subjects[1], score: mathScore, totalScore: Self.totalScore, color: Self.colors[1]
            )
            .padding(4.0)
        } else {
            SchoolSingleScoreNAView(title: Self.subjects[1])
        }
        if let writingScoreStr = scoreInfo.writingScore,
           let writingScore = Int(writingScoreStr) {
            SchoolSingleScoreDetailView(
                title: Self.subjects[2], score: writingScore, totalScore: Self.totalScore, color: Self.colors[2]
            )
            .padding(4.0)
        } else {
            SchoolSingleScoreNAView(title: Self.subjects[2])
        }
    }
}


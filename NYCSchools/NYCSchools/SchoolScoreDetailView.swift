//
//  SchoolScoreDetailView.swift
//  NYCSchools
//
//  Created by Arthur Liu on 1/25/23.
//

import SwiftUI

struct SchoolScoreDetailView: View {
    let scoreInfo: SchoolSATScoreInfo
    private static let totalScore = 800
    private static let colors: [Color] = [.blue, .pink, .green]
    private static let subjects: [String] = ["Critical Reading", "Math", "Writing"]
    
    var body: some View {
        if let criticalReadingScoreStr = scoreInfo.criticalReadingScore,
           let criticalReadingScore = Int(criticalReadingScoreStr) {
            SchoolSingleScoreDetailView(
                title: Self.subjects[0], score: criticalReadingScore, totalScore: Self.totalScore, color: Self.colors[0]
            )
            .padding(4.0)
        } else {
            SchoolSingleScoreNAView(title: Self.subjects[0], color: Self.colors[0])
        }
        if let mathScoreStr = scoreInfo.mathScore,
           let mathScore = Int(mathScoreStr) {
            SchoolSingleScoreDetailView(
                title: Self.subjects[1], score: mathScore, totalScore: Self.totalScore, color: Self.colors[1]
            )
            .padding(4.0)
        } else {
            SchoolSingleScoreNAView(title: Self.subjects[1], color: Self.colors[1])
        }
        if let writingScoreStr = scoreInfo.writingScore,
           let writingScore = Int(writingScoreStr) {
            SchoolSingleScoreDetailView(
                title: Self.subjects[2], score: writingScore, totalScore: Self.totalScore, color: Self.colors[2]
            )
            .padding(4.0)
        } else {
            SchoolSingleScoreNAView(title: Self.subjects[2], color: Self.colors[2])
        }
    }
}

struct SchoolScoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolScoreDetailView(scoreInfo: .init(dbn: "123", criticalReadingScore: "678", mathScore: "555", writingScore: "444"))
    }
}

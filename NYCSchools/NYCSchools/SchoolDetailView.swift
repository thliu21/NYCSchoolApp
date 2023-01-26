import SwiftUI
import MapKit

struct SchoolDetailView: View {
    static private let fullScore = 800
    
    var schoolInfo: SchoolInfo
    
    @StateObject private var vm: SchoolSATScoreViewModel
    @State private var region: MKCoordinateRegion?
    
    var body: some View {
        List {
            Section("Basics") {
                SchoolDetailBasicView(schoolInfo: schoolInfo)
            }
            Section("SAT Score 2012") {
                switch vm.loadingState {
                case .loaded(let scores):
                    SchoolScoreDetailView(scoreInfo: scores)
                case .failed:
                    Text("Score data unavailable :(")
                        .foregroundColor(.gray)
                case .notStarted, .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            Section("Map") {
                SchoolDetailMapView(schoolInfo: schoolInfo)
            }
        }
        .navigationTitle("\(schoolInfo.schoolName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.loadSatScore()
        }
    }
    
    init(schoolInfo: SchoolInfo) {
        self.schoolInfo = schoolInfo
        _vm = StateObject(wrappedValue: SchoolSATScoreViewModel(dbn: schoolInfo.dbn))
    }
}

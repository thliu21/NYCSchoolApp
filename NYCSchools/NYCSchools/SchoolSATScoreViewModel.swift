import Foundation
import Combine

class SchoolSATScoreViewModel: ObservableObject {
    enum LoadingState {
        case notStarted
        case loading
        case loaded(SchoolSATScoreInfo)
        case failed
    }
    
    @Published var loadingState: LoadingState = .notStarted
    
    private var cancellables = Set<AnyCancellable>()
    
    private let dbn: String
    
    func loadSATScore() {
        switch loadingState {
        case .notStarted:
            self.loadingState = .loading
            NYCOpenDatabaseAPI.fetchSchoolSATScore(dbn: dbn)
                .receive(on: RunLoop.main)
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self.loadingState = .failed
                    }
                } receiveValue: { info in
                    self.loadingState = .loaded(info)
                }
                .store(in: &cancellables)
        case .loading, .loaded(_), .failed:
            break
        }
    }
    
    init(dbn: String) {
        self.dbn = dbn
    }
}

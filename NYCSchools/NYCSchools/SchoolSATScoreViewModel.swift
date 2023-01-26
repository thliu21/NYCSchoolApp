import Foundation
import Combine

final class SchoolSATScoreViewModel: ObservableObject {
    enum LoadingState {
        case notStarted
        case loading
        case loaded(SchoolSATScoreInfo)
        case failed
    }
    
    @Published var loadingState: LoadingState = .notStarted
    
    private var cancellables = Set<AnyCancellable>()
    private let dbn: String
    private let api: SchoolSATScoreAPIProtocol
    
    func loadSATScore() {
        guard case .notStarted = loadingState else {
            return
        }
        self.loadingState = .loading
        api.fetchSchoolSATScore(dbn: dbn)
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
    }
    
    init(dbn: String, api: SchoolSATScoreAPIProtocol = NYCOpenDatabaseAPI()) {
        self.dbn = dbn
        self.api = api
    }
}

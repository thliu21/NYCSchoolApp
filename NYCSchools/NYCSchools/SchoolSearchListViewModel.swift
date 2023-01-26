import Foundation
import Combine

class SchoolSearchListViewModel: ObservableObject {
    enum LoadingState: Equatable {
        static func == (lhs: SchoolSearchListViewModel.LoadingState, rhs: SchoolSearchListViewModel.LoadingState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.failed, .failed):
                return true
            case (.notStarted, .notStarted):
                return true
            case (.loaded(let schools1), .loaded(let schools2)):
                if schools1.count != schools2.count {
                    return false
                } else {
                    return schools1.elementsEqual(schools2) { $0 == $1 }
                }
            default:
                return false
            }
        }
        
        case notStarted
        case loading
        case loaded([SchoolInfo])
        case failed
    }
    
    @Published var search: String = ""
    @Published var loadingState: LoadingState = .notStarted
    
    private var cancellables = Set<AnyCancellable>()
    private var api: SchoolDirectoryAPIProtocol
    
    func fetchSchoolWithSearch() {
        guard .loading != loadingState else { return }
        loadingState = .loading
        api.fetchSchoolDirectory(offset: nil, limit: nil, search: search.lowercased())
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.loadingState = .failed
                }
            } receiveValue: { schools in
                self.loadingState = .loaded(schools)
            }
            .store(in: &cancellables)
    }
    
    init(api: SchoolDirectoryAPIProtocol = NYCOpenDatabaseAPI()) {
        self.api = api
    }
}

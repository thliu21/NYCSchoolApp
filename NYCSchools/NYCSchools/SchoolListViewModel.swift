import Foundation
import Combine

class SchoolListViewModel: ObservableObject {
    enum APILoadingState {
        case loading, loaded, failed, finished
    }
    
    private static let initialLoadingBatchSize = 40
    private static let loadingBatchSize = 20
    
    @Published var loadingState = APILoadingState.loaded
    @Published var schoolInfo = [SchoolInfo]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadMoreSchools() {
        switch loadingState {
        case .loading, .finished:
            return
        case .loaded, .failed:
            loadingState = .loading
            let loadingSize = schoolInfo.count == 0 ? Self.initialLoadingBatchSize : Self.loadingBatchSize
            NYCOpenDatabaseAPI.fetchSchoolDirectory(
                offset: schoolInfo.count,
                limit: loadingSize
            )
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.loadingState = .failed
                }
            } receiveValue: { [weak self] schoolInfos in
                guard let self = self else { return }
                self.schoolInfo.append(contentsOf: schoolInfos)
                self.loadingState = schoolInfos.count < loadingSize ? .finished : .loaded
            }
            .store(in: &cancellables)
        }
    }
}

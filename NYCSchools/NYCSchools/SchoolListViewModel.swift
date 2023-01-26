import Foundation
import Combine

final class SchoolListViewModel: ObservableObject {
    enum APILoadingState {
        case notStarted, loading, loaded, failed, finished
    }
    
    private let initialLoadingBatchSize: Int
    private let loadingBatchSize: Int
    
    @Published var loadingState = APILoadingState.notStarted
    @Published var schoolInfo = [SchoolInfo]()
    
    private var cancellables = Set<AnyCancellable>()
    private var api: SchoolDirectoryAPIProtocol
    
    func loadMoreSchools() {
        switch loadingState {
        case .loading, .finished:
            return
        case .loaded, .failed, .notStarted:
            loadingState = .loading
            let loadingSize = schoolInfo.count == 0 ? initialLoadingBatchSize : loadingBatchSize
            api.fetchSchoolDirectory(
                offset: schoolInfo.count,
                limit: loadingSize
            )
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(_):
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
    
    init(
        api: SchoolDirectoryAPIProtocol = NYCOpenDatabaseAPI(),
        initialLoadingBatchSize: Int = 40,
        loadingBatchSize: Int = 20
    ) {
        print("init")
        self.api = api
        self.initialLoadingBatchSize = initialLoadingBatchSize
        self.loadingBatchSize = loadingBatchSize
    }
}

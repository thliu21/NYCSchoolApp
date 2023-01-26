import XCTest
import Combine
@testable import NYCSchools

final class FauxSchoolDirectoryAPI: SchoolDirectoryAPIProtocol {
    private let shouldFail: Bool
    private var batchCount: Int = 2

    func fetchSchoolDirectory(offset: Int?, limit: Int?, search: String?) -> AnyPublisher<[NYCSchools.SchoolInfo], Error> {
        let mockSize = batchCount == 0 ? 1 : (limit ?? 10)
        let mockData = (0..<mockSize).map { num in
            SchoolInfo(dbn: String(num), schoolName: "Snoop Dogg High", bus: "M1", subway: "A", address: "123 Foo st.", latitude: "123.0", longitude: "456.0", city: "Somewhere")
        }
        return Just(mockData)
        .tryMap { schools in
            if shouldFail {
                throw APIError.parsingError
            }
            batchCount -= 1
            return schools
        }
        .eraseToAnyPublisher()
    }

    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
}

final class FauxSchoolSATScoresAPI: SchoolSATScoreAPIProtocol {
    private let shouldFail: Bool

    func fetchSchoolSATScore(dbn: String) -> AnyPublisher<NYCSchools.SchoolSATScoreInfo, Error> {
        let mockData = SchoolSATScoreInfo(dbn: "123", criticalReadingScore: "345", mathScore: "456", writingScore: "777")
        return Just(mockData)
        .tryMap { schools in
            if shouldFail {
                throw APIError.parsingError
            }
            return schools
        }
        .eraseToAnyPublisher()
    }

    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
}

final class NYCSchoolsTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testSchoolListViewModel() throws {
        let initialLoadingSize = Int.random(in: 10...30)
        let loadingSize = Int.random(in: 10...30)
        let exp1 = XCTestExpectation()
        let exp2 = XCTestExpectation()
        let exp3 = XCTestExpectation()
        let vm = SchoolListViewModel(
            api: FauxSchoolDirectoryAPI(shouldFail: false),
            initialLoadingBatchSize: initialLoadingSize,
            loadingBatchSize: loadingSize
        )
        vm.$schoolInfo.sink { schools in
            switch schools.count {
            case initialLoadingSize:
                exp1.fulfill()
            case initialLoadingSize + loadingSize:
                exp2.fulfill()
            case initialLoadingSize + loadingSize + 1:
                exp3.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        (1...3).forEach { num in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(num) / 5.0) {
                vm.loadMoreSchools()
            }
        }
        wait(for: [exp1, exp2, exp3], timeout: 10.0)
    }

    func testSchoolListViewModelFail() throws {
        let initialLoadingSize = Int.random(in: 10...30)
        let loadingSize = Int.random(in: 10...30)
        let exp1 = XCTestExpectation()
        exp1.isInverted = true
        let vm = SchoolListViewModel(
            api: FauxSchoolDirectoryAPI(shouldFail: true),
            initialLoadingBatchSize: initialLoadingSize,
            loadingBatchSize: loadingSize
        )
        vm.$schoolInfo.sink { schools in
            if schools.count != 0 {
                exp1.fulfill()
            }
        }
        .store(in: &cancellables)
        vm.$loadingState.sink { state in
            switch state {
            case .finished, .loaded:
                exp1.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        (1...3).forEach { num in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(num) / 5.0) {
                vm.loadMoreSchools()
            }
        }
        wait(for: [exp1], timeout: 1.0)
    }

    func testSchoolSATScoreViewModel() throws {
        let exp1 = XCTestExpectation()
        let vm = SchoolSATScoreViewModel(
            dbn: "123",
            api: FauxSchoolSATScoresAPI(shouldFail: false)
        )
        vm.$loadingState.sink { state in
            switch state {
            case .loaded(let scores):
                XCTAssert(scores.id == "123")
                exp1.fulfill()
            case .failed:
                XCTFail()
            case .notStarted, .loading:
                break
            }
        }
        .store(in: &cancellables)
        vm.loadSATScore()
        wait(for: [exp1], timeout: 1.0)
    }

    func testSchoolSATScoreViewModelFail() throws {
        let exp1 = XCTestExpectation()
        let vm = SchoolSATScoreViewModel(
            dbn: "123",
            api: FauxSchoolSATScoresAPI(shouldFail: true)
        )
        vm.$loadingState.sink { state in
            switch state {
            case .loaded:
                XCTFail()
            case .failed:
                exp1.fulfill()
            case .notStarted, .loading:
                break
            }
        }
        .store(in: &cancellables)
        vm.loadSATScore()
        wait(for: [exp1], timeout: 1.0)
    }
}

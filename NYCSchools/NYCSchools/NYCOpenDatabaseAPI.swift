import Foundation
import Combine

enum APIError: Error {
    case noDataError
    case parsingError
}

protocol SchoolDirectoryAPIProtocol {
    func fetchSchoolDirectory(offset: Int, limit: Int) -> AnyPublisher<[SchoolInfo], Error>
}

protocol SchoolSATScoreAPIProtocol {
    func fetchSchoolSATScore(dbn: String) -> AnyPublisher<SchoolSATScoreInfo, Error>
}

struct NYCOpenDataConstants {
    static let appTokenParam = "X-App-Token"
    static let appToken = "JXCPPDJLwaLK3ejCW0e5XpYN0"
    static let baseUrl = "https://data.cityofnewyork.us/resource/"
    static let schoolDirectoryAPI = "s3k6-pzi2.json"
    static let schoolSATScoreAPI = "f9bf-2cp4.json"
    static let apiLimitParam = "$limit"
    static let apiOffsetParam = "$offset"
    static let apiOrderParam = "$order"
    static let apiDbnParam = "dbn"
    static let apiOrderValue = "dbn"
    
    static func buildSchoolDirectoryUrlRequest(offset: Int, limit: Int) -> URLRequest {
        guard var components = URLComponents(string: Self.baseUrl)
        else {
            fatalError()
        }
        components.path += self.schoolDirectoryAPI
        components.queryItems = [
            URLQueryItem(name: Self.apiLimitParam, value: String(limit)),
            URLQueryItem(name: Self.apiOffsetParam, value: String(offset)),
            URLQueryItem(name: Self.apiOrderParam, value: Self.apiOrderValue),
        ]
        guard let url = components.url
        else {
            fatalError()
        }
        var request = URLRequest(url: url)
        request.setValue(self.appToken, forHTTPHeaderField: self.appTokenParam)
        request.httpMethod = "GET"
        return request
    }
    
    static func buildSchoolSATScoreUrlRequest(dbn: String) -> URLRequest {
        guard var components = URLComponents(string: Self.baseUrl)
        else {
            fatalError()
        }
        components.path += self.schoolSATScoreAPI
        components.queryItems = [
            URLQueryItem(name: Self.apiDbnParam, value: String(dbn)),
        ]
        guard let url = components.url
        else {
            fatalError()
        }
        var request = URLRequest(url: url)
        request.setValue(self.appToken, forHTTPHeaderField: self.appTokenParam)
        request.httpMethod = "GET"
        return request
    }
}

struct NYCOpenDatabaseAPI {
    private static func fetchAPI(req: URLRequest) -> AnyPublisher<Data, Error> {
        Future<Data, Error> { promise in
            let task = URLSession.shared.dataTask(with: req) { data, res, error in
                if let data = data {
                    promise(.success(data))
                } else if let error = error {
                    promise(.failure(error))
                }
                promise(.failure(APIError.noDataError))
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
    
extension NYCOpenDatabaseAPI: SchoolDirectoryAPIProtocol {
    func fetchSchoolDirectory(offset: Int, limit: Int) -> AnyPublisher<[SchoolInfo], Error> {
        Self.fetchAPI(
            req: NYCOpenDataConstants.buildSchoolDirectoryUrlRequest(offset: offset, limit: limit)
        )
        .tryMap { data in
            try JSONDecoder().decode([SchoolInfo].self, from: data)
        }
        .eraseToAnyPublisher()
    }
}

extension NYCOpenDatabaseAPI: SchoolSATScoreAPIProtocol {
    func fetchSchoolSATScore(dbn: String) -> AnyPublisher<SchoolSATScoreInfo, Error> {
        Self.fetchAPI(
            req: NYCOpenDataConstants.buildSchoolSATScoreUrlRequest(dbn: dbn)
        )
        .tryMap { data in
            try JSONDecoder().decode([SchoolSATScoreInfo].self, from: data)
        }
        .tryMap { info in
            if let info = info.first {
                return info
            } else {
                throw APIError.noDataError
            }
        }
        .eraseToAnyPublisher()
    }
}

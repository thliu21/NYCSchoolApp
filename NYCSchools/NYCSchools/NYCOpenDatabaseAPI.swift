import Foundation
import Combine

enum APIError: Error {
    case noDataError
    case parsingError
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
    static func fetchSchoolDirectory(offset: Int, limit: Int) -> AnyPublisher<[SchoolInfo], Error> {
        let req = NYCOpenDataConstants.buildSchoolDirectoryUrlRequest(offset: offset, limit: limit)
        return Future { promise in
            let task = URLSession.shared.dataTask(with: req) { data, res, error in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.failure(APIError.noDataError))
                    }
                    return
                }
                do {
                    let content = try JSONDecoder().decode([SchoolInfo].self, from: data)
                    promise(.success(content))
                } catch {
                    promise(.failure(APIError.parsingError))
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchSchoolSATScore(dbn: String) -> AnyPublisher<SchoolSATScoreInfo, Error> {
        let req = NYCOpenDataConstants.buildSchoolSATScoreUrlRequest(dbn: dbn)
        return Future { promise in
            let task = URLSession.shared.dataTask(with: req) { data, res, error in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.failure(APIError.noDataError))
                    }
                    return
                }
                do {
                    let content = try JSONDecoder().decode([SchoolSATScoreInfo].self, from: data)
                    if let first = content.first {
                        promise(.success(first))
                    } else {
                        promise(.failure(APIError.noDataError))
                    }
                } catch {
                    promise(.failure(APIError.parsingError))
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}

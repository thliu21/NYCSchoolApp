import Foundation

struct SchoolInfo: Decodable, Identifiable, Equatable {
    var id: String { dbn }
    let dbn: String
    let schoolName: String
    let bus: String?
    let subway: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let city: String?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case dbn
        case schoolName = "school_name"
        case latitude
        case longitude
        case address = "primary_address_line_1"
        case city
        case bus
        case subway
    }
    
    static func == (lhs: SchoolInfo, rhs: SchoolInfo) -> Bool {
        lhs.dbn == rhs.dbn
    }
}

struct SchoolSATScoreInfo: Decodable, Identifiable {
    var id: String { dbn }
    let dbn: String
    let criticalReadingScore: String?
    let mathScore: String?
    let writingScore: String?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case dbn
        case criticalReadingScore = "sat_critical_reading_avg_score"
        case mathScore = "sat_math_avg_score"
        case writingScore = "sat_writing_avg_score"
    }
}

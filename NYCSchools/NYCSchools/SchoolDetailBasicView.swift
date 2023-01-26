import Foundation
import SwiftUI

struct SchoolDetailBasicInfoView: View {
    var title: String
    var content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
            Text(content)
        }
    }
}

struct SchoolDetailBasicView: View {
    var schoolInfo: SchoolInfo
    
    var body: some View {
        SchoolDetailBasicInfoView(title: "🏫", content: schoolInfo.schoolName)
        if let address = schoolInfo.address {
            SchoolDetailBasicInfoView(title: "📍", content: address)
        }
        if let bus = schoolInfo.bus {
            SchoolDetailBasicInfoView(title: "🚌", content: bus)
        }
        if let subway = schoolInfo.subway {
            SchoolDetailBasicInfoView(title: "🚇", content: subway)
        }
    }
}

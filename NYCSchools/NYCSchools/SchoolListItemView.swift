import SwiftUI

struct SchoolListItemView: View {
    let school: SchoolInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(school.schoolName)
            if let city = school.city {
                Text(city)
                    .font(.system(.footnote))
                    .foregroundColor(.gray)
            }
        }
    }
}

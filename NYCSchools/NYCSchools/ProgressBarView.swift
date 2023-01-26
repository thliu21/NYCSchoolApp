import SwiftUI

struct ProgressBarView: View {
    let value: CGFloat
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .foregroundColor(color.opacity(0.3))
                
                Rectangle().frame(
                    width: min(self.value*geometry.size.width, geometry.size.width),
                    height: geometry.size.height
                )
                .foregroundColor(color)
            }
            .cornerRadius(geometry.size.height / 2)
        }
        .frame(height: 18.0)
    }
}

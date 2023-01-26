import SwiftUI

struct ProgressBarView: View {
    let progress: CGFloat
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .foregroundColor(color.opacity(0.2))
                
                Rectangle().frame(
                    width: min(self.progress, 1.0) * geometry.size.width,
                    height: geometry.size.height
                )
                .foregroundColor(color)
            }
            .cornerRadius(geometry.size.height / 2)
        }
        .frame(height: 18.0)
    }
}

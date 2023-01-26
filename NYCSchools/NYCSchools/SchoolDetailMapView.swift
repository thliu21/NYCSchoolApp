import SwiftUI
import MapKit

struct SchoolDetailMapView: View {
    struct MarkerCoordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    let schoolInfo: SchoolInfo
    
    var body: some View {
        if let latStr = schoolInfo.latitude,
           let lat = Double(latStr),
           let longStr = schoolInfo.longitude,
           let long = Double(longStr) {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            Map(
                coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: center,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )),
                annotationItems: [MarkerCoordinate(coordinate: center)]
            ) { MapMarker(coordinate: $0.coordinate) }
            .frame(height: 300)
        } else {
            Text("Location unavailable :(")
                .foregroundColor(.gray)
        }
    }
}

import Foundation
import SwiftUI

struct SchoolListView: View {
    @StateObject private var vm = SchoolListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(vm.schoolInfo) { school in
                        NavigationLink {
                            SchoolDetailView(schoolInfo: school)
                        } label: {
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
                    switch vm.loadingState {
                    case .loaded:
                        Text("(Loading...)")
                            .onAppear {
                                vm.loadMoreSchools()
                            }
                    case .loading:
                        Text("(Loading...)")
                            .foregroundColor(.gray)
                    case .failed:
                        Button("Failed to load, tap here to try again") {
                            vm.loadMoreSchools()
                        }
                    case .finished:
                        HStack(alignment: .center) {
                            Text("(You have reached the bottom of the list)")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("NYC High Schools")
            .toolbar {
                if vm.loadingState == .loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
    }
}

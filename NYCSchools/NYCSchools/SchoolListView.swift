import Foundation
import SwiftUI

struct SchoolListView: View {
    @StateObject private var vm = SchoolListViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    // Main list
                    ForEach(vm.schoolInfo) { school in
                        NavigationLink {
                            SchoolDetailView(schoolInfo: school)
                        } label: {
                            SchoolListItemView(school: school)
                        }
                    }

                    // Footer to trigger reload
                    switch vm.loadingState {
                    case .loaded, .notStarted:
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
                NavigationLink {
                    SchoolSearchListView()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }
}

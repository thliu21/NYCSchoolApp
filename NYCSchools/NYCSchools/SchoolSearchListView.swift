//
//  SchoolSearchListView.swift
//  NYCSchools
//
//  Created by Arthur Liu on 1/26/23.
//

import Foundation
import SwiftUI

struct SchoolSearchListView: View {
    @StateObject private var vm = SchoolSearchListViewModel()
    @FocusState private var focused: Bool
    
    var body: some View {
        List {
            Section {
                TextField("Search", text: $vm.search)
                    .focused($focused)
                if vm.search.count > 0 {
                    Button("Submit") {
                        vm.fetchSchoolWithSearch()
                        focused = false
                    }
                    .disabled(.loading == vm.loadingState)
                }
            }
            
            Section("Result") {
                if vm.search.count == 0,
                   .notStarted == vm.loadingState {
                    Text("Type in to start searching...")
                        .foregroundColor(.gray)
                } else {
                    switch vm.loadingState {
                    case .loaded(let schools):
                        if schools.count > 0 {
                            ForEach(schools) { school in
                                NavigationLink {
                                    SchoolDetailView(schoolInfo: school)
                                } label: {
                                    SchoolListItemView(school: school)
                                }
                            }
                        } else {
                            Text("No matching school...")
                                .foregroundColor(.gray)
                        }
                    case .failed:
                        Button("Failed to search, tap to try again") {
                            vm.fetchSchoolWithSearch()
                        }
                    case .loading:
                        Text("Searching...")
                    case .notStarted:
                        Text("Tap Submit to start")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .simultaneousGesture(DragGesture().onChanged({ _ in
            focused = false
        }))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            focused = true
        }
    }
}

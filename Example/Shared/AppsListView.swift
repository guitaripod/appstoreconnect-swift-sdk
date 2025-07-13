//
//  AppsListView.swift
//  Shared
//
//  Created by Antoine van der Lee on 11/07/2022.
//

import SwiftUI

struct AppsListView: View {
    
    @StateObject var viewModel = AppsListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.apps) { app in
                    VStack(alignment: .leading) {
                        Text(app.attributes?.name ?? "Unknown name")
                            .font(.headline)
                        Text(app.attributes?.bundleID ?? "Unknown bundle ID")
                            .font(.subheadline)
                    }
                }
                ProgressView()
                    .opacity(viewModel.apps.isEmpty ? 1.0 : 0.0)
            }
            .navigationTitle("List of Apps")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Refresh") {
                            viewModel.loadApps()
                        }

                        Button("Fail") {
                            viewModel.loadFailureExample()
                        }
                    }
                }
        }
    }
}

struct AppsListView_Previews: PreviewProvider {
    static var previews: some View {
        AppsListView()
    }
}

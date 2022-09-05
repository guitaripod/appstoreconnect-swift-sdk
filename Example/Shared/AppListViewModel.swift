//
//  AppListViewModel.swift
//  AppStoreConnectAPIExample
//
//  Created by Marcus Ziadé on 5.9.2022.
//

import AppStoreConnect_Swift_SDK
import Foundation

final class AppsListViewModel: ObservableObject {
    
    @Published var apps: [AppStoreConnect_Swift_SDK.App] = []
    
    /// Go to https://appstoreconnect.apple.com/access/api and create your own key.
    /// This is also the page to find the private key ID and the issuer ID.
    /// Download the private key and open it in a text editor.
    /// Remove the enters and copy the contents over to the private key parameter.
    private let configuration = APIConfiguration(
        issuerID: AccessKey.issuerID.rawValue,
        privateKeyID: AccessKey.privateKeyID.rawValue,
        privateKey: AccessKey.privateKey.rawValue
    )
    private lazy var provider: APIProvider = APIProvider(configuration: configuration)
    
    init() {
        loadApps()
    }
    
    func loadApps() {
        Task.detached { @MainActor [unowned self] in
            let request = APIEndpoint
                .v1
                .apps
                .get(parameters: .init(
                    sort: [.bundleID],
                    fieldsApps: [.appInfos, .name, .bundleID],
                    limit: 5
                ))
            
            do {
                apps = try await self.provider.request(request).data
            } catch {
                print("Something went wrong fetching the apps: \(error.localizedDescription)")
            }
        }
    }
    
    /// This demonstrates a failing example and how you can catch error details.
    func loadFailureExample() {
        Task.detached {
            let requestWithError = APIEndpoint
                .v1
                .builds
                .id("app.appId")
                .get()
            
            do {
                print(try await self.provider.request(requestWithError).data)
            } catch APIProvider.Error.requestFailure(let statusCode, let errorResponse, _) {
                print("Request failed with statuscode: \(statusCode) and the following errors:")
                errorResponse?.errors?.forEach({ error in
                    print("Error code: \(error.code)")
                    print("Error title: \(error.title)")
                    print("Error detail: \(error.detail)")
                })
            } catch {
                print("Something went wrong fetching the apps: \(error.localizedDescription)")
            }
        }
    }
}

//
//  RemoteService.swift
//  TopPizza
//
//  Created by Константин Клинов on 25/07/25.
//

import Foundation

protocol RemoteMenuServiceProtocol {
    func fetchAllMenuItems(completion: @escaping (Result<[MenuItem], Error>) -> Void)
}

class RemoteMenuService: RemoteMenuServiceProtocol {
    private let endpointProvider: EndpointProvider
    private let decoder: MenuItemDecoder
    private let session: URLSession

    init(
        endpointProvider: EndpointProvider = DefaultEndpointProvider(),
        decoder: MenuItemDecoder = DefaultMenuItemDecoder(),
        session: URLSession = .shared
    ) {
        self.endpointProvider = endpointProvider
        self.decoder = decoder
        self.session = session
    }

    func fetchAllMenuItems(completion: @escaping (Result<[MenuItem], Error>) -> Void) {
        let group = DispatchGroup()
        var allItems: [MenuItem] = []
        var fetchError: Error?

        for url in endpointProvider.endpoints {
            let category = url.lastPathComponent
            group.enter()

            session.dataTask(with: url) { data, response, error in
                defer { group.leave() }

                if let error = error {
                    fetchError = error
                    print("❌ Network error: \(error)")
                    return
                }

                guard
                    let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let data = data
                else {
                    print("❌ Bad response for \(url.absoluteString)")
                    return
                }

                do {
                    let items = try self.decoder.decode(data, category: category)
                    allItems.append(contentsOf: items)
                } catch {
                    print("❗️ Decoding failed: \(error)")
                    fetchError = error
                }

            }.resume()
        }

        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(allItems))
            }
        }
    }
}

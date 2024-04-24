//
//  AsyncImageLoader.swift
//  RideShare
//
//  Created by Pablo Junco on 31/03/24.
//

import Combine
import SwiftUI

class AsyncImageLoader: ObservableObject {
    @Published var imageData: Data?
    @Published var isLoading = false
    @Published var loadFailed = false

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            loadFailed = true
            return
        }
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data, error == nil {
                    self.imageData = data
                    self.loadFailed = false
                } else {
                    self.imageData = nil
                    self.loadFailed = true
                }
            }
        }.resume()
    }

    func reset() {
        imageData = nil
        loadFailed = false
    }
}

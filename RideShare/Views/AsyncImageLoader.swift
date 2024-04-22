//
//  AsyncImageLoader.swift
//  RideShare
//
//  Created by Pablo Junco on 31/03/24.
//

import Combine
import SwiftUI

class AsyncImageLoader: ObservableObject {
    @Published var imageData: Data? = nil
    
    private var cancellable: AnyCancellable?
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.imageData = data
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

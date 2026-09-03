//
//  ImageListViewModel.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//
import Foundation

@Observable
final class ImageListViewModel {
    let networkMonitor: NetworkMonitor
    var currentToastText: String? = nil
    private var toastTask: Task<Void, Never>?


    //Static demo items
    var images: [ImageItemModel] = (1...100).map {
        ImageItemModel(
            id: $0,
            title: "Image \($0)",
            imageURL: URL(
                string: "https://picsum.photos/id/\($0 * 10)/600/400"
            )!
        )
    }

    init(networkMonitor: NetworkMonitor = NetworkMonitor()) {
        self.networkMonitor = networkMonitor

    }
    func handleConnectivityChange(from wasConnected: Bool, to isConnected: Bool) {
            if isConnected && !wasConnected {
                showToast("Back online")
            } else if !isConnected {
                currentToastText = nil
            }
        }
    func showToast(_ text: String) {
            toastTask?.cancel()
        currentToastText = text
            toastTask = Task {
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { return }
                currentToastText = nil
            }
        }

}
extension ImageListViewModel {
    func changeImageList() {
        let startId = images.last?.id ?? 0
        images = (1...100).map {
            let id = $0 + startId
            return ImageItemModel(
                id: id,
                title: "Image \(id)",
                imageURL: URL(
                    string: "https://picsum.photos/id/\(id * 10)/600/400"
                )!
            )
        }
    }
}

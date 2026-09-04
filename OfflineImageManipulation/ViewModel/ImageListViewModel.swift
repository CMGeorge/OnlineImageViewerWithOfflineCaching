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
    let wallpaperRepository: WallpapersRepositoryProtocol //for testability
    
    var currentToastText: String? = nil
    private var toastTask: Task<Void, Never>?

    //general loading state
    var isLoading = false

    private var dataSynced: Bool = false
    //Static demo items
    var images: [ImageItemModel] = []

    init(networkMonitor: NetworkMonitor = NetworkMonitor(),
    repository: WallpapersRepositoryProtocol? = nil) {
        self.networkMonitor = networkMonitor
        self.wallpaperRepository = repository ?? WallpapersRepository(network: networkMonitor)

    }
    func loadData() async {
        isLoading = true
        dataSynced = false
        defer { isLoading = false }

        do {
            let result = try await wallpaperRepository.fetchImages()
            images = result.items
            if (result.source == .Cache){
                showToast(result.isFromOffline ? "Offline — cached list" : "Showing cached list" )
            }else {
                dataSynced = true
            }
            
        }catch {
            showToast("Could not load image list")
        }
    }
    func handleConnectivityChange(from wasConnected: Bool, to isConnected: Bool) async {
            if isConnected && !wasConnected {
                showToast("Back online")
                await loadData()
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

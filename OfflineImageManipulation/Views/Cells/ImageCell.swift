//
//  ImageCell.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI

struct ImageCell: View {
    //imutable, initialized by the parent on create
    let displayAs: DisplayMode
    let image: ImageItemModel
    @State private var showImage = false  //temporary to simulate loading
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var hasError = false

    @State private var showFullScreen = false
    var body: some View {
        Button(action: onTap) {
            cellContent
        }
        .buttonStyle(.plain)
        .task {
            await loadImage()
        }
        .fullScreenCover(isPresented: $showFullScreen) {
                    FullScreenImageView(image: image)
                }
    }

}
extension ImageCell {
    private func onTap() {
        print("Image tapped: \(image.title)")
        showFullScreen = true
    }
    private func loadImage() async {
        do {
            // Temporary delay so we can see the placeholder.
            try await Task.sleep(for: .seconds(2))
            isLoading = true
            let (data, _) = try await URLSession.shared.data(
                from: image.imageURL
            )
            //need this to not update the ui if task was canceled.
            try Task.checkCancellation()
            try await Task.sleep(for: .seconds(2))  //more delay for ui testing
            guard let uiImage = UIImage(data: data) else {
                hasError = true
                return
            }
            self.uiImage = uiImage
            isLoading = false
        } catch is CancellationError {
            print("Image loading cancelled: \(image.id)")
        } catch {
            print("Image loading failed: \(error)")
            hasError = true
            isLoading = false
        }
    }
    func prepareForReuse() {
        showImage = false
        uiImage = nil
        isLoading = false
        hasError = false
    }
}
extension ImageCell {

    private var imageHeight: CGFloat {
        displayAs == .grid ? 160 : 240
    }

    @ViewBuilder
    var cellContent: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if hasError {
            failureView
        } else if isLoading {
            loadingView
        } else {
            placeholder
        }
    }
    private var loadingView: some View {
        imageContainer {
            ProgressView()
                .controlSize(.extraLarge)
                .frame(
                    maxWidth: .infinity,
                    minHeight: displayAs == .grid ? 160 : 240,
                    maxHeight: displayAs == .grid ? 160 : 240
                )

        }
    }
    private var placeholder: some View {
        imageContainer {
            Image(systemName: "photo")
                .font(.largeTitle)
        }

    }
    private var failureView: some View {
        imageContainer {
            Image(systemName: "photo.trianglebadge.exclamationmark")
                .font(.largeTitle)
        }

    }
    //helper function to make sure we always drwa the cell in the same mode
    private func imageContainer<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.1))
            .overlay {
                content()
            }
            .frame(
                maxWidth: .infinity,
                minHeight: imageHeight,
                maxHeight: imageHeight
            )
    }
}

#Preview {
    ContentView()
}

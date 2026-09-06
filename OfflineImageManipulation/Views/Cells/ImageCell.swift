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
    let isOnline: Bool

    @State private var showImage = false  //temporary to simulate loading
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var hasError = false

    @State private var showFullScreen = false

    private var imageAccessibilityValue: Text {
        if uiImage != nil { return Text("") }
        if isLoading { return Text("Loading") }
        if hasError { return Text("Could not load") }
        return Text("Not loaded")
    }

    var body: some View {
        Button(action: onTap) {
            cellContent
        }
        .buttonStyle(.plain)
        .task(id: image.id) {
            await loadImage()
        }
        .onChange(of: isOnline) { _, online in
            guard online, uiImage == nil else { return }
            Task { await loadImage() }
        }
        .sheet(isPresented: $showFullScreen) {
            FullScreenImageView(
                image: image,
                isOnline: self.isOnline
            )
        }
        //accessibility
        .accessibilityLabel(image.title)
        .accessibilityHint(Text("Shows the image full screen."))
        .accessibilityValue(imageAccessibilityValue)
        .overlay(alignment: .bottom) {
            overlayCaption
        }
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.4), radius: 4, x: 10, y: 10)

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
            //            try await Task.sleep(for: .seconds(2))
            isLoading = true
            hasError = false
            //We should use the network state
            let data = try await ImageLoader.shared.retrieveImage(
                for: image.imageURL,
                allowNetwork: isOnline
            )

            //need this to not update the ui if task was canceled.
            try Task.checkCancellation()
            //            try await Task.sleep(for: .seconds(2))  //more delay for ui testing
            guard let uiImage = UIImage(data: data) else {
                hasError = true
                return
            }
            self.uiImage = uiImage
            isLoading = false
        } catch is CancellationError {
            //            print("Image loading cancelled: \(image.id)")
        } catch {
            //            print("Image loading failed: \(error)")
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

extension ImageCell {
    private var captionGradient: LinearGradient {
        LinearGradient(
            colors: [Color.gray.opacity(0.5), Color.black],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var overlayCaption: some View {
        Text (image.title)
//        Text(
//            "This is a very long text to check how the text will be displayed in case it is very big. I prefer to show it on 4 rows on list view and about 2 rows in grid wiew with tailing right and word wrap"
//        )
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(Color.white)
        .lineLimit(displayAs == .list ? 3 : 2)
        .truncationMode(.tail)
        .multilineTextAlignment(.leading)
        .allowsTightening(false)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(captionGradient)
        .accessibilityHidden(true)
    }
    /*
     TODO: Implement calculation to word wrap + trailing ...
     If I'm not wrong same problem was also on UIKit
     */
}

#Preview {
    ContentView(imageListViewModel: ImageListViewModel())
}

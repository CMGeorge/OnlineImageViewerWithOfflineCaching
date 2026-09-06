//
//  FullScreenImageView.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI

struct FullScreenImageView: View {
    let image: ImageItemModel
    let isOnline: Bool

    @State private var loadeImage: UIImage? = nil
    @State private var loadingFailed = false
    @State private var isLoading: Bool = false
    
    @Environment(\.dismiss)
    private var dismiss
    
    
    private var imageAccessibilityValue: Text {
        if loadeImage != nil { return Text("") }
        if isLoading { return Text("Loading") }
        if loadingFailed { return Text("Could not load") }
        return Text("Not loaded")
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                HStack {
                    Color.clear
                        .frame(width: 36, height: 36)
                        .padding()
                        .accessibilityHidden(true)
                    
                    Text(image.title)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.black)
                            .frame(width: 36, height: 36)
                            .background(.ultraThickMaterial, in: Circle())
                            .padding()
                    }
                    .accessibilityLabel(Text("Close"))

                }
                .background(.ultraThinMaterial)
                viewContent

            }   
        }
        .statusBarHidden()
        .onChange(of: isOnline) { _, online in
            guard online, loadeImage == nil else { return }
            Task { await loadImage() }
        }
        .task {
            await loadImage()
        }
    }
}

extension FullScreenImageView {
    @ViewBuilder
    private var viewContent: some View {
        if let loadeImage {
            Image(uiImage: loadeImage)
                .resizable()
                .scaledToFit()
                .accessibilityLabel(Text(image.title))
        } else if loadingFailed {
            Image(systemName: "photo.trianglebadge.exclamationmark")
                .font(.largeTitle)
                .foregroundStyle(.white)
        } else {
            ProgressView()
                .tint(.white)
                .controlSize(.large)
        }

    }
    
    private func loadImage() async {
        do {
            loadingFailed = false
            isLoading = true
            defer { isLoading = false } //mare ure loadin state is changed when exist the function
            
            print("Load image: \(image.id) form \(image.imageURL)")
            //lets use cached data also here.
            let data = try await ImageLoader.shared.retrieveImage(for: image.imageURL, allowNetwork: isOnline)

            //need this to not update the ui if task was canceled.
            try Task.checkCancellation()
            guard let uiImage = UIImage(data: data) else {
                loadingFailed = true
                print("Invalid image data")
                return
            }
            self.loadeImage = uiImage
        } catch is CancellationError {
            print("Fullscreen Image loading cancelled: \(image.id)")
        } catch {
            print("Fullscreen Image loading failed: \(error)")
            loadingFailed = true
        }
    }
}

#Preview {
    FullScreenImageView(
        image: ImageItemModel(
            id: 0,
            title: "Test",
            imageURL: URL(
                string: "https://picsum.photos/id/1001/600/400"
            )!
        ),
        isOnline: true
    )
}

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

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                HStack {
                    Color.clear
                        .frame(width: 36, height: 36)
                        .padding()
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

                }
                .background(.ultraThinMaterial)
                viewContent

            }

            //            .padding()
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
            print("Load image: \(image.id) form \(image.imageURL)")
            let (data, _) = try await URLSession.shared.data(
                from: image.imageURL
            )
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

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

    //zoom control
    @State private var scale: CGFloat = 1
    @State private var baseScale: CGFloat = 1

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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

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
        if loadeImage != nil {
            theImage
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
    @ViewBuilder
    private var theImage: some View {

        Image(uiImage: loadeImage!)
            .resizable()
            .scaledToFit()
            .accessibilityLabel(Text(image.title))
            .scaleEffect(scale)
            .onTapGesture(count: 2) {
                print("Double tap on image")
                withAnimation(.easeInOut) {

                    switch scale {
                    case 0..<2: scale = 2
                    case 2..<3: scale = 3
                    case 3..<4: scale = 4
                    default:
                        scale = 1
                    }
                    baseScale = scale

                }
            }
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        withAnimation(.easeInOut) {
                            let next = baseScale * value.magnification
                            scale = min(max(next, 1), 4)
                        }
                    }
                    .onEnded { _ in
                        if scale < 1.05 {
                            withAnimation(.easeOut) { scale = 1 }
                            baseScale = 1
                        } else {
                            baseScale = scale
                        }
                    }
            )

    }
    private func loadImage() async {
        do {
            loadingFailed = false
            isLoading = true
            defer { isLoading = false }  //mare ure loadin state is changed when exist the function

            print("Load image: \(image.id) form \(image.imageURL)")
            //lets use cached data also here.
            let data = try await ImageLoader.shared.retrieveImage(
                for: image.imageURL,
                allowNetwork: isOnline
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

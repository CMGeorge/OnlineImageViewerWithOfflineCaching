# Offline images demo

SwiftUI sample: wallpaper list from a MockAPI, usable **online and offline**. Built as a vertical slice (MVVM + repository), not as a production gallery.

## Flow

`ContentView` → `ImageListViewModel` → `WallpapersRepository` → `APIService` (list JSON) / `WallpaperListCache` (Application Support) / `ImageLoader` + `CacheImage` (Caches, SHA-256 filenames).

`NWPathMonitor` drives the offline banner. Images: disk first, network only if `allowNetwork`. Reconnect refetches the list once per session if it was never synced from the API (`dataSynced`).

## Why these choices

- **Repository** — UI tests the VM with a mock; JSON/API tests use a real repo + stub API.
- **`actor ImageLoader`** — coalesces in-flight downloads for the same URL (grid cells).
- **SHA-256 file names** — URL strings are not safe path components.
- **No memory image cache** — disk is enough for this size; an `NSCache` would be the next knob for scroll jank, not a second source of truth.

## Run

- Xcode scheme, iOS Simulator. API: `https://6a994a2f53c0481726b91819.mockapi.io/api/v1/wallpapers`
- Airplane mode: list + images from cache if you opened them once.
- Romanian: Scheme → Run → App Language → Romanian (`Localizable.xcstrings`).

## Intentionally not done

- Thumbnails / downsample (full-resolution JPEGs in the grid).
- Pinch-to-zoom has no pan; zoom is clipped under the chrome.
- `Text` truncation is character-based (`truncationMode(.tail)`); UIKit has no word-boundary ellipsis either.
- No pagination, no SwiftData, no analytics.
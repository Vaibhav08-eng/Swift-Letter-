import SwiftUI

@main
struct SwiftLetterApp: App {
    @StateObject private var bookmarks = BookmarkStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarks)
                .preferredColorScheme(.light)
        }
    }
}

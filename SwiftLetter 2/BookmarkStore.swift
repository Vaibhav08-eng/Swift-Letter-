import Foundation

@MainActor
final class BookmarkStore: ObservableObject {
    @Published private(set) var ids: Set<String> {
        didSet { save() }
    }

    private let key = "swiftletter.bookmarked-editions"

    init() {
        let stored = UserDefaults.standard.stringArray(forKey: "swiftletter.bookmarked-editions") ?? []
        ids = Set(stored)
    }

    func contains(_ edition: NewsletterEdition) -> Bool {
        ids.contains(edition.id)
    }

    func toggle(_ edition: NewsletterEdition) {
        if ids.contains(edition.id) {
            ids.remove(edition.id)
        } else {
            ids.insert(edition.id)
        }
    }

    private func save() {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }
}

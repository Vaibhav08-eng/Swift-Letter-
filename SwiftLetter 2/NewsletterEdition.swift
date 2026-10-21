import Foundation

enum NewsletterCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case swift = "Swift"
    case ios = "iOS"
    case ai = "AI"
    case club = "Club Updates"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .all: "sparkles"
        case .swift: "swift"
        case .ios: "iphone"
        case .ai: "brain.head.profile"
        case .club: "person.3.fill"
        }
    }
}

struct NewsletterEdition: Identifiable, Hashable {
    let id: String
    let number: Int
    let title: String
    let date: Date
    let summary: String
    let category: NewsletterCategory
    let readingMinutes: Int
    let article: [ArticleBlock]

    static let samples: [NewsletterEdition] = [
        NewsletterEdition(id: "swift-01", number: 12, title: "The little things that make Swift feel magical", date: date(2026, 10, 8), summary: "A closer look at expressive APIs, value types, and the details that make everyday Swift code a joy to write.", category: .swift, readingMinutes: 5, article: [
            .lead("Good tools disappear into the work. Swift has a way of making common ideas feel direct, without hiding what the computer is doing."),
            .heading("A language that reads like intent"),
            .paragraph("Optionals make the possibility of missing data visible. Enums let a type describe its own valid states. Together, they help us model real problems instead of passing vague strings and hoping for the best."),
            .quote("The best API is often the one that makes the right thing the easy thing."),
            .heading("Small types, clear boundaries"),
            .paragraph("A struct can represent a newsletter edition, a reading progress marker, or a color token. Keeping related values together makes code easier to reason about and easier to change."),
            .paragraph("Try this today: pick one dictionary of loosely related values and give it a small, meaningful type. You may find the rest of the code starts explaining itself.")
        ]),
        NewsletterEdition(id: "ios-01", number: 11, title: "A calmer way to build your first SwiftUI screen", date: date(2026, 10, 1), summary: "Start with a clear hierarchy, a small view, and a preview loop. Your first screen does not need to be complicated.", category: .ios, readingMinutes: 4, article: [
            .lead("A good first screen is not a showcase of every component. It is one clear answer to the question: what should someone do here?"),
            .heading("Start with the content"),
            .paragraph("Write down the one thing the screen needs to communicate. Put that first in the layout. Supporting actions should be easy to find without competing for attention."),
            .heading("Compose, then refine"),
            .paragraph("SwiftUI views are small descriptions of interface. Begin with a vertical stack and a few text styles. Extract a reusable view when a piece has a clear name or appears in more than one place."),
            .quote("Build the simplest screen that tells the story. Then make it feel good."),
            .paragraph("Previews help you explore spacing and type quickly. Check a small and a large device size before you call the screen done.")
        ]),
        NewsletterEdition(id: "ai-01", number: 10, title: "Using AI as a coding partner, not an autopilot", date: date(2026, 9, 24), summary: "A practical loop for asking better questions, checking generated code, and keeping your understanding in the driver's seat.", category: .ai, readingMinutes: 6, article: [
            .lead("AI tools can help you move through unfamiliar code faster. The useful skill is learning how to check what they give you."),
            .heading("Ask for one useful thing"),
            .paragraph("Instead of requesting an entire application, ask for a small function, an explanation of an error, or two approaches to a specific problem. Narrow questions produce answers you can inspect."),
            .heading("Keep the feedback loop"),
            .paragraph("Read the code, run it, and compare the behavior with what you expected. If you cannot explain a line, ask about it or simplify it. Generated code is a draft, not evidence that the design is sound."),
            .quote("Understanding is the feature you take with you to the next project."),
            .paragraph("A thoughtful workflow uses AI to accelerate exploration while keeping decisions, testing, and responsibility with the developer.")
        ]),
        NewsletterEdition(id: "club-01", number: 9, title: "What we built together this month", date: date(2026, 9, 17), summary: "Demo night highlights, new members, and a few ways to join the next Swift Coding Club session.", category: .club, readingMinutes: 3, article: [
            .lead("This month was full of small experiments that turned into things people could actually use."),
            .heading("Demo night highlights"),
            .paragraph("We saw a campus navigation prototype, a habit tracker with a lovely onboarding flow, and a playful soundboard built in a weekend. Each project started with a small question and grew through feedback."),
            .heading("Join the next session"),
            .paragraph("Bring a laptop, an idea, or simply your curiosity. Beginners are welcome, and there will be time to pair on setup before we start building."),
            .quote("Make something small. Show someone. Learn what to try next."),
            .paragraph("Watch the club channel for the date and room announcement. We hope to see you there.")
        ]),
        NewsletterEdition(id: "swift-02", number: 8, title: "Protocols: shared behavior without the tangles", date: date(2026, 9, 10), summary: "Protocols help describe what a type can do. Here is how to use them to keep features flexible and focused.", category: .swift, readingMinutes: 5, article: [
            .lead("A protocol describes a promise. Any type that fulfills the promise can work with code that depends on it."),
            .heading("Depend on behavior"),
            .paragraph("Imagine a screen that needs to load editions. It does not need to know whether those editions came from a local array, a file, or a network request. A small protocol can describe the loading behavior."),
            .heading("Keep abstractions earned"),
            .paragraph("Protocols are useful when there is a real boundary or more than one implementation to support. For a tiny one-off view, a simple concrete type is often clearer."),
            .quote("Good abstraction removes a detail you should not have to think about yet."),
            .paragraph("Start with the behavior your feature needs. Add a protocol when it gives that behavior a useful seam.")
        ]),
        NewsletterEdition(id: "ios-02", number: 7, title: "Designing for dark mode from the start", date: date(2026, 9, 3), summary: "Use semantic colors and test contrast early so your interface adapts naturally to the user's appearance setting.", category: .ios, readingMinutes: 4, article: [
            .lead("Dark mode works best when it is part of the design system, rather than a color inversion added at the end."),
            .heading("Choose meaning over fixed color"),
            .paragraph("Use semantic system colors for text, backgrounds, and separators. They adapt to the current appearance and help preserve contrast across devices."),
            .heading("Test real screens"),
            .paragraph("Look at cards, images, and controls in both appearances. A surface that feels subtle on white can become too bright on a dark background."),
            .quote("A theme is a set of relationships between colors, not just a palette."),
            .paragraph("SwiftUI previews make it easy to inspect both appearances side by side while you build.")
        ])
    ]

    static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day)) ?? .now
    }
}

enum ArticleBlock: Hashable {
    case lead(String)
    case heading(String)
    case paragraph(String)
    case quote(String)
}

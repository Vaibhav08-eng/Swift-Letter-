import SwiftUI

private enum ReaderTab: String, CaseIterable, Identifiable {
    case discover = "Discover"
    case saved = "Saved"
    var id: String { rawValue }
    var symbol: String { self == .discover ? "square.grid.2x2" : "bookmark" }
}

@MainActor
private final class ReaderViewModel: ObservableObject {
    @Published var selectedTab: ReaderTab = .discover
    @Published var searchText = ""
    @Published var selectedCategory: NewsletterCategory = .all
}

struct ContentView: View {
    @EnvironmentObject private var bookmarks: BookmarkStore
    @StateObject private var viewModel = ReaderViewModel()

    private var visibleEditions: [NewsletterEdition] {
        NewsletterEdition.samples.filter { edition in
            let matchesTab = viewModel.selectedTab == .discover || bookmarks.contains(edition)
            let matchesCategory = viewModel.selectedCategory == .all || edition.category == viewModel.selectedCategory
            let query = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchesSearch = query.isEmpty || [edition.title, edition.summary, edition.category.rawValue, edition.article.map { block in
                switch block {
                case .lead(let text), .heading(let text), .paragraph(let text), .quote(let text): text
                }
            }.joined(separator: " ")].joined(separator: " ").localizedCaseInsensitiveContains(query)
            return matchesTab && matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.paper.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        header
                        searchField
                        tabPicker
                        categoryPicker
                        if viewModel.selectedTab == .discover && viewModel.searchText.isEmpty && viewModel.selectedCategory == .all {
                            featuredEdition
                        }
                        editionList
                        footer
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 12)
                    .padding(.bottom, 35)
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationDestination(for: NewsletterEdition.self) { edition in
                ArticleView(edition: edition)
            }
        }
        .tint(Color.ink)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 7) {
                    Image(systemName: "sparkle")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.coral)
                    Text("SWIFT CODING CLUB")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .tracking(2.2)
                        .foregroundStyle(Color.mutedInk)
                }
                Text("The Weekly\n.swift")
                    .font(.system(size: 42, weight: .bold, design: .serif))
                    .tracking(-1.6)
                    .lineSpacing(-9)
                    .foregroundStyle(Color.ink)
                Text("Ideas, code & community — in your corner.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.mutedInk)
                    .padding(.top, 2)
            }
            Spacer(minLength: 8)
            ZStack {
                Circle().fill(Color.ink).frame(width: 48, height: 48)
                Text("S")
                    .font(.system(size: 25, weight: .bold, design: .serif))
                    .foregroundStyle(Color.paper)
            }
            .padding(.top, 8)
        }
        .padding(.top, 8)
    }

    private var searchField: some View {
        HStack(spacing: 11) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.mutedInk)
            TextField("Search stories, topics, editions…", text: $viewModel.searchText)
                .font(.system(size: 14))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color.mutedInk)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 49)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.line, lineWidth: 1))
    }

    private var tabPicker: some View {
        HStack(spacing: 6) {
            ForEach(ReaderTab.allCases) { tab in
                Button { withAnimation(.easeInOut(duration: 0.18)) { viewModel.selectedTab = tab } } label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.symbol).font(.system(size: 13, weight: .semibold))
                        Text(tab.rawValue).font(.system(size: 13, weight: .semibold))
                        if tab == .saved && !bookmarks.ids.isEmpty {
                            Text("\(bookmarks.ids.count)")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .padding(.horizontal, 6).padding(.vertical, 3)
                                .background(viewModel.selectedTab == tab ? Color.white.opacity(0.18) : Color.paper, in: Capsule())
                        }
                    }
                    .foregroundStyle(viewModel.selectedTab == tab ? Color.white : Color.mutedInk)
                    .frame(maxWidth: .infinity).frame(height: 42)
                    .background(viewModel.selectedTab == tab ? Color.ink : Color.clear, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.line, lineWidth: 1))
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(NewsletterCategory.allCases) { category in
                    Button { withAnimation(.easeInOut(duration: 0.18)) { viewModel.selectedCategory = category } } label: {
                        HStack(spacing: 6) {
                            if category != .all { Image(systemName: category.symbol).font(.system(size: 10, weight: .bold)) }
                            Text(category.rawValue).font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(viewModel.selectedCategory == category ? Color.white : Color.ink)
                        .padding(.horizontal, 13).frame(height: 34)
                        .background(viewModel.selectedCategory == category ? Color.coral : Color.white, in: Capsule())
                        .overlay(Capsule().stroke(viewModel.selectedCategory == category ? Color.coral : Color.line, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.trailing, 2)
    }

    private var featuredEdition: some View {
        let edition = NewsletterEdition.samples[0]
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("EDITOR’S PICK", systemImage: "sun.max.fill")
                    .font(.system(size: 10, weight: .bold)).tracking(1.4)
                Spacer()
                Text("VOL. \(String(format: "%02d", edition.number))")
                    .font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(1)
            }
            .foregroundStyle(Color.white.opacity(0.72))
            Text(edition.title)
                .font(.system(size: 27, weight: .bold, design: .serif))
                .tracking(-0.4)
                .lineSpacing(-3)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text(edition.summary)
                .font(.system(size: 13)).lineSpacing(4)
                .foregroundStyle(Color.white.opacity(0.78))
                .lineLimit(3)
            NavigationLink(value: edition) {
                HStack(spacing: 7) {
                    Text("Read the story").font(.system(size: 12, weight: .bold))
                    Image(systemName: "arrow.up.right").font(.system(size: 10, weight: .bold))
                }
                .foregroundStyle(Color.ink).padding(.horizontal, 14).frame(height: 36)
                .background(Color.paper, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
        .padding(21)
        .background {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 22).fill(Color.ink)
                Circle().stroke(Color.white.opacity(0.07), lineWidth: 1).frame(width: 180, height: 180).offset(x: 45, y: -85)
                Circle().stroke(Color.white.opacity(0.07), lineWidth: 1).frame(width: 125, height: 125).offset(x: 15, y: -58)
            }.clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "swift").font(.system(size: 78, weight: .light))
                .foregroundStyle(Color.white.opacity(0.07)).padding(18)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var editionList: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.selectedTab == .saved ? "Your reading list" : "Fresh from the club")
                        .font(.system(size: 21, weight: .bold, design: .serif)).foregroundStyle(Color.ink)
                    Text("\(visibleEditions.count) EDITION\(visibleEditions.count == 1 ? "" : "S")")
                        .font(.system(size: 9, weight: .bold, design: .rounded)).tracking(1.7).foregroundStyle(Color.mutedInk)
                }
                Spacer()
                Image(systemName: "arrow.down.right")
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.coral)
            }

            if visibleEditions.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(visibleEditions) { edition in
                        NavigationLink(value: edition) {
                            EditionCard(edition: edition)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: viewModel.selectedTab == .saved ? "bookmark" : "text.magnifyingglass")
                .font(.system(size: 25, weight: .light)).foregroundStyle(Color.coral)
            Text(viewModel.selectedTab == .saved ? "Your saved stories will live here" : "No stories found")
                .font(.system(size: 16, weight: .bold, design: .serif)).foregroundStyle(Color.ink)
            Text(viewModel.selectedTab == .saved ? "Tap the bookmark on any edition to keep it close." : "Try another search or category.")
                .font(.system(size: 12)).foregroundStyle(Color.mutedInk).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 28).padding(.horizontal, 18)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.line, lineWidth: 1))
    }

    private var footer: some View {
        HStack(spacing: 7) {
            Image(systemName: "heart.fill").foregroundStyle(Color.coral)
            Text("Made with care by the Swift Coding Club")
                .foregroundStyle(Color.mutedInk)
        }
        .font(.system(size: 10, weight: .medium))
        .frame(maxWidth: .infinity).padding(.top, 4)
    }
}

private struct EditionCard: View {
    @EnvironmentObject private var bookmarks: BookmarkStore
    let edition: NewsletterEdition

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            VStack(spacing: 3) {
                Text(edition.date.formatted(.dateTime.month(.abbreviated)).uppercased())
                    .font(.system(size: 8, weight: .bold, design: .rounded)).tracking(1)
                    .foregroundStyle(Color.coral)
                Text(edition.date.formatted(.dateTime.day()))
                    .font(.system(size: 22, weight: .bold, design: .serif)).foregroundStyle(Color.ink)
            }
            .frame(width: 48, height: 52)
            .background(Color.paper, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: edition.category.symbol).font(.system(size: 9, weight: .bold))
                    Text(edition.category.rawValue.uppercased()).font(.system(size: 9, weight: .bold)).tracking(1.1)
                    Text("·").foregroundStyle(Color.line)
                    Text("VOL. \(String(format: "%02d", edition.number))").font(.system(size: 9, weight: .medium, design: .monospaced))
                }
                .foregroundStyle(Color.mutedInk)
                Text(edition.title)
                    .font(.system(size: 16, weight: .bold, design: .serif)).tracking(-0.2)
                    .foregroundStyle(Color.ink).multilineTextAlignment(.leading).lineLimit(2)
                Text(edition.summary)
                    .font(.system(size: 11)).lineSpacing(3).foregroundStyle(Color.mutedInk)
                    .multilineTextAlignment(.leading).lineLimit(2)
                HStack(spacing: 5) {
                    Image(systemName: "clock").font(.system(size: 9))
                    Text("\(edition.readingMinutes) MIN READ").font(.system(size: 9, weight: .semibold)).tracking(0.5)
                }
                .foregroundStyle(Color.mutedInk.opacity(0.8)).padding(.top, 2)
            }
            Spacer(minLength: 2)
            Button { bookmarks.toggle(edition) } label: {
                Image(systemName: bookmarks.contains(edition) ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(bookmarks.contains(edition) ? Color.coral : Color.mutedInk)
                    .frame(width: 31, height: 31)
                    .background(Color.paper.opacity(0.8), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(bookmarks.contains(edition) ? "Remove bookmark" : "Bookmark edition")
        }
        .padding(13)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(Color.line, lineWidth: 1))
        .contentShape(RoundedRectangle(cornerRadius: 17))
    }
}

extension Color {
    static let paper = Color(red: 0.965, green: 0.950, blue: 0.916)
    static let ink = Color(red: 0.110, green: 0.173, blue: 0.164)
    static let mutedInk = Color(red: 0.440, green: 0.480, blue: 0.445)
    static let coral = Color(red: 0.850, green: 0.341, blue: 0.245)
    static let line = Color(red: 0.890, green: 0.875, blue: 0.835)
}

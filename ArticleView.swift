import SwiftUI

struct ArticleView: View {
    @EnvironmentObject private var bookmarks: BookmarkStore
    @Environment(\.dismiss) private var dismiss
    let edition: NewsletterEdition

    var body: some View {
        ZStack {
            Color.paper.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    hero
                    articleBody
                }
                .frame(maxWidth: 680)
                .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top, spacing: 0) { navigationBar }
        .tint(Color.ink)
    }

    private var navigationBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.ink)
                    .frame(width: 42, height: 42)
                    .background(Color.paper.opacity(0.96), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to editions")
            Spacer()
            Text("THE WEEKLY .SWIFT")
                .font(.system(size: 9, weight: .bold, design: .rounded)).tracking(1.8)
                .foregroundStyle(Color.ink)
            Spacer()
            Button { bookmarks.toggle(edition) } label: {
                Image(systemName: bookmarks.contains(edition) ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(bookmarks.contains(edition) ? Color.coral : Color.ink)
                    .frame(width: 42, height: 42)
                    .background(Color.paper.opacity(0.96), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(bookmarks.contains(edition) ? "Remove bookmark" : "Bookmark edition")
        }
        .padding(.horizontal, 20).padding(.vertical, 8)
        .background(LinearGradient(colors: [Color.paper, Color.paper.opacity(0)], startPoint: .top, endPoint: .bottom))
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 7) {
                Image(systemName: edition.category.symbol).font(.system(size: 10, weight: .bold))
                Text(edition.category.rawValue.uppercased()).font(.system(size: 10, weight: .bold)).tracking(1.5)
                Circle().fill(Color.coral).frame(width: 3, height: 3)
                Text("VOL. \(String(format: "%02d", edition.number))").font(.system(size: 10, weight: .medium, design: .monospaced))
            }
            .foregroundStyle(Color.coral)
            Text(edition.title)
                .font(.system(size: 36, weight: .bold, design: .serif))
                .tracking(-1).lineSpacing(-5).foregroundStyle(Color.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(edition.summary)
                .font(.system(size: 15)).lineSpacing(5).foregroundStyle(Color.mutedInk)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 8) {
                Circle().fill(Color.coral.opacity(0.18)).frame(width: 28, height: 28)
                    .overlay(Text("S").font(.system(size: 15, weight: .bold, design: .serif)).foregroundStyle(Color.coral))
                Text("SWIFT CODING CLUB").font(.system(size: 9, weight: .bold)).tracking(1.2).foregroundStyle(Color.ink)
                Circle().fill(Color.mutedInk.opacity(0.4)).frame(width: 3, height: 3)
                Text(edition.date.formatted(.dateTime.month(.wide).day().year()))
                    .font(.system(size: 10, weight: .medium)).foregroundStyle(Color.mutedInk)
            }
            Divider().overlay(Color.line).padding(.top, 4)
        }
        .padding(.horizontal, 24).padding(.top, 67).padding(.bottom, 25)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var articleBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(edition.article.enumerated()), id: \.offset) { _, block in
                switch block {
                case .lead(let text):
                    Text(text)
                        .font(.system(size: 19, weight: .medium, design: .serif))
                        .lineSpacing(6).foregroundStyle(Color.ink)
                        .padding(.bottom, 25)
                case .heading(let text):
                    Text(text)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .tracking(-0.4).foregroundStyle(Color.ink)
                        .padding(.top, 8).padding(.bottom, 10)
                case .paragraph(let text):
                    Text(text)
                        .font(.system(size: 15)).lineSpacing(7).foregroundStyle(Color.mutedInk)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 20)
                case .quote(let text):
                    HStack(alignment: .top, spacing: 13) {
                        RoundedRectangle(cornerRadius: 2).fill(Color.coral).frame(width: 3)
                        Text("“\(text)”")
                            .font(.system(size: 19, weight: .semibold, design: .serif))
                            .lineSpacing(5).foregroundStyle(Color.ink).fixedSize(horizontal: false, vertical: true)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 5).padding(.bottom, 21)
                }
            }
            HStack(spacing: 7) {
                Image(systemName: "sparkle").foregroundStyle(Color.coral)
                Text("END OF EDITION · \(edition.readingMinutes) MIN READ")
                    .font(.system(size: 9, weight: .bold)).tracking(1.1).foregroundStyle(Color.mutedInk)
            }
            .padding(.top, 9).padding(.bottom, 45)
        }
        .padding(.horizontal, 26)
        .frame(maxWidth: 680, alignment: .leading)
        .frame(maxWidth: .infinity)
    }
}

# The Weekly .swift

Hi! This is a small newsletter reader app I made for the Swift Coding Club. I wanted it to feel like a calm little place to catch up on Swift, iOS, AI, and club news.

The app is made with **Swift and SwiftUI**. You can browse editions, search for a topic, open and read an article, filter by category, and save editions to your reading list.

## Screenshots

### Discover editions

![The Weekly .swift discover screen](screenshots/discover.png)

### Filter by category

![The Weekly .swift filtered by iOS](screenshots/category-filter.png)

## What you can do

- Browse newsletter editions with a title, date, short description, and reading time.
- Search across titles, descriptions, categories, and article text.
- Filter editions by Swift, iOS, AI, or Club Updates.
- Tap an edition to read the full article.
- Bookmark editions and find them later in the **Saved** tab.

## Run it

1. Download this repository and open `SwiftLetter.xcodeproj` in Xcode.
2. Choose an iPhone simulator from the device menu at the top.
3. Press **Run** or use **⌘R**.

The project uses iOS 17 or later. It does not need an account or an internet connection to run.

## A bit about how it works

The editions are sample content included in the app, so everything is available as soon as it launches. Bookmarks are saved on the device with `UserDefaults`. There is no server or live newsletter feed in this version.

### Built with

- Swift
- SwiftUI
- Foundation

## Project files

- `SwiftLetterApp.swift` starts the app and shares bookmark data.
- `NewsletterEdition.swift` contains the edition model and sample articles.
- `BookmarkStore.swift` handles saving and removing bookmarks.
- `ContentView.swift` contains the discover screen, search, and category filters.
- `ArticleView.swift` displays the full article.

The newsletter articles are sample/demo content. They can be replaced with approved club editions when those are available.

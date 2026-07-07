import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [PuzzleEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("puzzlebox_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: PuzzleEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: PuzzleEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PuzzleEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([PuzzleEntry].self, from: data) else {
            seed()
            return
        }
        entries = decoded
    }

    private func seed() {
        entries = [
            PuzzleEntry(title: "Sample Puzzle 1", rating: 3, pieces: 2, brand: "Sample", minutes: 2, notes: "Sample"),
            PuzzleEntry(title: "Sample Puzzle 2", rating: 4, pieces: 2, brand: "Sample", minutes: 2, notes: "Sample"),
            PuzzleEntry(title: "Sample Puzzle 3", rating: 5, pieces: 2, brand: "Sample", minutes: 2, notes: "Sample")
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}

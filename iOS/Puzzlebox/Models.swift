import Foundation

struct PuzzleEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var rating: Int = 3
    var dateAdded: Date = Date()
    var pieces: Double
    var brand: String
    var minutes: Double
    var notes: String

    init(id: UUID = UUID(), title: String, rating: Int = 3, dateAdded: Date = Date(), pieces: Double = 0, brand: String = "", minutes: Double = 0, notes: String = "") {
        self.id = id
        self.title = title
        self.rating = rating
        self.dateAdded = dateAdded
        self.pieces = pieces
        self.brand = brand
        self.minutes = minutes
        self.notes = notes
    }
}

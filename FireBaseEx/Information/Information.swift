import Foundation

struct Human: Codable {
    let information: [Information]
}

// MARK: - Information
struct Information: Codable {
    let name: String
    let age: Int
    let hobby: String
}

import Foundation

struct GSItems: Codable, Identifiable {
    var id = UUID().uuidString
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let mediaType: String?
    let serviceVersion: String?
    let title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

struct AuthDataResultModel {
    let id: String
    let firstName: String
    let lastName: String?
}

struct UserData {
    let firstName: String
    let lastName: String?
    let email: String
    let password: String
}

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
    let user: UserSession
}

struct UserData {
    let user: UserSession
    let email: String
    let password: String
}

struct UserSession: Codable {
    let firstName: String
    let lastName: String?
}

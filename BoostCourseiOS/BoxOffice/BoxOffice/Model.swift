//
//  Model.swift
//  BoxOffice
//
//  Created by MZ01-KYONGH on 2022/04/28.
//

import Foundation

struct APIResponse: Codable {
    let movies: [Movie]
}

enum OrderType: Int {
    case type0 = 0
    case type1 = 1
    case type2 = 2
}

struct Movie: Codable {
    let userRating: Double
    let rservationGrade: Int
    let reservationRate: Double
    let thumb: String
    let title: String
    let grade: Int
    let date: String
    let id: String
    
    var detail: String {
        return ("평점 : \(userRating) 예매순위 : \(rservationGrade) 예매율 : \(reservationRate)")
    }
    var dateText: String {
        return("개봉일 \(date)")
    }
    
    enum CodingKeys: String, CodingKey {
        case thumb, title, grade, date, id
        case userRating = "user_rating"
        case rservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
    }
}

struct MovieDetail: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

struct APIResponseComments: Codable {
    let comments: [Comment]
}

struct Comment: Codable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    let id: String
    
    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    var fullDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents, id
        case movieId = "movie_id"
    }
}

struct PostComment: Codable {
    let rating: Double
    let writer: String
    let movieId: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case movieId = "movie_id"
    }
}

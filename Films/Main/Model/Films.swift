//
//  Films.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import Foundation

struct Films: Decodable {
    var results: [FilmDetail]
}

struct FilmDetail: Decodable {
    var title: String
    var original_title: String
    var poster_path: String
    var id: Int
    var vote_average: Float
}

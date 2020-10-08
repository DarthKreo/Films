//
//  FilmDescription.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import Foundation

struct FilmDescription: Decodable {
    
    var title: String
    var original_title: String
    var poster_path: String
    var runtime: Int
    var budget: Int
    var vote_average: Float
    var overview: String
    var release_date: String
    var genres: [Genre]
}

struct Genre: Decodable {
    var name: String
}

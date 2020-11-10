//
//  Films.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import Foundation

// MARK: - Films

struct Films: Decodable {
    
    //MARK: - Public properties
    
    var results: [FilmDetail]
}

// MARK: - FilmDetail

struct FilmDetail: Decodable {
    
    //MARK: - Public properties
    
    var title: String
    var original_title: String
    var poster_path: String
    var id: Int
    var vote_average: Float
}

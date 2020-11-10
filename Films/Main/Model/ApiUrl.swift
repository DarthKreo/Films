//
//  ApiUrl.swift
//  Films
//
//  Created by Владимир Кваша on 13.10.2020.
//

import Foundation

// MARK: - ApiUrl

enum ApiUrl {
    
    enum ApiKey {
        static let key: String = "b74f5dc48cbedf1d5198ef2b7521940e"
    }
    
    static let resourceString: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(ApiUrl.ApiKey.key)&language=ru-RU&page=1"
    static let filmResourse: String = "https://api.themoviedb.org/3/movie/"
    static let filmResourseEnd: String = "?api_key=\(ApiUrl.ApiKey.key)&language=ru-RU"
    static let trailerAdress: String = "https://www.youtube.com/results?search_query="
    static let trailerAdressEnd: String = "+official+trailer"
    static let urlImage: String = "https://image.tmdb.org/t/p/original/"
    
}


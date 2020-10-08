//
//  FilmRequest.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import Foundation

enum FilmError: Error {
    case noDataAvailable 
    case canNotProcessData
}

struct FilmRequest {
    let resourceURL: URL
    let api_key = "b74f5dc48cbedf1d5198ef2b7521940e"
    
    init() {
        let resourceString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)&language=ru-RU&page=1"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func getFilms (completion: @escaping(Result<[FilmDetail], FilmError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let filmResponse = try decoder.decode(Films.self, from: jsonData)
                let filmDetails = filmResponse.results
                completion(.success(filmDetails))
            }catch{
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}

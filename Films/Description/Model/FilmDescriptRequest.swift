//
//  FilmDescripRequest.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import Foundation

enum DescriptionError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct DescriptionRequest {
    let resourceURL: URL
    let api_key = "b74f5dc48cbedf1d5198ef2b7521940e"
    
    init(movieId: FilmDetail) {
        
        let resourceString = "https://api.themoviedb.org/3/movie/\(movieId.id)?api_key=\(api_key)&language=ru-RU"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func getDescription (completion: @escaping(Result<FilmDescription, FilmError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let descriptResponse = try decoder.decode(FilmDescription.self, from: jsonData)
                completion(.success(descriptResponse))
            }catch{
                completion(.failure(.canNotProcessData))
            }
    }
        dataTask.resume()
}
}

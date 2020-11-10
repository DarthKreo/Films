//
//  FilmRequest.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import Foundation

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func getFilms(completion: @escaping(Result<[FilmDetail], Errors.FilmError>) -> Void)
    func getDescription (completion: @escaping(Result<FilmDescription, Errors.DescriptionError>) -> Void)
}

// MARK: - Errors

enum Errors {
    
    enum FilmError: Error {
        case noDataAvailable
        case canNotProcessData
    }
    
    enum DescriptionError: Error {
        case noDataAvailable
        case canNotProcessData
    }
}

// MARK: - Requests

struct Requests: NetworkServiceProtocol {
    
    //MARK: - Private properties
    
    private let resourceURL: URL
    
    // MARK: - Inits
    
    init() {
        
        let resourceString = ApiUrl.resourceString
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    init(movieId: FilmDetail) {
        
        let resourceString = ApiUrl.filmResourse + String(movieId.id) + ApiUrl.filmResourseEnd
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    // MARK: - getFilms
    
    func getFilms(completion: @escaping(Result<[FilmDetail], Errors.FilmError>) -> Void) {
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
    
    // MARK: - getDescription
    
    func getDescription (completion: @escaping(Result<FilmDescription, Errors.DescriptionError>) -> Void) {
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

//
//  FilmCell.swift
//  Films
//
//  Created by Владимир Кваша on 06.10.2020.
//

import UIKit

final class FilmCell: UITableViewCell {
    
    //MARK: - Private properties
    
    private lazy var filmImage = UIImageView()
    private lazy var filmName = UILabel()
    private lazy var filmOriginalName = UILabel()
    private lazy var filmRate = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func set(film: FilmDetail) {
        filmName.text = film.title
        filmOriginalName.text = film.original_title
        filmRate.text = Constants.filmRateText + (String(film.vote_average))
        
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/original/\(film.poster_path)") else {return}
        let data = try? Data(contentsOf: urlImage)
        if let image = data {
            filmImage.image = UIImage(data: image)
            
        }
    }
}
// MARK: - Setup

private extension FilmCell {
    func setupCell() {
        addSubviews()
        
        setupFilmImage()
        setupFilmName()
        setupFilmOriginalName()
        
        layoutCell()
    }
}

// MARK: - Setups Views

private extension FilmCell {
    private func addSubviews() {
        addSubview(filmImage)
        addSubview(filmName)
        addSubview(filmOriginalName)
        addSubview(filmRate)
    }
    
    private func setupFilmImage() {
        filmImage.clipsToBounds = true
        filmImage.contentMode = .scaleAspectFill
    }
    
    private func setupFilmName() {
        filmName.numberOfLines = Constants.filmNameNumberOfLines
        filmName.font = UIFont.boldSystemFont(ofSize: Constants.filmNameFont)
        filmName.adjustsFontSizeToFitWidth = true
    }
    
    private func setupFilmOriginalName() {
        filmOriginalName.numberOfLines = Constants.filmNameNumberOfLines
        filmOriginalName.textColor = .darkGray
        filmOriginalName.font = UIFont.systemFont(ofSize: Constants.filmOriginalNameFont)
    }
}

// MARK: - Layout

private extension FilmCell {
    private func layoutCell() {
        filmImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmImage.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.filmImageLeftAnchor),
                                        filmImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                                        filmImage.heightAnchor.constraint(equalToConstant: Constants.filmImageHeightAnchor),
                                        filmImage.widthAnchor.constraint(equalTo: filmImage.heightAnchor, multiplier: Constants.filmImageWidthAnchor)])
        
        filmName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmName.topAnchor.constraint(equalTo: filmImage.topAnchor),
                                        filmName.leftAnchor.constraint(equalTo: filmImage.rightAnchor, constant: Constants.filmNameLeftAnchor),
                                        filmName.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.filmNameRightAnchor)])
        
        filmOriginalName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmOriginalName.topAnchor.constraint(equalTo: filmName.bottomAnchor, constant: Constants.filmOriginalNameTopAnchor),
                                        filmOriginalName.leftAnchor.constraint(equalTo: filmName.leftAnchor)])
        
        filmRate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmRate.topAnchor.constraint(equalTo: filmOriginalName.bottomAnchor, constant: Constants.filmRateTopAnchor),
                                        filmRate.leftAnchor.constraint(equalTo: filmName.leftAnchor)])
    }
}

// MARK: - Constants

private extension FilmCell {
    enum Constants {
        static let filmRateText:String = "Рейтинг: "
        static let filmNameNumberOfLines: Int = 4
        static let filmNameFont: CGFloat = 25
        static let filmOriginalNameFont: CGFloat = 15
        static let filmImageLeftAnchor: CGFloat = 10
        static let filmImageHeightAnchor: CGFloat = 175
        static let filmImageWidthAnchor: CGFloat = 0.69
        static let filmNameLeftAnchor: CGFloat = 10
        static let filmNameRightAnchor: CGFloat = -10
        static let filmOriginalNameTopAnchor: CGFloat = 5
        static let filmRateTopAnchor: CGFloat = 20
    }
}

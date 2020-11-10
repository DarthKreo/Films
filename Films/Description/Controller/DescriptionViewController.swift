//
//  DescriptionViewController.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import UIKit
import SafariServices

// MARK: - DescriptionViewController

final class DescriptionViewController: UIViewController {
    
    //MARK: - Private properties
    
    private lazy var posterView = UIImageView()
    private lazy var filmName = UILabel()
    private lazy var filmOriginalName = UILabel()
    private lazy var filmYear = UILabel()
    private lazy var filmRate = UILabel()
    private lazy var filmGenre = UILabel()
    private lazy var filmBudget = UILabel()
    private lazy var filmRuntime = UILabel()
    private lazy var filmDescription = UITextView()
    private lazy var trailerButton = UIButton()
    private lazy var trailerAdress = String()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Actions
    
    @objc
    private func seeTrailer() {
        guard let url = URL(string: trailerAdress) else { return }
        let web = SFSafariViewController(url: url)
        present(web, animated: true, completion: nil)
    }
}

// MARK: - SetupOptions

extension DescriptionViewController {
    func setupOptions(film: FilmDetail) {
        let description: NetworkServiceProtocol = Requests(movieId: film)
        description.getDescription { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: Constants.alertWithTitle, message: Constants.alertWithmessage)
                }
            case .success(let options):
                DispatchQueue.main.async {
                    self.filmName.text = options.title
                    self.filmOriginalName.text = options.original_title
                    self.filmYear.text = Constants.filmYearText + options.release_date
                    self.filmRate.text = Constants.filmRateText + String(options.vote_average)
                    
                    if options.budget == 0 {
                        self.filmBudget.text = Constants.filmBudgetTextFalse
                    } else {
                        self.filmBudget.text = Constants.filmBudgetText + String(options.budget) + Constants.filmBudgetTextEnd }
                    
                    self.filmRuntime.text = Constants.filmRuntimeText + String(options.runtime) + Constants.filmRuntimeTextEnd
                    self.filmDescription.text = options.overview
                    
                    let forHyper = options.original_title
                        .components(separatedBy: Constants.space)
                        .filter {!$0.isEmpty}
                        .joined(separator: Constants.plus)
                    self.trailerAdress = ApiUrl.trailerAdress + forHyper + ApiUrl.trailerAdressEnd
                    
                    var string = String()
                    for index in options.genres {
                        string += (index.name + Constants.space)
                    }
                    self.filmGenre.text = Constants.filmGenreText + string
                    
                    guard let urlImage = URL(string: ApiUrl.urlImage + options.poster_path) else {return}
                    let data = try? Data(contentsOf: urlImage)
                    if let image = data {
                        self.posterView.image = UIImage(data: image)
                    }
                }
            }
        }
    }
}

// MARK: - Setup

private extension DescriptionViewController {
    func setupView() {
        addViews()
        addTargets()
        setSelfView()
        
        setupPosterView()
        setupFilmName()
        setupFilmOriginalName()
        setupFilmGenre()
        setupFilmRuntime()
        setupFilmYear()
        setupFilmBudget()
        setupFilmDescription()
        setupTrailerButton()
        
        layout()
    }
}

// MARK: - Setups Views

private extension DescriptionViewController {
    func addViews() {
        view.addSubview(posterView)
        view.addSubview(filmName)
        view.addSubview(filmOriginalName)
        view.addSubview(filmYear)
        view.addSubview(filmBudget)
        view.addSubview(filmRate)
        view.addSubview(filmGenre)
        view.addSubview(filmRuntime)
        view.addSubview(filmDescription)
        view.addSubview(trailerButton)
    }
    
    func addTargets() {
        trailerButton.addTarget(self, action: #selector(seeTrailer), for: .touchUpInside)
    }
    
    func setSelfView() {
        view.backgroundColor = .white
        navigationItem.title = Constants.navigationItemTitle
    }
    
    func setupPosterView() {
        posterView.clipsToBounds = true
        posterView.contentMode = .scaleAspectFill
    }
    
    func setupFilmName() {
        filmName.numberOfLines = Constants.filmNameNumberOfLines
        filmName.font = UIFont.boldSystemFont(ofSize: Constants.filmNameFont)
    }
    
    func setupFilmOriginalName() {
        filmOriginalName.numberOfLines = Constants.filmNameNumberOfLines
        filmOriginalName.font = UIFont.systemFont(ofSize: Constants.filmOriginalNameFont)
    }
    
    func setupFilmYear() {
        filmYear.font = UIFont.systemFont(ofSize: Constants.filmYearFont)
    }
    
    func setupFilmBudget() {
        filmBudget.font = UIFont.systemFont(ofSize: Constants.filmYearFont)
    }
    
    func setupFilmGenre() {
        filmGenre.numberOfLines = Constants.filmNameNumberOfLines
        filmGenre.font = UIFont.systemFont(ofSize: Constants.filmYearFont)
    }
    
    func setupFilmRuntime() {
        filmRuntime.font = UIFont.systemFont(ofSize: Constants.filmYearFont)
    }
    
    func setupFilmDescription() {
        filmDescription.font = UIFont.systemFont(ofSize: Constants.filmDescriptionFont)
    }
    
    func setupTrailerButton() {
        trailerButton.backgroundColor = .red
        trailerButton.setTitle(Constants.trailerButtonSetTitle, for: .normal)
        trailerButton.setTitleColor(.white, for: .normal)
        trailerButton.layer.cornerRadius = Constants.trailerButtonLayerCornerRadius
    }
}

// MARK: - Layout

private extension DescriptionViewController {
    func layout() {
        filmName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                                      constant: Constants.filmNameTopAnchor),
                                        filmName.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                                       constant: Constants.filmNameLeftAnchor),
                                        filmName.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                        constant: Constants.filmNameRightAnchor)])
        
        posterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        posterView.topAnchor.constraint(equalTo: filmName.bottomAnchor,
                                                                        constant: Constants.posterViewTopAnchor),
                                        posterView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                                         constant: Constants.posterViewLeftAnchor),
                                        posterView.heightAnchor.constraint(equalToConstant: Constants.posterViewHeightAnchor),
                                        posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor,
                                                                          multiplier: Constants.posterViewWidthAnchor)])
        
        
        filmOriginalName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmOriginalName.topAnchor.constraint(equalTo: posterView.topAnchor),
                                        filmOriginalName.leftAnchor.constraint(equalTo: posterView.rightAnchor,
                                                                               constant: Constants.filmOriginalNameLeftAnchor),
                                        filmOriginalName.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                                constant: Constants.filmOriginalNameRightAnchor)])
        
        filmYear.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmYear.topAnchor.constraint(equalTo: posterView.bottomAnchor,
                                                                      constant: Constants.filmYearTopAnchor),
                                        filmYear.leftAnchor.constraint(equalTo: posterView.leftAnchor)])
        
        filmBudget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmBudget.topAnchor.constraint(equalTo: filmYear.bottomAnchor,
                                                                        constant: Constants.filmBudgetTopAnchor),
                                        filmBudget.leftAnchor.constraint(equalTo: posterView.leftAnchor)])
        
        filmRate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmRate.topAnchor.constraint(equalTo: filmOriginalName.bottomAnchor,
                                                                      constant: Constants.filmRateTopAnchor),
                                        filmRate.leftAnchor.constraint(equalTo: filmOriginalName.leftAnchor)])
        
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        trailerButton.topAnchor.constraint(equalTo: filmRate.bottomAnchor,
                                                                           constant: Constants.trailerButtonTopAnchor),
                                        trailerButton.leftAnchor.constraint(equalTo: filmOriginalName.leftAnchor),
                                        trailerButton.rightAnchor.constraint(equalTo: filmOriginalName.rightAnchor)])
        
        filmGenre.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmGenre.topAnchor.constraint(equalTo: filmBudget.bottomAnchor,
                                                                       constant: Constants.filmGenreTopAnchor),
                                        filmGenre.leftAnchor.constraint(equalTo: filmYear.leftAnchor),
                                        filmGenre.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                         constant: Constants.filmGenreRightAnchor)])
        
        filmRuntime.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmRuntime.topAnchor.constraint(equalTo: filmGenre.bottomAnchor,
                                                                         constant: Constants.filmRuntimeTopAnchor),
                                        filmRuntime.leftAnchor.constraint(equalTo: filmGenre.leftAnchor)])
        
        filmDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        filmDescription.topAnchor.constraint(equalTo: filmRuntime.bottomAnchor,
                                                                             constant: Constants.filmDescriptionTopAnchor),
                                        filmDescription.leftAnchor.constraint(equalTo: filmRuntime.leftAnchor),
                                        filmDescription.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                               constant: Constants.filmDescriptionRightAnchor),
                                        filmDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                                constant: Constants.filmDescriptionBottomAnchor)])
    }
}
// MARK: - Constants

private extension DescriptionViewController {
    enum  Constants {
        static let alertWithTitle:String = "Error"
        static let alertWithmessage:String = "No data"
        static let filmYearText: String = "Дата выхода: "
        static let filmRateText: String = "Рейтинг: "
        static let filmBudgetTextFalse: String = "Бюджет: неизвестен"
        static let filmBudgetText: String = "Бюджет: "
        static let filmBudgetTextEnd: String = "$"
        static let filmRuntimeText: String = "Продолжительность "
        static let filmRuntimeTextEnd: String = " мин."
        static let filmGenreText: String = "Жанр: "
        static let navigationItemTitle: String = "Описание"
        static let filmNameNumberOfLines: Int = 0
        static let filmNameFont:CGFloat = 30
        static let filmOriginalNameFont:CGFloat = 25
        static let filmYearFont:CGFloat = 18
        static let filmDescriptionFont:CGFloat = 18
        static let trailerButtonSetTitle: String = "Трейлер"
        
        static let trailerButtonLayerCornerRadius: CGFloat = 10
        
        static let filmNameTopAnchor: CGFloat = 5
        static let filmNameLeftAnchor: CGFloat = 20
        static let filmNameRightAnchor: CGFloat = -20
        
        static let posterViewTopAnchor: CGFloat = 5
        static let posterViewLeftAnchor: CGFloat = 20
        static let posterViewHeightAnchor: CGFloat = 300
        static let posterViewWidthAnchor: CGFloat = 0.69
        
        static let filmOriginalNameLeftAnchor: CGFloat = 5
        static let filmOriginalNameRightAnchor: CGFloat = -10
        
        static let filmYearTopAnchor: CGFloat = 15
        
        static let filmBudgetTopAnchor: CGFloat = 5
        
        static let filmRateTopAnchor: CGFloat = 5
        
        static let trailerButtonTopAnchor: CGFloat = 5
        
        static let filmGenreTopAnchor: CGFloat = 5
        static let filmGenreRightAnchor: CGFloat = -10
        
        static let filmRuntimeTopAnchor: CGFloat = 5
        
        static let filmDescriptionTopAnchor: CGFloat = 15
        static let filmDescriptionRightAnchor: CGFloat = -20
        static let filmDescriptionBottomAnchor: CGFloat = 20
        
        static let space: String = " "
        static let plus: String = "+"
    }
}

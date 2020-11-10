//
//  ViewController.swift
//  Films
//
//  Created by Владимир Кваша on 06.10.2020.
//

import UIKit

// MARK: - MainViewController

final class MainViewController: UIViewController {
    
    //MARK: - Private properties
    
    private lazy var listOfFilms = [FilmDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.filmsTable.reloadData()
            }
        }
    }
    
    private lazy var filmsTable = UITableView(frame: .zero, style: .plain)
    private lazy var activityCircle = UIActivityIndicatorView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let
                cell = tableView.dequeueReusableCell(
                    withIdentifier: Constants.cellIdentifier) as? FilmCell else { return UITableViewCell() }
        
        let film = listOfFilms[indexPath.row]
        cell.set(film: film)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = DescriptionViewController()
        let film = listOfFilms[indexPath.row]
        nextView.setupOptions(film: film)
        nextView.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextView, animated: true)
    }
}

// MARK: - Setup

private extension MainViewController {
    func setupView() {
        addViews()
        
        setSelfView()
        setupFilmsTable()
        setupActivityCircle()
        getFilms()
        
        layout()
    }
}

// MARK: - Setups Views

private extension MainViewController {
    func addViews() {
        view.addSubview(filmsTable)
        view.addSubview(activityCircle)
    }
    
    func getFilms() {
        let filmRequest:NetworkServiceProtocol = Requests()
        filmRequest.getFilms { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let films):
                    self.listOfFilms = films
                    self.activityCircle.stopAnimating()
                    self.activityCircle.isHidden = true
                }
            }
        }
    }
    
    func setSelfView() {
        view.backgroundColor = .white
        navigationItem.title = Constants.navigationItemTitle
    }
    
    func setupFilmsTable() {
        filmsTable.delegate = self
        filmsTable.dataSource = self
        filmsTable.rowHeight = Constants.filmsTableRowHeight
        filmsTable.register(FilmCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    func setupActivityCircle() {
        activityCircle.center = view.center
        activityCircle.hidesWhenStopped = true
        activityCircle.style = .large
        activityCircle.startAnimating()
    }
}

// MARK: - Layout

private extension MainViewController {
    func layout() {
        filmsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        filmsTable.topAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.topAnchor),
                                        filmsTable.leftAnchor.constraint(
                                            equalTo: view.leftAnchor),
                                        filmsTable.rightAnchor.constraint(
                                            equalTo: view.rightAnchor),
                                        filmsTable.bottomAnchor.constraint(
                                            equalTo: view.bottomAnchor)])
    }
}

// MARK: - Constants

private extension MainViewController {
    enum Constants {
        static let cellIdentifier: String = "FilmCell"
        static let navigationItemTitle: String = "Сейчас в кино"
        static let filmsTableRowHeight: CGFloat = 200
    }
}

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
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Actions
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as! FilmCell
        
        let film = listOfFilms[indexPath.row]
        cell.set(film: film)
        
        return cell
    }
    
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
        
        getFilms()
        setSelfView()
        setupFilmsTable()
        
        layout()
    }
}

// MARK: - Setups Views

private extension MainViewController {
    func addViews() {
        view.addSubview(filmsTable)
    }
    
    func getFilms() {
        let filmRequest = FilmRequest()
        filmRequest.getFilms { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let films):
                self?.listOfFilms = films
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
}

// MARK: - Layout

private extension MainViewController {
    func layout() {
        filmsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        filmsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                        filmsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
                                        filmsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
                                        filmsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
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

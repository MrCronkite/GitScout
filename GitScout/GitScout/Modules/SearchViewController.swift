//
//  SearchViewController.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import SnapKit
import UIKit
import Combine

final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()

    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private var currentItems: [RepoCellModel] = []

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitScout"
        view.backgroundColor = UIColor(named: "GitScoutDarkGreen")
        setupSearchController()
        setupTableView()
        bindViewModel()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search repositories"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupTableView() {
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }

    private func render(_ state: SearchViewState) {
        switch state {
        case .idle:
            currentItems = []
            tableView.reloadData()
        case .loading:
            break // тут можно показать activity indicator
        case .loaded(let items):
            currentItems = items
            tableView.reloadData()
        case .empty:
            currentItems = []
            tableView.reloadData()
        case .error(let message):
            currentItems = []
            tableView.reloadData()
            print("Error: \(message)") // потом заменим на alert/empty state view
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.searchSubject.send(text)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseId, for: indexPath) as! RepoCell
        cell.configure(with: currentItems[indexPath.row])
        return cell
    }
}

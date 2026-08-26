//
//  FavoritesViewController.swift
//  GitScout
//
//  Created by Влад Шимченко on 26.08.2026.
//

import UIKit
import Combine
import SnapKit

final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private var cancellables = Set<AnyCancellable>()

    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private var currentItems: [RepoCellModel] = []

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = UIColor(named: "GitScoutDarkGreen")
        setupTableView()
        setupEmptyLabel()
        bindViewModel()
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

    private func setupEmptyLabel() {
        emptyLabel.text = "No favorites yet"
        emptyLabel.textColor = .lightGray
        emptyLabel.font = .systemFont(ofSize: 15)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true

        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.currentItems = items
                self?.tableView.reloadData()
                self?.emptyLabel.isHidden = !items.isEmpty
            }
            .store(in: &cancellables)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseId, for: indexPath) as! RepoCell
        cell.configure(with: currentItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.select(currentItems[indexPath.row])
    }
}

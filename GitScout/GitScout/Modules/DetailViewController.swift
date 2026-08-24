//
//  DetailViewController.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import UIKit
import SnapKit
import Combine


final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let avatarImageView = UIImageView()
    private let fullNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statsCard = StatsCardView()
    private let languageChip = ChipView()
    private let licenseChip = ChipView()
    private let tagsStack = UIStackView()
    private let openOnGitHubButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "GitScoutDarkGreen")
        setupLayout()
        configureInitial()
        bindViewModel()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }

        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalToSuperview().offset(-32)
        }

        avatarImageView.layer.cornerRadius = 32
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .darkGray
        avatarImageView.snp.makeConstraints { $0.width.height.equalTo(64) }

        fullNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        fullNameLabel.textColor = .white
        fullNameLabel.numberOfLines = 0

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0

        tagsStack.axis = .horizontal
        tagsStack.spacing = 8
        tagsStack.addArrangedSubview(languageChip)
        tagsStack.addArrangedSubview(licenseChip)

        openOnGitHubButton.setTitle("Open on GitHub", for: .normal)
        openOnGitHubButton.setTitleColor(.white, for: .normal)
        openOnGitHubButton.backgroundColor = UIColor(named: "GitScoutAccentGreen")
        openOnGitHubButton.layer.cornerRadius = 10
        openOnGitHubButton.snp.makeConstraints { $0.height.equalTo(44) }
        openOnGitHubButton.addTarget(self, action: #selector(openOnGitHubTapped), for: .touchUpInside)

        [avatarImageView, fullNameLabel, descriptionLabel, statsCard, tagsStack, loadingIndicator, openOnGitHubButton]
            .forEach { contentStack.addArrangedSubview($0) }
    }

    private func configureInitial() {
        fullNameLabel.text = viewModel.initialRepo.fullName
        if let url = URL(string: viewModel.initialRepo.owner.avatarUrl) {
            loadAvatar(from: url)
        }
        loadingIndicator.startAnimating()
        statsCard.isHidden = true
        tagsStack.isHidden = true
        openOnGitHubButton.isHidden = true
    }

    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }

    private func render(_ state: DetailViewState) {
        switch state {
        case .loading:
            break
        case .loaded(let detail):
            loadingIndicator.stopAnimating()
            descriptionLabel.text = detail.description ?? "No description provided"
            statsCard.configure(with: detail)
            statsCard.isHidden = false

            languageChip.configure(text: detail.language, isHidden: detail.language == nil)
            licenseChip.configure(text: detail.license?.name, isHidden: detail.license == nil)
            tagsStack.isHidden = false

            openOnGitHubButton.isHidden = false
        case .error(let message):
            loadingIndicator.stopAnimating()
            descriptionLabel.text = "Failed to load: \(message)"
        }
    }

    @objc private func openOnGitHubTapped() {
        guard case .loaded(let detail) = viewModel.state,
              let url = URL(string: detail.htmlUrl) else { return }
        UIApplication.shared.open(url)
    }

    private func loadAvatar(from url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.avatarImageView.image = image
            }
            .store(in: &cancellables)
    }
}

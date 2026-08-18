//
//  RepoCell.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import UIKit
import Combine
import SnapKit

// RepoCell.swift
final class RepoCell: UITableViewCell {
    static let reuseId = "RepoCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let starsLabel = UILabel()
    private let languageLabel = UILabel()
    private var imageCancellable: AnyCancellable?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageCancellable?.cancel()
        avatarImageView.image = nil
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "GitScoutDarkGreen")
        selectionStyle = .none

        avatarImageView.layer.cornerRadius = 8
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .darkGray

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .white

        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 2

        starsLabel.font = .systemFont(ofSize: 12)
        starsLabel.textColor = .systemYellow

        languageLabel.font = .systemFont(ofSize: 12)
        languageLabel.textColor = .systemGreen

        [avatarImageView, nameLabel, descriptionLabel, starsLabel, languageLabel].forEach {
            contentView.addSubview($0)
        }

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(48)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.equalTo(avatarImageView)
            make.trailing.equalToSuperview().offset(-12)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        starsLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(-12)
        }

        languageLabel.snp.makeConstraints { make in
            make.leading.equalTo(starsLabel.snp.trailing).offset(12)
            make.centerY.equalTo(starsLabel)
        }
    }

    func configure(with model: RepoCellModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        starsLabel.text = "⭐ \(model.stars)"
        languageLabel.text = model.language

        guard let url = model.avatarUrl else { return }
        imageCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.avatarImageView.image = image
            }
    }
}

//
//  StatsCardView.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import UIKit
import SnapKit

final class StatsCardView: UIView {
    private let starsItem = StatItemView()
    private let forksItem = StatItemView()
    private let watchersItem = StatItemView()
    private let issuesItem = StatItemView()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = UIColor(named: "GitScoutCardGreen")
        layer.cornerRadius = 12

        let stack = UIStackView(arrangedSubviews: [starsItem, forksItem, watchersItem, issuesItem])
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    func configure(with detail: GitHubRepoDetail) {
        starsItem.configure(value: format(detail.stargazersCount), title: "Stars")
        forksItem.configure(value: format(detail.forksCount), title: "Forks")
        watchersItem.configure(value: format(detail.watchersCount), title: "Watchers")
        issuesItem.configure(value: format(detail.openIssuesCount), title: "Issues")
    }

    private func format(_ count: Int) -> String {
        count >= 1000 ? String(format: "%.1fk", Double(count) / 1000) : "\(count)"
    }
}

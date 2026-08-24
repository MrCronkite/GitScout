//
//  StatItemView.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import SnapKit
import UIKit

final class StatItemView: UIView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: 11)
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func configure(value: String, title: String) {
        valueLabel.text = value
        titleLabel.text = title
    }
}

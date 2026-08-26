//
//  SplashViewController.swift
//  GitScout
//
//  Created by Влад Шимченко on 26.08.2026.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "GitScoutDarkGreen")
        setupUI()
    }

    private func setupUI() {
        logoImageView.image = UIImage(systemName: "chevron.left.forwardslash.chevron.right")
        logoImageView.tintColor = UIColor(named: "GitScoutAccentGreen")
        logoImageView.contentMode = .scaleAspectFit

        titleLabel.text = "GitScout"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [logoImageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
    }
}

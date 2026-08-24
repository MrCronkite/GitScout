//
//  ChipView.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import UIKit
import SnapKit


final class ChipView: UIView {
    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "GitScoutCardGreen")
        layer.cornerRadius = 8
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(text: String?, isHidden: Bool) {
        label.text = text
        self.isHidden = isHidden
    }
}

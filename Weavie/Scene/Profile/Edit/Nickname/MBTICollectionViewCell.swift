//
//  MBTICollectionViewCell.swift
//  Weavie
//
//  Created by 정인선 on 2/7/25.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: BaseCollectionViewCell {
    private let label = UILabel()
    override var isSelected: Bool {
        didSet {
            updateState()
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentView.layer.cornerRadius = self.frame.width / 2
        contentView.layer.borderColor = UIColor.tertiaryBackground.cgColor
        contentView.layer.borderWidth = 1
        
        label.textColor = .tertiaryBackground
        label.font = Resource.SystemFont.semibold15
        label.textAlignment = .center
    }
}

extension MBTICollectionViewCell {
    func configureContent(text: String) {
        label.text = text
    }
    
    func updateState() {
        if isSelected {
            contentView.backgroundColor = .tint
            contentView.layer.borderColor = UIColor.tint.cgColor
            label.textColor = .white
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.borderColor = UIColor.tertiaryBackground.cgColor
            label.textColor = .tertiaryBackground
        }
    }
}

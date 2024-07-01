//
//  TitleStackView.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 28.02.24.
//

import UIKit

class TitleStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()
    {
        axis = .horizontal
        alignment = .center
        spacing = 5
        addArrangedSubview(imageView)
        addArrangedSubview(titleLabel)
    }
    
    lazy var titleLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont(name: "Rockwell-Bold", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        //label.backgroundColor = .blue
        
        let attributedString = NSMutableAttributedString(string: "FBI Wanted List")
        let baselineAdjustment = NSNumber(value: -4)
        attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: baselineAdjustment, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageView: UIImageView =
    {
        let imageWidth: CGFloat = 60
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageWidth)))
        imageView.image = UIImage(named: "fbi.png")
        //imageView.backgroundColor = .purple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: imageWidth)
        ])
        imageView.layer.cornerRadius = imageView.bounds.height * 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
}

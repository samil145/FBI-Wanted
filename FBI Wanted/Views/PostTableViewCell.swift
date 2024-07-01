//
//  PostTableViewCell.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 23.06.24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostCell"
    
    
    let stackView: FBIPostStackView =
    {
        let view = FBIPostStackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 25
//        view.layer.borderWidth = 0.5
//        view.layer.masksToBounds = true
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.topBackgroundMain.cgColor,
            UIColor.bottomBackgroundMain.cgColor
        ]
        layer.locations = [0.1, 0.8]
//        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return layer
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = stackView.bounds
        gradientLayer.cornerRadius = stackView.layer.cornerRadius
        
    }
    
    
    
    func setupUI()
    {
//        let stackView = FBIPostStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 25
        stackView.layer.borderWidth = 0.5
        stackView.layer.masksToBounds = true
        stackView.layer.borderWidth = 1
        
        if gradientLayer.superlayer == nil {
            stackView.layer.insertSublayer(gradientLayer, at: 0)
        }
//        
//        gradientLayer.colors = [
//            UIColor.topBackgroundMain.cgColor,
//            UIColor.bottomBackgroundMain.cgColor
//        ]
//        //      gradientLayer.locations = [0.0, 0.5, 1.0]
//        gradientLayer.locations = [0.5, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//
//        stackView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.addSubview(stackView)
    }
    
    func configureCell() {
        // Force the layout to update immediately
        setNeedsLayout()
        layoutIfNeeded()
        
        // Ensure gradient layer is updated
        gradientLayer.frame = stackView.bounds
    }
}



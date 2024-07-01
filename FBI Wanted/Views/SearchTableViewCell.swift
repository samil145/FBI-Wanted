//
//  SearchTableViewCell.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 21.03.24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchCell"
    
    var ImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var title: UILabel =
    {
        let label = UILabel()
        label.font = UIFont(name: "Rockwell-Regular", size: 15)
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI()
    {
        contentView.addSubview(ImageView)
        contentView.addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    private func setConstraints()
    {
        NSLayoutConstraint.activate([
            ImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            ImageView.widthAnchor.constraint(equalTo: ImageView.heightAnchor),
            ImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            ImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: ImageView.trailingAnchor, constant: 10),
            title.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

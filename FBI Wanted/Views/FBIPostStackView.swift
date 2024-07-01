//
//  FBIPostStackView.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 03.03.24.
//

import UIKit

class FBIPostStackView: UIStackView {
    
    lazy var horizontalStack: UIStackView =
    {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
        return stackView
    }()
    
    lazy var leadingLabelStack: UIStackView =
    {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        //stackView.backgroundColor = .blue
        
        return stackView
    }()
    
    lazy var trailingLabelStack: UIStackView =
    {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        //stackView.backgroundColor = .brown
        
        return stackView
    }()
    
    lazy var photoContainer: UIView =
    {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.widthAnchor.constraint(equalToConstant: 350).isActive = true
        //view.backgroundColor = .gray
        view.addSubview(photoOuterContainer)
        
        NSLayoutConstraint.activate([
            photoOuterContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoOuterContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoOuterContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
            photoOuterContainer.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        return view
    }()
    
    lazy var photoOuterContainer: UIView =
    {
        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(photo)
    
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: outerView.topAnchor),
            photo.bottomAnchor.constraint(equalTo: outerView.bottomAnchor),
            photo.leadingAnchor.constraint(equalTo: outerView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: outerView.trailingAnchor)
        ])
        return outerView
    }()
    
    lazy var photo: UIImageView =
    {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "person.crop.circle")!
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // Leading Labels
    lazy var nameLabelLeading: UILabel = leadingLabelInitializer(labelName: "NAME")
    lazy var ageLabelLeading: UILabel = leadingLabelInitializer(labelName: "AGE")
    lazy var sexLabelLeading: UILabel = leadingLabelInitializer(labelName: "SEX")
    lazy var weightLabelLeading: UILabel = leadingLabelInitializer(labelName: "WEIGHT")
    lazy var heightLabelLeading: UILabel = leadingLabelInitializer(labelName: "HEIGHT")
    lazy var nationalityLabelLeading: UILabel = leadingLabelInitializer(labelName: "NATION.")
    
    // Trailing Labels
    lazy var nameLabelTrailing: UILabel = trailingLabelInitializer()
    lazy var ageLabelTrailing: UILabel = trailingLabelInitializer()
    lazy var sexLabelTrailing: UILabel = trailingLabelInitializer()
    lazy var weightLabelTrailing: UILabel = trailingLabelInitializer()
    lazy var heightLabelTrailing: UILabel = trailingLabelInitializer()
    lazy var nationalityLabelTrailing: UILabel = trailingLabelInitializer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureStackView()
    }
    

    private func configureStackView()
    {
        axis = .vertical
        distribution = .fill
        alignment = .fill
        spacing = 5
        
        let leadingLabels = [nameLabelLeading, ageLabelLeading, sexLabelLeading, weightLabelLeading, heightLabelLeading, nationalityLabelLeading]
        let trailingLabels = [nameLabelTrailing, ageLabelTrailing, sexLabelTrailing, weightLabelTrailing, heightLabelTrailing, nationalityLabelTrailing]
        
        leadingLabels.forEach{ leadingLabelStack.addArrangedSubview($0)}
        trailingLabels.forEach{ trailingLabelStack.addArrangedSubview($0)}
        
        horizontalStack.addArrangedSubview(leadingLabelStack)
        horizontalStack.addArrangedSubview(trailingLabelStack)
        
        addArrangedSubview(photoContainer)
        addArrangedSubview(horizontalStack)
        
        //backgroundColor = UIColor.postBackgroundMain//UIColor(rgb: 0x006DA4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 450),
            widthAnchor.constraint(equalToConstant: 350),
            centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        ])
        
//        guard let superview else { return }
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        gradientLayer.colors = [
//            UIColor.black.cgColor,
//            UIColor.postBackgroundMain.cgColor
//        ]
//        //      gradientLayer.locations = [0.0, 0.5, 1.0]
//        gradientLayer.locations = [0.5, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//
//        self.layer.insertSublayer(gradientLayer, at: 0)

        //createShadow()
    }
    
    
}

// Functions For Configuration of Labels
extension FBIPostStackView
{
    public func configureDetails(name: String, age: String, sex: String, weight: String, height: String, nationality: String)
    {
        nameLabelTrailing.text = name.capitalized
        ageLabelTrailing.text = age
        sexLabelTrailing.text = sex
        weightLabelTrailing.text = weight
        heightLabelTrailing.text = height
        nationalityLabelTrailing.text = nationality
    
        wrappingNameText()
        editingWeightText()
    }
    
    private func wrappingNameText()
    {
        nameLabelTrailing.preferredMaxLayoutWidth = 200
        
        let textSize = nameLabelTrailing.text?.size(withAttributes: [NSAttributedString.Key.font: nameLabelTrailing.font as Any])
        
        if let textSize = textSize, textSize.width > 200 {
            
            var adjustedText = nameLabelTrailing.text
            while let lastSpace = adjustedText?.lastIndex(of: " "), lastSpace > adjustedText!.startIndex {
                
                adjustedText?.removeSubrange(lastSpace...)
                let adjustedSize = adjustedText?.size(withAttributes: [NSAttributedString.Key.font: nameLabelTrailing.font as Any])
                
                if adjustedSize?.width ?? 0 <= 200 {
                    break
                }
            }
            nameLabelTrailing.text = adjustedText
        }
    }
    
    private func editingWeightText()
    {
        if let labelText = weightLabelTrailing.text, let range = labelText.lowercased().range(of: "approximately")
        {
            let updatedText = labelText.replacingCharacters(in: range, with: "")
            weightLabelTrailing.text = updatedText
        }
    }
    
    private func trailingLabelInitializer() -> UILabel
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rockwell-Regular", size: 17)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }
    
    private func leadingLabelInitializer(labelName: String) -> UILabel
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rockwell-Bold", size: 15)
        label.text = labelName
        label.textAlignment = .left
        label.textColor = .white
        return label
    }
    
    internal func createShadow()
    {
        photoOuterContainer.clipsToBounds = false
        photoOuterContainer.backgroundColor = .clear
        photoOuterContainer.layer.shadowColor = UIColor.black.cgColor
        photoOuterContainer.layer.shadowOpacity = 1
        photoOuterContainer.layer.shadowOffset = CGSize.zero
        photoOuterContainer.layer.shadowRadius = 10
        photoOuterContainer.layer.shadowPath = UIBezierPath(roundedRect: photoOuterContainer.bounds, cornerRadius: 10).cgPath
    }
}


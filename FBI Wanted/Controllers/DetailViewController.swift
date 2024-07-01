//
//  DetailViewController.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 17.03.24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont(name: "Rockwell-Bold", size: 30)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        //label.backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionField: UITextView =
    {
        let description = UITextView()
        description.font = UIFont(name: "Rockwell-Regular", size: 18)
        description.backgroundColor = .clear
        description.textColor = .white
        description.textAlignment = .left
        description.isEditable = false
        description.isScrollEnabled = true
        description.showsVerticalScrollIndicator = false
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    
    var imageURL: String?
    var name: String?
    {
        didSet
        {
            nameLabel.text = name
            nameLabel.setLineSpacing(lineSpacing: 5)
        }
    }
    var details: String?
    {
        didSet
        {
            descriptionField.text = details
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Detailed Information"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.backgroundColor = .clear//UIColor(rgb: 0x161618)
        //self.navigationController?.setStatusBar(backgroundColor: UIColor(rgb: 0x161618))
        backButtonModifing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgb: 0x161618)
        
        view.addSubview(nameLabel)
        view.addSubview(imageView)
        view.addSubview(descriptionField)
        
        view.bringSubviewToFront(nameLabel)
        
        setConstraints()
        
        loadImageFromURL(urlString: imageURL)
        {
            image in
            if let image = image
            {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradientLayer()
    }
    
    private func addGradientLayer()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(rgb: 0x161618).cgColor]
        gradientLayer.locations = [0.7, 1.0]
        imageView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func setConstraints()
    {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 370),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -80),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            nameLabel.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -10),
            descriptionField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func backButtonModifing()
    {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonTapped()
    {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        
        self.navigationController?.popToRootViewController(animated: true)
        //navigationController?.popViewController(animated: true)
    }
    
//    private func backButtonModifing()
//    {
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium))
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium))
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.backItem?.title = ""
//    }
    
    private func loadImageFromURL(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString else {return}
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
}

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

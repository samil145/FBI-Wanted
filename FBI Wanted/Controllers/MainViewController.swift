//
//  ViewController.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 25.02.24.
//

import UIKit


class MainViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var cellCount = 0
    
    var imagesLoadingCount = 0
    
    let personImage = UIImage(systemName: "person.crop.circle")!
    
    var itemsFBI = [FBIItem]()
    
    let tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.backgroundColor = nil
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var titleStackView: TitleStackView = 
    {
        let titleStackView = TitleStackView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 65.0)))
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        return titleStackView
        
    }()
    
    lazy var headerView: UIView =
    {
        let headerView = UIView()//(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 65.0)))
        headerView.addSubview(titleStackView)
        headerView.backgroundColor = .clear
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    var searchButton: UIButton =
    {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.searchButtonBackground//UIColor(rgb: 0x003554)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .medium)), for: .normal)
        button.imageView?.tintColor = .white
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [UIColor.topBackgroundMain.cgColor, UIColor.bottomBackgroundMain.cgColor]//[UIColor(rgb: 0x006DA4).cgColor, UIColor(rgb: 0x032030).cgColor]
//        view.layer.addSublayer(gradientLayer)
        //view.backgroundColor = UIColor(rgb: 0x032030)
        
        //tableView.frame = view.frame
        view.addSubview(tableView)
        view.addSubview(headerView)
        view.addSubview(searchButton)
        view.addSubview(activityIndicator)
    
        setTableViewConstraints()
        
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
    
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = nil
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.tintColor = .clear
        //navigationController?.navigationBar.backgroundColor = .clear//UIColor(rgb: 0x032030)
        //navigationController?.setStatusBar(backgroundColor: UIColor(rgb: 0x032030))
        navigationController?.navigationBar.shadowImage = UIImage()
        //tableView.tableHeaderView = tableHeaderView
        
        //view.backgroundColor = .systemBackground
        
        FBIApiCall()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsFBI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") else {return UITableViewCell()}
        cell.backgroundColor = .clear//UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        loadImageFromURL(urlString: itemsFBI[indexPath.row].getImage)
        {
            image in
            
            if let image = image
            {
                DispatchQueue.main.async {
                    cell.stackView.photo.image = image
                    cell.stackView.createShadow()
                    self.cellCount += 1
                }
            }
        }

        cell.stackView.configureDetails(name: itemsFBI[indexPath.row].getName, age: itemsFBI[indexPath.row].getAge, sex: itemsFBI[indexPath.row].getSex, weight: itemsFBI[indexPath.row].getWeight, height: itemsFBI[indexPath.row].getHeight, nationality: itemsFBI[indexPath.row].getNationality)
        
        cell.selectionStyle = .none
    
        cell.configureCell()
        
//        if cellCount == tableView.visibleCells.count
//        {
//            self.tableView.isHidden = false
//            self.activityIndicator.isHidden = true
//            self.activityIndicator.stopAnimating()
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = DetailViewController()
        detailController.imageURL = itemsFBI[indexPath.row].getImage
        detailController.name = itemsFBI[indexPath.row].getName
        detailController.details = itemsFBI[indexPath.row].cleanDetails
        navigationController?.pushViewController(detailController, animated: true)
    }
}

// Functions of Networking
extension MainViewController
{
    
    func FBIApiCall()
    {
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        guard let topTenUrl = URL(string: "https://api.fbi.gov/@wanted?sort_on=modified&sort_order=desc&poster_classification=ten") else {
            print("invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: topTenUrl)
        {
            data, response, error in
            
            guard let data = data, error == nil else {return}
            
            var result: FBIResponse?
            
            do
            {
                result = try JSONDecoder().decode(FBIResponse.self, from: data)
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            guard let json = result else {return}
            
            DispatchQueue.main.async {
                self.itemsFBI = json.items
                self.tableView.reloadData()
            }
        }.resume()
         
    }
    
    
    func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        imagesLoadingCount += 1

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                // Decrement the loading count and check if all images are loaded
                DispatchQueue.main.async {
                    self.imagesLoadingCount -= 1
                    if self.imagesLoadingCount == 0 {
                        self.tableView.isHidden = false
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            
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
    
    private func setTableViewConstraints()
    {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 65.0),
            
            titleStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            titleStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    @objc func search()
    {
        let searchController = SearchViewController()
//        searchController.searchController.isActive = false
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchButton.layer.cornerRadius = searchButton.bounds.size.width/2
        searchButton.layer.borderWidth = 1
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.topBackgroundMain2.cgColor,
            UIColor.bottomBackgroundMain2.cgColor
        ]
        //      gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        view.layer.insertSublayer(gradientLayer, at: 0)

        view.bringSubviewToFront(activityIndicator)
        

    }
    
    
}

extension UINavigationController {
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

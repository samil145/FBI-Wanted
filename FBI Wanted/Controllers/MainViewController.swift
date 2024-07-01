//
//  ViewController.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 25.02.24.
//

import UIKit


class ViewController: UIViewController {
    
    let personImage = UIImage(systemName: "person.crop.circle")!
    
    var itemsFBI = [FBIItem]()
    
    let tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBIApiCall()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(rgb: 0x006DA4).cgColor, UIColor(rgb: 0x032030).cgColor]
        view.layer.addSublayer(gradientLayer)
        //view.backgroundColor = UIColor(rgb: 0x032030)
        
        //tableView.frame = view.frame
        view.addSubview(tableView)
        view.addSubview(headerView)
        
        setTableViewConstraints()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = nil
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.tintColor = .clear
        //navigationController?.navigationBar.backgroundColor = .clear//UIColor(rgb: 0x032030)
        //navigationController?.setStatusBar(backgroundColor: UIColor(rgb: 0x032030))
        navigationController?.navigationBar.shadowImage = UIImage()
        //tableView.tableHeaderView = tableHeaderView
        
        //view.backgroundColor = .systemBackground
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsFBI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {return UITableViewCell()}
        cell.backgroundColor = .clear//UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        let stackView = FBIPostStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 25
        stackView.layer.borderWidth = 0.5
        
        loadImageFromURL(urlString: itemsFBI[indexPath.row].getImage)
        {
            image in
            
            if let image = image
            {
                DispatchQueue.main.async {
                    stackView.photo.image = image
                    stackView.createShadow()
                }
            }
        }
        
        stackView.configureDetails(name: itemsFBI[indexPath.row].getName, age: itemsFBI[indexPath.row].getAge, sex: itemsFBI[indexPath.row].getSex, weight: itemsFBI[indexPath.row].getWeight, height: itemsFBI[indexPath.row].getHeight, nationality: itemsFBI[indexPath.row].getNationality)
        
        cell.addSubview(stackView)
        
        cell.selectionStyle = .none
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}

// Functions of Networking
extension ViewController
{
    func FBIApiCall()
    {
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

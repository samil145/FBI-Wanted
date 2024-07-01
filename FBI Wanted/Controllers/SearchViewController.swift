//
//  SearchViewController.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 21.03.24.
//

import UIKit

class SearchViewController: UIViewController, UIScrollViewDelegate {
    
    //let imageCache = NSCache<NSString, UIImage>()
    
    var itemsFBI = [FBIItem]()
    var filteredItems = [FBIItem]()
    var filteredItemsAll = [FBIItem]()
    var currentIndex = 0
    var cellCount = 0
    var isPaginating = false
    var dataEmpty = false
    var isScrollFetching = false
    
    var imagesLoadingCount = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var noResult: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "No Result"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setupSearchController()
        backButtonModifing()
        
//        if !isBeingPresented && !isMovingToParent {
//        }
//        else
//        {
//            searchController.isActive = false
//        }
        
        resetSearchController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.shared.windows.first?.layer.speed = 0.1
        view.backgroundColor = UIColor(rgb: 0x161618)
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        activityIndicator.isHidden = true
        
        searchController.searchBar.text = ""
        itemsFBI.removeAll()
        filteredItems.removeAll()
        tableView.isHidden = false
        
        for i in 1...10 {
            FBIApiCall(url_pageSize: 828, url_pageNumber: i)
        }
        setupSearchController()
        backButtonModifing()
        configureTableView()
        self.hideKeyboardWhenTappedAround()
    }
    

    
    private func setupSearchController()
    {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Criminals"
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false

    }
    
    private func resetSearchController() {
        searchController.isActive = false
        searchController.searchBar.text = ""
        filteredItems.removeAll()
        tableView.reloadData()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonTapped()
    {
        resetSearchController()
        navigationController?.popViewController(animated: true)
    }
    
    private func configureTableView()
    {
        view.addSubview(tableView)
        view.addSubview(noResult)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noResult.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResult.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.layoutIfNeeded()
            completion()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = inSearchMode(searchController)
        return inSearchMode ? filteredItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.ImageView.image = UIImage(named: "fbi")
        
        let inSearchMode = inSearchMode(searchController)
        let item = inSearchMode ? self.filteredItems[indexPath.row] : self.itemsFBI[indexPath.row]
        
//        if let cachedImage = imageCache.object(forKey: item.getImage as NSString) {
//            cell.ImageView.image = cachedImage
//        } else {
//            cell.ImageView.image = UIImage(named: "fbi")
//            loadImageFromURL(urlString: item.getImage) { image in
//                if let image = image {
//                    DispatchQueue.main.async {
//                        cell.ImageView.image = image
//                    }
//                }
//            }
//        }
        
        loadImageFromURL(urlString: item.getImage)
        {
            image in
            if let image = image
            {
                DispatchQueue.main.async {
                    cell.ImageView.image = image
                    
                    self.cellCount += 1
                    //print("cellCount \(self.cellCount)")
                    
//                    if cell == tableView.visibleCells.last
//                    {
//                        self.tableView.isHidden = false
//                        self.activityIndicator.isHidden = true
//                        self.activityIndicator.stopAnimating()
//                    }
                }
            }
        }
        
        
        cell.title.text = item.getName.capitalized
        
        
        
//        if cellCount == tableView.visibleCells.count
//        {
//            self.tableView.isHidden = false
//            self.activityIndicator.isHidden = true
//            self.activityIndicator.stopAnimating()
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = DetailViewController()
        detailController.imageURL = filteredItems[indexPath.row].getImage
        detailController.name = filteredItems[indexPath.row].getName
        detailController.details = filteredItems[indexPath.row].cleanDetails
        
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        navigationController?.pushViewController(detailController, animated: true)
        resetSearchController()
    }
    
    func createSpinnerFooter() -> UIView
    {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height)
        {
            guard !isPaginating && !dataEmpty && !isScrollFetching else {
                return
            }
            
            self.tableView.tableFooterView = createSpinnerFooter()
            
            self.isScrollFetching = true
            
            fetchData(pagination: true) { [weak self] result in
                
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                
                switch result {
                case .success(let newIndexPaths):
                    //self?.filteredItems.append(contentsOf: data)
                    if !newIndexPaths.isEmpty
                    {
                        DispatchQueue.main.async {
                            //self?.tableView.reloadData()
                            self?.tableView.insertRows(at: newIndexPaths, with: .automatic)
                            self?.isScrollFetching = false
                        }
                    }
                    else
                    {
                        self?.dataEmpty = true
                        DispatchQueue.main.async {
                            self?.isScrollFetching = false
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.isScrollFetching = false
                    }
                }
            }
            
        }
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {

//        self.tableView.isHidden = true
//        self.activityIndicator.isHidden = false
//        self.activityIndicator.startAnimating()
        
        updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func inSearchMode(_ searchController: UISearchController) -> Bool
    {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    func updateSearchController(searchBarText: String?)
    {
        filteredItemsAll = itemsFBI
        cellCount = 0
        currentIndex = 0
        dataEmpty = false
        isPaginating = false
        isScrollFetching = false
        
        if let searchText = searchBarText?.lowercased()
        {
            guard !searchText.isEmpty else 
            {
                filteredItemsAll.removeAll()
                filteredItems.removeAll()
                tableView.reloadData()
                return
            }
            
            self.tableView.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            filteredItemsAll = filteredItemsAll.filter({$0.getName.lowercased().contains(searchText)})
        
            noResult.isHidden = !filteredItemsAll.isEmpty
            
            if (filteredItemsAll.isEmpty)
            {
                self.tableView.isHidden = false
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
            let maxIndex = min(filteredItemsAll.count, 12)
            filteredItems = Array(filteredItemsAll[0..<maxIndex])
            currentIndex += 1
        }
        
        print("cellCount \(self.filteredItems.count)")
        
        tableView.reloadData()
    }
    
    func fetchData(pagination: Bool = false, completion: @escaping (Result<[IndexPath], Error>) -> Void)
    {
        print("fetchData called. Pagination: \(pagination), isPaginating: \(isPaginating)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (pagination ? 3 : 2), execute: {
            if pagination
            {
                self.isPaginating = true
                print("Set isPaginating to true")
            }
            
//            if (self.filteredItems.count != self.filteredItemsAll.count)
//            {
//                self.currentIndex += 1
//                let maxIndex = min(self.filteredItemsAll.count, (self.currentIndex) * 15)
//                completion(.success(pagination ? Array(self.filteredItemsAll[((self.currentIndex - 1) * 15)..<maxIndex]) : []))
//                //filteredItems = Array(filteredItemsAll[0..<maxIndex])
//            }
//            else
//            {
//                completion(.success([]))
//            }
            
            if self.filteredItems.count < self.filteredItemsAll.count {
                let startIndex = self.filteredItems.count
                let endIndex = min(self.filteredItemsAll.count, startIndex + 12)
                let newItems = Array(self.filteredItemsAll[startIndex..<endIndex])
                
                self.filteredItems.append(contentsOf: newItems)
                let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                
                completion(.success(newIndexPaths))
            } else {
                completion(.success([]))
            }
        
            if pagination
            {
                self.isPaginating = false
                print("Set isPaginating to false")
            }
        })
    }
}


// Network
extension SearchViewController
{
    func FBIApiCall(url_pageSize: Int, url_pageNumber: Int)
    {
        guard let url = URL(string: "https://api.fbi.gov/@wanted?pageSize=\(url_pageSize)&page=\(url_pageNumber)&sort_on=modified&sort_order=desc&person_classification=main") else {
            return
        }
        
        URLSession.shared.dataTask(with: url)
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
                self.itemsFBI += json.items
                if (url_pageNumber == 10)
                {
                    self.updateSearchController(searchBarText: self.searchController.searchBar.text)
                    
                }
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
    
//    func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
//        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
//            completion(cachedImage)
//            return
//        }
//
//        guard let url = URL(string: urlString) else {
//            completion(nil)
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(nil)
//                return
//            }
//
//            if let image = UIImage(data: data) {
//                self.imageCache.setObject(image, forKey: urlString as NSString)
//                completion(image)
//            } else {
//                completion(nil)
//            }
//        }.resume()
//    }

    

}


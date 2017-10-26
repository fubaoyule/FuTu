//
//  CustomSearchViewController.swift
//  FuTu
//
//  Created by Administrator1 on 26/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class CustomSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {
    
    //@IBOutlet weak var tblSearchResults: UITableView!
    var tblSearchResults: UITableView!
    
    var dataArray = [String]()
    
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tlPrint(message: "CustomSearchViewController viewDidLoad")
        
        tblSearchResults = UITableView(frame: self.view.frame, style: .grouped)
        tblSearchResults.backgroundColor = UIColor.white
        self.view.addSubview(tblSearchResults)
        
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        
        loadListOfCountries()
        
        // Uncomment the following line to enable the default search controller.
        // configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
        configureCustomSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: Custom functions
    
    func loadListOfCountries() {
        // Specify the path to the countries list file.
        let pathToFile = Bundle.main.path(forResource: "serviceAnswerText", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            let countriesString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            // Append the countries from the string to the dataArray array by breaking them using the line change character.
            dataArray = countriesString.components(separatedBy: "\n")
            
            // Reload the tableview.
            tblSearchResults.reloadData()
        }
    }
    
    func configureSearchController() {
        tlPrint(message: "*******   configureSearchController   *******")
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        tlPrint(message: "*******   configureCustomSearchController   *******")
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: adapt_W(width: 40), y: 20.0, width: tblSearchResults.frame.size.width - adapt_W(width: 120), height: 50.0), searchBarFont: UIFont.systemFont(ofSize: fontAdapt(font: 14)), searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "请输入问题关键字，如：取款"
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
        customSearchController.customSearchBar.customSearchControllerdelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country as NSString
            
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    func didClickBackButton() {
        tlPrint(message: "didClickBackButton")
        let nav = self.navigationController?.popViewController(animated: true)
        tlPrint(message: "nav:\(nav)")
    }
    
    func didClickQuesButton() {
        tlPrint(message: "didCleckQuesButton")
    }
    
}


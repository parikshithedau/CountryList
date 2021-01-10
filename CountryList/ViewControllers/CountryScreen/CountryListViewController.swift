//
//  CountryListViewController.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit
import SDWebImage

class CountryListViewController: UIViewController {

    @IBOutlet weak var tblCountryList: UITableView!
    
    private var countryListViewModel : CountryListViewModel!
    
    private var dataSource : CountryListTableViewDataSource<CountryListTableCell,CountryListModel>!
    
    private var loader: PHLoader!
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setLayoutAndDesigns()
        
        initViewModelForUIUpdate()
        
        updateCountryList()
    }
        
    // Initialize ViewModel
    func initViewModelForUIUpdate(){
        
        self.countryListViewModel = CountryListViewModel()
        self.countryListViewModel.bindCountryListViewModelToController = { [weak self] in
            
            guard let self = self else { return }
            
            self.showLoader(false)
            
            self.updateDataSource()
            
            self.removeRefreshControl()
        }
    }
    
    // Fetch country List
    @objc func updateCountryList() {
        
        showLoader(true)
        self.countryListViewModel.fetchCountryList(completion: { [weak self] error in
            
            guard let self = self else { return }
            
            if error != nil {
                
                self.showLoader(false)
                
                self.showErrorAlert(error: error!)
            }
        })
    }
    
    // Update TableView List
    func updateDataSource() {
        
        if self.countryListViewModel.arrCountries.count == 0 {
            
            showEmptyAlert(msg: StringConstants.errEmptyCountry)
            
            return
        }
        
        self.dataSource = nil
        
        self.dataSource = CountryListTableViewDataSource(cellIdentifier: "CountryListTableCell", items: self.countryListViewModel.arrCountries, configureCell: { (cell, country) in
            
            cell.setDetails(country)
        })
        
        self.dataSource.didSelect = { [weak self] country, indexPath in
            
            guard let self = self else { return }
            
            self.goToProvincesScreen(country)
        }
        
        DispatchQueue.main.async {
            
            self.tblCountryList.dataSource = self.dataSource
            self.tblCountryList.delegate = self.dataSource
            self.tblCountryList.reloadData()
        }
    }
    
    // Show/Hide Loader
    func showLoader(_ show: Bool) {
        
        if show {
            
            loader = PHLoader()
            loader?.showIn(view: self.view)
        }
        else {
            
            loader?.hide()
        }
    }
}

// MARK: - Utility Methods
extension CountryListViewController {
    
    func setLayoutAndDesigns() {
        
        self.navigationItem.title = StringConstants.countryList
        
        tblCountryList.tableFooterView = UIView()
        
        addRefreshControl()
    }
    
    func showErrorAlert(error: ErrorFail<String>) {
                
        switch error {
        case .fail(let msg):
            Utility.alert(title: StringConstants.error, message: msg, delegate: self, buttons: nil, cancel: StringConstants.retry) { (btn) in
                
                self.updateCountryList()
            }
        }
    }
    
    func showEmptyAlert(msg: String) {
                
        Utility.alert(title: StringConstants.appName, message: msg, delegate: self, buttons: nil, cancel: StringConstants.ok) { (btn) in
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Refresh Control
extension CountryListViewController {
    
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateCountryList), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblCountryList.refreshControl = refreshControl
    }
    
    func removeRefreshControl() {
        
        refreshControl.endRefreshing()
    }
}

// MARK: - Navigations
extension CountryListViewController {
    
    func goToProvincesScreen(_ country: CountryListModel) {
        
        guard let countryId = country.id else {
            
            Utility.showToast(msg: StringConstants.errEmptyCountryId)
            
            return
        }
        
        let provinceVC = Storyboard.main.instantiateViewController(viewController: ProvincesViewController.self)
        
        provinceVC.countryID = countryId
        
        self.navigationController?.pushViewController(provinceVC, animated: true)
    }
}

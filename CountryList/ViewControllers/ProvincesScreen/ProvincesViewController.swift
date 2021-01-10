//
//  ProvincesViewController.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

class ProvincesViewController: UIViewController {
    
    @IBOutlet weak var tblProvinces: UITableView!
    
    private var provincesViewModel : ProvincesViewModel!
    
    private var dataSource : ProvincesTableViewDataSource<ProvincesTableCell,ProvincesModel>!
    
    private var loader: PHLoader!
    
    private var refreshControl: UIRefreshControl!
    
    var countryID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLayoutAndDesigns()
        
        initViewModelForUIUpdate()
        
        updateProvinces()
    }
    
    deinit {
        
        print("------------- provinces deinited -------------")
    }
    
    // Initialize ViewModel
    func initViewModelForUIUpdate(){
        
        self.provincesViewModel = ProvincesViewModel()
        self.provincesViewModel.countryID = countryID
        self.provincesViewModel.bindProvincesViewModelToController = { [weak self] in
            
            guard let self = self else { return }
            
            self.showLoader(false)
            
            self.updateDataSource()
            
            self.removeRefreshControl()
        }
    }
    
    // Fetch country List
    @objc func updateProvinces() {
        
        showLoader(true)
        self.provincesViewModel.fetchProvincesList(completion: { [weak self] error in
            
            guard let self = self else { return }
            
            if error != nil {
                
                self.showLoader(false)
                
                self.showErrorAlert(error: error!)
            }
        })
    }
    
    // Update TableView List
    func updateDataSource() {
        
        if self.provincesViewModel.arrProvinces.count == 0 {
            
            showEmptyAlert(msg: StringConstants.errEmptyProvinces)
            
            return
        }
        
        self.dataSource = nil
        
        self.dataSource = ProvincesTableViewDataSource(cellIdentifier: "ProvincesTableCell", items: self.provincesViewModel.arrProvinces, configureCell: { (cell, province) in
            
            cell.setDetails(province)
        })
        
        self.dataSource.didSelect = { [weak self] country, indexPath in
            
            guard let self = self else { return }
        }
        
        DispatchQueue.main.async {
            
            self.tblProvinces.dataSource = self.dataSource
            self.tblProvinces.delegate = self.dataSource
            self.tblProvinces.reloadData()
        }
    }
    
    // Show/Hide Loader
    func showLoader(_ show: Bool) {
        
        if show {
            
            loader = PHLoader()
            loader?.showIn(view: self.view?.window)
            
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        else {
            
            loader?.hide()

            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

// MARK: - Utility Methods
extension ProvincesViewController {
    
    func setLayoutAndDesigns() {
                
        self.navigationItem.title = StringConstants.provinces
        
        tblProvinces.tableFooterView = UIView()
        
        addRefreshControl()
    }
    
    func showErrorAlert(error: ErrorFail<String>) {
                
        switch error {
        case .fail(let msg):
            Utility.alert(title: StringConstants.error, message: msg, delegate: self, buttons: [StringConstants.goBack], cancel: StringConstants.retry) { (btn) in
                
                if btn == StringConstants.retry {
                    
                    self.updateProvinces()
                }
                else {
                    
                    self.navigationController?.popViewController(animated: true)
                }
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
extension ProvincesViewController {
    
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateProvinces), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblProvinces.refreshControl = refreshControl
    }
    
    func removeRefreshControl() {
        
        refreshControl.endRefreshing()
    }
}

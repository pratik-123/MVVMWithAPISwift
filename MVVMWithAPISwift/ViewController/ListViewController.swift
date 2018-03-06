//
//  ListViewController.swift
//  MVVMWithAPISwift
//
//  Created by Pratik Lad on 06/03/18.
//  Copyright © 2018 Pratik Lad. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    ///view model object
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
    }
    
    ///initial page settings
    func pageSetup()  {
        activityIndicator.startAnimating()
        tableViewSetup()
        ///API calling from viewmodel class
        viewModel.getListData()
        closureSetUp()
    }
    
    ///closure initialize
    func closureSetUp()  {
        viewModel.reloadList = { [weak self] ()  in
            ///UI chnages in main tread
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel.errorMessage = { [weak self] (message)  in
            DispatchQueue.main.async {
                print(message)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

///UITable view delegate methods
extension ListViewController : UITableViewDelegate,UITableViewDataSource{
    ///table view settings
    func tableViewSetup()  {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : ListTableViewCell.self)) as! ListTableViewCell
        
        let listObj = viewModel.arrayOfList[indexPath.row]
        ///Cell data settings
        cell.labelTitle.text = listObj.title
        cell.labelDescription.text = listObj.body
        
        ///cell background color change
        if ((indexPath.row % 2) != 0){
            cell.contentView.backgroundColor = UIColor.lightGray
        }else{
            cell.contentView.backgroundColor = UIColor.clear
        }
        
        return cell
    }
}

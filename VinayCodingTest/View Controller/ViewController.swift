//
//  ViewController.swift
//  VinayCodingTest
//
//  Created by Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var githubListTableView: UITableView!
    var githubListdataArray = [GithubDetailModel]()
    var viewControllerModelObj = ViewControllerModel()
    let cellSpacingHeight: CGFloat = 5
    var pageNo = 0
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Github List"
        registerTableViewCell()
        getDataFromWebServices(false, pageNo: "\(pageNo)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    private func getDataFromWebServices(_ isPaginationEnabled : Bool , pageNo : String){
        
        self.viewControllerModelObj.getGithubListData(isPaginationEnabled: false, pageNo: "0", parentViewController: self) { (success, response, errorMsg) in
            //If success
            if success {
                self.githubListdataArray.append(contentsOf: self.viewControllerModelObj.githubDetailModelArray)
                
                self.githubListTableView.reloadData()
            } else {
                let errorAlert  = Utility.createAlertWithoutAction(message: errorMsg!, title: "Error")
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        
        
        
    }
    
    private func registerTableViewCell() {
        let nibName = UINib(nibName: "GithubRepoTableViewCell", bundle: nil)
        githubListTableView.register(nibName, forCellReuseIdentifier: TableCellIDConstants.githubRepoTableViewCell)
        githubListTableView.tableFooterView = UIView() // This will remove extra separators from tableview
    }


}


// MARK: - UITableView Delegate  Methods

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return githubListdataArray.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let githubRepoCell = tableView.dequeueReusableCell(withIdentifier: TableCellIDConstants.githubRepoTableViewCell) as? GithubRepoTableViewCell else {
            return UITableViewCell()
        }
        githubRepoCell.loadDataInCell(githubListdataArray[indexPath.section])
        return githubRepoCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = githubListdataArray.count - 1
        if indexPath.section == lastIndex {
            DispatchQueue.main.async {
                self.pageNo = self.pageNo + 1
                self.getDataFromWebServices(true, pageNo: "\(self.pageNo)")
            }
        }
        
    }
    
    
}


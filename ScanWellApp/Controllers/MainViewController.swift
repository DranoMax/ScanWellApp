//
//  MainViewController.swift
//  ScanWellApp
//
//  Created by Alex S on 11/30/21.
//

import UIKit
import Alamofire
import AlamofireImage

class MainViewController: UITableViewController {
    
    private lazy var db: DatabaseHandler = {
        return DatabaseHandler.shared
    }()
    
    private var userDataList: [StackOverflowUserModel] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
    }
    
    // MARK: - Private Methods
    
    private func setupDefaults() {
        self.title = Constants.stackOverflowUsers
        self.registerTableCells()
        self.grabUserList()
    }
    
    private func registerTableCells() {
        self.tableView.register(UINib.init(nibName: Constants.stackOverflowUserCell, bundle: nil), forCellReuseIdentifier: Constants.stackOverflowUserCell)
    }
    
    private func grabUserList() {
        // Check locally first since it's faster
        self.grabLocallySavedUsers()
        
        // Then check the backend for any updates
        self.grabUserListFromStackOverflow()
    }
    
    private func grabLocallySavedUsers() {
        self.userDataList = self.db.getLocallySavedUsers()
        self.tableView.reloadData()
    }
    
    private func grabUserListFromStackOverflow() {
        AF.request(Constants.listStackOverflowUsersURL)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: StackOverflowListUserResponseModel.self) { response in
                guard let stackOverflowUsers = response.value else { return }
                
                let userDataList = stackOverflowUsers.results
                
                if userDataList.count > 0 {
                    self.userDataList = userDataList
                    self.tableView.reloadData()
                }
                
                self.db.saveUsersToLocalDb(userDataList)
            }
    }
    
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDataList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let typedCell = tableView.dequeueReusableCell(withIdentifier: Constants.stackOverflowUserCell, for: indexPath) as? StackOverflowUserCell {
            typedCell.selectionStyle = .none
            typedCell.stackOverFlowUserModel = self.userDataList[indexPath.row]
            return typedCell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: Constants.userDetailsVC) as? UserDetailsController {
            viewCon.stackOverFlowUserModel = self.userDataList[indexPath.row]
            self.navigationController?.present(viewCon, animated: true, completion: nil)
        }
    }
}

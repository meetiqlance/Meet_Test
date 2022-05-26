//
//  HomeVC.swift
//  Meet_Test
//
//  Created by Apple iQlance on 25/05/2022.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    var arrOfHomeData : Home?
    var arrOfFilterData = [TestUser]()
    var arrOfCoreHome = [TestUser]()
    var isFiltered = false
    var page = 0
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if self.overrideUserInterfaceStyle == .dark {
//            self.viewSearch.backgroundColor = .black
//        } else {
//            self.viewSearch.backgroundColor = .white
//        }
        
        self.overrideUserInterfaceStyle = .dark
        
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    //MARK:-  Buttons Clicked Action
    
    //MARK:-  Functions
    func callApi(page: Int,isLoader: Bool)  {
        
        if isLoader {
            CustomLoader.sharedInstance.showActivityIndicatory(vc: self)
        }
        
        APIManager.sharedInstance.parseAPIKeyWithURLGET(String(format: Constant.USER_DATA + "\(page)"), isFalg: true, showLoadingIndicator: true, ModelType: Home.self) { (response) in

            print("Response",response)
            switch response {
            case .success(let data):
        
                self.arrOfHomeData = data
                let dict :  [String : String]  = ["name" : "\(self.arrOfHomeData?.login ?? "")", "followers" : "\(self.arrOfHomeData?.followers ?? 0)" , "following": "\(self.arrOfHomeData?.following ?? 0)" , "blog": "\(self.arrOfHomeData?.blog ?? "")","company": "\(self.arrOfHomeData?.company ?? "")","detail": "\(self.arrOfHomeData?.nodeID ?? "")","avatar_url": "\(self.arrOfHomeData?.avatarURL ?? "")","notes": "write note"]
                DatabaseHelper.shareInstence.save(object: dict)
                
            case .failure(let error):
                print(error.localizedDescription)
                Utility.shared.showAlertWithBackAction(vc: self, strTitle: "Something went wrong!", StrMessage: error.localizedDescription, handler: { (value) in
                })
                break
            }

            self.reloadTableView()
        }
    }
    
    private func reloadTableView() {
        
        DispatchQueue.main.async {
            
            self.arrOfCoreHome = DatabaseHelper.shareInstence.getData()
            self.arrOfFilterData = self.arrOfCoreHome
            self.tblView.reloadData()
            self.tblView.layoutIfNeeded()
            self.spinner.stopAnimating()
            CustomLoader.sharedInstance.hideActivityIndicator()
        }
    }
    
    private func initialSetup() {
        
        //self.view.backgroundColor = Constant.appBackgroundColor
        self.tblView.registerXIB(name: "HomeTblCell")
        self.callApi(page: page, isLoader: true)
        self.arrOfCoreHome = DatabaseHelper.shareInstence.getData()
        self.arrOfFilterData = self.arrOfCoreHome
        self.tblView.reloadData()
    }
    
}


//MARK:-  UITableViewDataSource Methods
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrOfCoreHome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTblCell") as! HomeTblCell
        let arr = arrOfCoreHome[indexPath.row]
        cell.configureCell(arr: arr)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == arrOfCoreHome.count - 1 {
            self.page = page + 1
            self.callApi(page: page + 1, isLoader: false)
        }
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tblView.tableFooterView = spinner
            self.tblView.tableFooterView?.isHidden = false
        }
    }
}

//MARK:-  UITableViewDelegate Methods
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        vc.titleName = arrOfCoreHome[indexPath.row].name ?? ""
        vc.index = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:-  UITextfield delegate
extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        isFiltered = true
        arrOfCoreHome = arrOfFilterData.filter{$0.name!.contains(textField.text ?? "", options: .caseInsensitive)}
        
        if arrOfCoreHome.count == 0 {
            
            self.arrOfCoreHome = self.arrOfFilterData
        }
        
        if textField.text == "" {
            
            arrOfCoreHome = DatabaseHelper.shareInstence.getData()
        }
        
        textField.resignFirstResponder()
        tblView.reloadData()
        return true
    }
}

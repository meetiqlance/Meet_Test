//
//  HomeDetailVC.swift
//  Meet_Test
//
//  Created by Apple iQlance on 25/05/2022.
//

import UIKit

class HomeDetailVC: UIViewController {

    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComapny: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    
    @IBOutlet weak var txtNote: UITextView!
    
    var titleName = String()
    var index = Int()
    
    var arrOfHomeDataDetail : Home?
    var arrOfCoreHomeDetail = [TestUser]()
    
    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func callApiDetail(strName: String,isLoader: Bool)  {
        
        if isLoader {
            CustomLoader.sharedInstance.showActivityIndicatory(vc: self)
        }
        
        APIManager.sharedInstance.parseAPIKeyWithURLGET(String(format: Constant.USER_DETAIL + "\(strName)"), isFalg: false, showLoadingIndicator: true, ModelType: Home.self) { (response) in

            print("Response",response)
            switch response {
            case .success(let data):
        
                self.arrOfHomeDataDetail = data
                self.setData()
                
            case .failure(let error):
                print(error.localizedDescription)
                Utility.shared.showAlertWithBackAction(vc: self, strTitle: "Something went wrong!", StrMessage: error.localizedDescription, handler: { (value) in
                })
                break
            }
        }
    }
    
    //MARK:-  Buttons Clicked Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveNoteAction(_ sender: UIButton) {
        
        if txtNote.text == "write note" || txtNote.text == "" {
            self.showAlertWithOkButton(message: "Please Enter Note")
        }else{
            let dict :  [String : String]  = ["name" : "\(self.arrOfCoreHomeDetail[index].name ?? "")", "followers" : "\(self.arrOfCoreHomeDetail[index].followers ?? "")" , "following": "\(self.arrOfCoreHomeDetail[index].following ?? "")" , "blog": "\(self.arrOfCoreHomeDetail[index].blog ?? "")","company": "\(self.arrOfCoreHomeDetail[index].company ?? "")","detail": "\(self.arrOfCoreHomeDetail[index].detail ?? "")","notes": "\(self.txtNote.text ?? "")","avatar_url": "\(self.arrOfCoreHomeDetail[index].avatar_url ?? "")"]
            DatabaseHelper.shareInstence.editData(object: dict, i: index)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-  Functions
    private func initialSetup() {
        
        self.lblTitle.text = titleName
        self.arrOfCoreHomeDetail.removeAll()
        self.callApiDetail(strName: titleName, isLoader: true)
    }
    
    private func setData() {
        
        DispatchQueue.main.async {
            
            self.arrOfCoreHomeDetail = DatabaseHelper.shareInstence.getData()
            
            self.imgProfile.loadFrom(URLAddress: self.arrOfHomeDataDetail?.avatarURL ?? "ic_profile")
            
            self.txtNote.text = "\(self.arrOfCoreHomeDetail[self.index].notes ?? "write note")"
            
            if let name = self.arrOfHomeDataDetail?.name{
                self.lblName.text = " Name: " + "\(name)"
            }else{
                self.lblName.isHidden = true
            }
            
            if let company = self.arrOfHomeDataDetail?.company{
                self.lblComapny.text = " Company: " + "\(company)"
            }else{
                self.lblComapny.isHidden = true
            }
            
            if let following = self.arrOfHomeDataDetail?.following{
                self.lblFollowing.text = " Following: " + "\(following)"
            }else{
                self.lblFollowing.isHidden = true
            }
            
            if let blog = self.arrOfHomeDataDetail?.blog{
                self.lblBlog.text = " Blog: " + "\(blog)"
            }else{
                self.lblBlog.isHidden = true
            }
            
            if let followers = self.arrOfHomeDataDetail?.followers{
                self.lblFollowers.text = " Followers: " + "\(followers)"
            }else{
                self.lblFollowers.isHidden = true
            }

            CustomLoader.sharedInstance.hideActivityIndicator()
        }
    }
}

extension HomeDetailVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtNote.text == "write note"{
            txtNote.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.txtNote.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        return true;
    }
}

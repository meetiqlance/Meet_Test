//
//  HomeTblCell.swift
//  Meet_Test
//
//  Created by Apple iQlance on 25/05/2022.
//

import UIKit

class HomeTblCell: UITableViewCell {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDetail: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    @IBOutlet weak var btnFile: UIButton!
    
    //MARK:- 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:-  Buttons Clicked Action
    
    //MARK:-  Functions
    func configureCell(arr: TestUser)  {
        
        self.imgFile.image = UIImage(named: "ic_file")?.withRenderingMode(.alwaysTemplate)
        self.btnFile.tintColor = .white
        self.btnFile.isHidden = true
        
        self.imgProfile.loadFrom(URLAddress: arr.avatar_url ?? "ic_profile")
        
        self.lblUserName.text = arr.name
        self.lblUserDetail.text = arr.detail
        
        if arr.notes == ""{
            self.imgFile.isHidden = true
        }else{
            self.imgFile.isHidden = false
        }
    }
    
}

//
//  HSUnderLineTextField.swift
//  Meet_Test
//
//  Created by Apple iQlance on 25/05/2022.
//

import Foundation
import UIKit

class HSUnderLineTextField: UITextField , UITextFieldDelegate {

    let border = CALayer()

    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            border.borderColor = lineColor.cgColor
        }
    }

    @IBInspectable open var selectedLineColor : UIColor = UIColor.black {
        didSet{
        }
    }


    @IBInspectable open var lineHeight : CGFloat = CGFloat(1.0) {
        didSet{
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width - (self.leftPadding + self.rightPadding), height: self.frame.size.height)
        }
    }

    required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        self.delegate=self;
        border.borderColor = lineColor.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])


        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = lineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        self.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = selectedLineColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = lineColor.cgColor
    }
}
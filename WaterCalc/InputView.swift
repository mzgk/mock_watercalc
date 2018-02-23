//
//  InputView.swift
//  WaterCalc
//
//  Created by 水垣岳志 on 2018/02/12.
//  Copyright © 2018年 mzgkworks.com. All rights reserved.
//

import UIKit

@IBDesignable
class InputView: UIView, UITextFieldDelegate {

    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!

    // InoutView（系統）を表すID → VC側で設定される
    var groupID = 0

    static let notificationName = Notification.Name("InputNotification")

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(xibName: "InputView")

        // 通知の登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(allNotificarion(_:)),
            name: ViewController.notificationName,
            object: nil
        )
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib(xibName: "InputView")

        // 通知の登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(allNotificarion(_:)),
            name: ViewController.notificationName,
            object: nil
        )
    }

    /// .xibを読み込み、Viewをロードする
    func loadNib(xibName: String) {
        let view = Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view": view]))

        numberField.delegate = self
        amountField.delegate = self
    }

    // 本数と水量に入力された値で合計を計算して出力する
    // 本数と水量のUITextFieldは.tagで判別する
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.tag)
        let tmpStr = textField.text! as NSString
        var replacedString = tmpStr.replacingCharacters(in: range, with: string)
        if replacedString == "" {
            replacedString = "0"
        }
        let num = Int(replacedString)
        var total = Int()
        if textField.tag == 1 {
            total = num! * Int(amountField.text!)!
        }
        else {
            total = Int(numberField.text!)! * num!
        }
        totalLabel.text = String(total)

        // 通知を投稿する（系統を表すIDと水量の計算結果）
        NotificationCenter.default.post(
            name: InputView.notificationName,
            object: nil,
            userInfo: ["id": groupID, "total": total]
        )

        return true
    }

    // 通知を受け取るメソッド
    @objc func allNotificarion(_ notification: Notification) {
        print("receive ALL Notification!")
        guard let userInfo = notification.userInfo,
            let value = userInfo["value"] as? Int else {
                print("No userInfo found in notification")
                return
        }
        print("VALUE: \(value)")

        amountField.text = String(value)
        let total = Int(numberField.text!)! * value
        totalLabel.text = String(total)
        NotificationCenter.default.post(
            name: InputView.notificationName,
            object: nil,
            userInfo: ["id": groupID, "total": total]
        )
    }
}

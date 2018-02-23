//
//  ViewController.swift
//  WaterCalc
//
//  Created by 水垣岳志 on 2018/02/11.
//  Copyright © 2018年 mzgkworks.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var groupView_1: InputView!
    @IBOutlet weak var groupView_2: InputView!
    @IBOutlet weak var groupView_3: InputView!
    @IBOutlet weak var amountLabel: UILabel!

    static let notificationName = Notification.Name("AllNotification")

    // 総合計
    var amount = 0
    // 系統ごとの水量を格納する配列（要素数：８、初期値：０）
    // プロパティオブザーバーを利用して、更新されるごとに総合計を計算
    var array = [Int](repeating: 0, count: 8) {
        didSet {
            amount = 0
            for i in array {
                amount += i
            }
            print("総合計： \(amount)")
            amountLabel.text = String(amount)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 通知の登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotificarion(_:)),
            name: InputView.notificationName,
            object: nil
        )

        groupView_1.groupID = 0
        groupView_2.groupID = 1
        groupView_3.groupID = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 通知を解除
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
//        groupView_1.amountField.text = "3"
//        groupView_2.amountField.text = "3"
//        groupView_3.amountField.text = "3"

        // 通知を投稿する（一括の水量）
        NotificationCenter.default.post(
            name: ViewController.notificationName,
            object: nil,
            userInfo: ["value": 3]
        )
    }

    // 通知を受け取るメソッド
    @objc func handleNotificarion(_ notification: Notification) {
        print("receive Notification!")
        guard let userInfo = notification.userInfo,
            let id = userInfo["id"] as? Int,
            let total = userInfo["total"] as? Int else {
                print("No userInfo found in notification")
                return
        }
        print("ID: \(id)")
        print("TOTAL: \(total)")

        // 対象の要素に格納する
        array[id] = total
        print(array)
        // TODO: 保存を考えると、系統・本数・水量・合計の１グループ単位で辞書または名前つきタプルで受け取って
        // 配列にしておいた方がいいかも
    }

    // 画面タップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // 一括の水量設定もボタンでの発火にしないでTextFieldだけにして、入力でInputViewに新しい通知をとばす
    // → 通知を受けたら計算する　→ 表示する　→ VC側に通知を飛ばす（"InputNotification"）
}


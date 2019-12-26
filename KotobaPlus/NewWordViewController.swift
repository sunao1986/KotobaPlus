//
//  NewWordViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/15.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class NewWordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newLabelField: UITextField!
    
    //FileIDが入ってくる
    var parentId:String?
//    var idbox:String?
    
    //TextFieldは２つあるからスクロール移動用に一つにまとめる
    var selectedTextField: UITextField?
    
    //画面の高さを取得
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newLabelField.delegate = self
    
//        idbox = idtext
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()
    }
    
    func configureObserver() {
        let notification = NotificationCenter.default
        
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("Notificationを発行")
    }
    
    //選択したテキストフィールドを認識
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        
            guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                    return
            }
                
            //スクリーンの高さ
            let screenHeight = screenSize.height
            //キーボードの高さ
            let keyboardHeight = rect.size.height
            //選択したテキストフィールドまでの高さ
            let textUnderHeight: CGFloat = selectedTextField!.frame.maxY
            //スクロールする高さを計算
            let hiddenHeight = keyboardHeight + textUnderHeight - screenHeight
            
            if hiddenHeight > 0 {
                UIView.animate(withDuration: duration) {
                let transform = CGAffineTransform(translationX: 0, y: -(hiddenHeight + 20))
                self.view.transform = transform
                }
            } else {
                UIView.animate(withDuration: duration) {
                let transform = CGAffineTransform(translationX: 0, y: -(0))
                self.view.transform = transform
                }
            }
        print("keyboardWillShowを実行")
    }
    

    @objc func keyboardWillHide(_ notification: Notification?)  {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else {
                return }
            UIView.animate(withDuration: duration) {
                self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる処理
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // 保存ボタンを押したら
    @IBAction func newWordSave(_ sender: Any) {
        
        if newLabelField.text == "" {
            let alert = UIAlertController(title: "無記入の項目があります", message: "文字を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("空白用アラート")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
        //保存するFileを引き継いだID(idtext)で呼び出す
        let realm = try! Realm()
        let results = realm.object(ofType: Files.self, forPrimaryKey: "\(parentId!)")
        
        //Labelを書き込むためにインスタンス化する
        let label = Label()
        //parentidカラムに書き込む
        label.parentid = parentId!
        //labelnameカラムに書き込む
        if let newLabel = self.newLabelField.text {
            label.labelname = newLabel.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        //FileのListに書き込む
        let labels = List<Label>()
        labels.append(label)
        
        //Realmに作成したLabelを書き込む。そのLabelをFilesにネストする。
        try! realm.write() {
            realm.add(label)
            results!.labels.append(objectsIn: labels)
        }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func newWordCancell(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

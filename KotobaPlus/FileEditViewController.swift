//
//  FileEditViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/23.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class FileEditViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var editFileName: UITextField!
    
    //TextFieldは２つあるからスクロール移動用に一つにまとめる
    var selectedTextField: UITextField?
    //画面の高さを取得
    let screenSize = UIScreen.main.bounds.size
    
    //値渡し用
    //ファイルIDが入ってくる
    var fileTitleId:String?
    //ファイル名が入ってる
    var fileTitleName:String?
    //ファイルIDを入れる
//    var idbox:String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editFileName.delegate = self
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lodeFile()
        self.configureObserver()
    }
    
    func lodeFile() {
        fileNameLabel.text = fileTitleName
        editFileName.text = fileTitleName
//        idbox = fileTitleId
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
    
    
    @IBAction func fileEditFix(_ sender: Any) {
        
        if editFileName?.text == "" || fileNameLabel?.text == "" {
            let alert = UIAlertController(title: "無記入です", message: "文字を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("空白用アラート")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let realm = try! Realm()
            let file = realm.object(ofType: Files.self, forPrimaryKey: "\(fileTitleId!)")
            try! realm.write() {
                if let fileTitle = self.editFileName.text {
                    file!.filename = fileTitle.trimmingCharacters(in: CharacterSet.whitespaces)
                }
            }
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func fileEditBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    


}

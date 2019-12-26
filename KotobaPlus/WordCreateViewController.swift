//
//  WordCreateViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/24.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class WordCreateViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var wordCreate: UITextField!
    
        //FileIDが入ってくる
        var grandparentId:String?
        var parentId:String?
    //    var idbox:String?
        var saveword:String?
        var checkWord:String?
        
        //TextFieldは２つあるからスクロール移動用に一つにまとめる
        var selectedTextField: UITextField?
        
        //画面の高さを取得
        let screenSize = UIScreen.main.bounds.size
        
        override func viewDidLoad() {
            super.viewDidLoad()
            wordCreate.delegate = self
        
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
    
    
    @IBAction func createSave(_ sender: Any) {
        
        let realm = try! Realm()
        checkWord = wordCreate.text
        let wordDouble:Results<Word>? = realm.objects(Word.self).filter("parentid == '\(parentId!)'").filter("word == '\(checkWord!)'")
        
        if wordCreate.text == "" {
            let alert = UIAlertController(title: "無記入の項目があります", message: "文字を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("空白用アラート")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if wordDouble!.count >= 1 {
            let alert = UIAlertController(title: "重複するコトバ", message: "同じラベルの中でコトバを重複させることはできません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("重複用アラート")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
        //保存するFileとLabelを引き継いだIDで呼び出す
        let realm = try! Realm()
//        let fileresults = realm.object(ofType: Files.self, forPrimaryKey: "\(grandparentId!)")
        let labelresults = realm.object(ofType: Label.self, forPrimaryKey: "\(parentId!)")
//        let label: Label = labelresults
        
        //Wordを書き込むためにインスタンス化する
        let word = Word()
        //wordにgrandparentidを書き込む
        word.grandparentid = grandparentId!
        //wordにparentidを書き込む
        word.parentid = parentId!
        //labelのselectwordカラムとwordのwordカラムに書き込む
        if let newWord = self.wordCreate.text {
            word.word = newWord.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        //LabelのListに書き込む
        let words = List<Word>()
        words.append(word)
        
        saveword = self.wordCreate.text
        //Realmに書き込む。
        try! realm.write() {
            realm.add(word)
            labelresults!.selectword = saveword!.trimmingCharacters(in: CharacterSet.whitespaces)
            labelresults!.words.append(objectsIn: words)
        }

            self.dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func createBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

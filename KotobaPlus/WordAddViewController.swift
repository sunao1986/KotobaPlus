//
//  WordAddViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/21.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class WordAddViewController: UIViewController, UITextFieldDelegate  {

    
    @IBOutlet weak var wordAddTextField: UITextField!
    
    //引き継いだLabelIDをこのページで使えるようにするために格納する変数をて作っておく
//    var labelid:String?
    //引き継いだLabelIDをこのページで受けとめるための変数
    var idlabel:String?
    var grandparentId:String?
    var checkWord:String?
    var saveword:String?
        
        //TextFieldは２つあるからスクロール移動用に一つにまとめる
        var selectedTextField: UITextField?
        
        //画面の高さを取得
        let screenSize = UIScreen.main.bounds.size
        
        override func viewDidLoad() {
            super.viewDidLoad()
            wordAddTextField.delegate = self
        
//            labelid = idlabel
            
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

    @IBAction func wordAddSave(_ sender: Any) {
        
        let realm = try! Realm()
        checkWord = wordAddTextField.text
        let wordDouble:Results<Word>? = realm.objects(Word.self).filter("parentid == '\(idlabel!)'").filter("word == '\(checkWord!)'")
        
        if wordAddTextField.text == "" {
            let alert = UIAlertController(title: "無記入です", message: "文字を入力してください", preferredStyle: .alert)
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
               
            let realm = try! Realm()
            let results = realm.object(ofType: Label.self, forPrimaryKey: "\(idlabel!)")
            
            let word = Word()
            word.parentid = idlabel!
            word.grandparentid = grandparentId!
            //labelのlabelnameカラムに書き込む
            if let newWord = self.wordAddTextField.text {
                word.word = newWord.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            
            //appendを使ってListオブジェクトへ追加する。同時の新規作成なのでネスト化は自動
            let words = List<Word>()
            words.append(word)
            
            saveword = self.wordAddTextField.text
            //Id指定したFilesには、addで追加した後にappendする。objectsInは.writeの中でしか使えない
            try! realm.write() {
                realm.add(word)
                results!.selectword = saveword!.trimmingCharacters(in: CharacterSet.whitespaces)
                results!.words.append(objectsIn: words)
                
            }
                
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
        
    @IBAction func wordAddCancell(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

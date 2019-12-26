//
//  SheetEditViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/21.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class SheetEditViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var editLabel: UITextField!
    
    @IBOutlet weak var editWord: UITextField!
    
    @IBOutlet weak var sheetEditLabel: UILabel!
    
    @IBOutlet weak var sheetEditWord: UILabel!
    
    //引き継いだFileIDをこのページで使えるようにするために格納する変数をて作っておく
//    var idtext:String?
    //引き継いだFileIDをこのページで受けとめるための変数
//    var idbox:String?
    //g引き継ぎラベルIDを入れる
//    var labelId:String?
    //引き継ぎラベルIDが入ってくる
    var idlabel:String?
    //引き継ぎラベル名が入ってくる
    var namelabel:String?
    //引き継ぎセレクトワードが入ってくる
    var wordselect:String?
    var checkWord:String?
    
    //TextFieldは２つあるからスクロール移動用に一つにまとめる
    var selectedTextField: UITextField?
    //画面の高さを取得
    let screenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editLabel.delegate = self
        editWord.delegate = self

//        idtext = idbox
//        labelId = idlabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()
        lodeFile()
    }
    
    func lodeFile() {
        sheetEditLabel.text = namelabel
        sheetEditWord.text = wordselect
        editLabel.text = namelabel
        editWord.text = wordselect
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toWordDelete") {
            let nextView:WordDeleteViewController = (segue.destination as? WordDeleteViewController)!
            nextView.labelIdBox = idlabel
        } else {
            print("値渡し失敗")
        }
    }
    

    @IBAction func sheetEditSave(_ sender: Any) {
        
        let realm = try! Realm()
        checkWord = editWord.text
        let wordDouble:Results<Word>? = realm.objects(Word.self).filter("parentid == '\(idlabel!)'").filter("word == '\(checkWord!)'")
        
        
        if editLabel.text == "" || editWord.text == "" {
            let alert = UIAlertController(title: "無記入の項目があります", message: "文字を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("空白用アラート")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if checkWord != wordselect && wordDouble!.count >= 1 {
            let alert = UIAlertController(title: "重複するコトバ", message: "同じラベルの中でコトバを重複させることはできません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("重複用アラート")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
            let realm = try! Realm()
            let label = realm.object(ofType: Label.self, forPrimaryKey: "\(idlabel!)")
            let word = realm.objects(Word.self).filter("parentid == '\(idlabel!)'").filter("word == '\(wordselect!)'").first
            
            try! realm.write() {
                if let editLabel = self.editLabel.text {
                    label!.labelname = editLabel.trimmingCharacters(in: CharacterSet.whitespaces)
                }
                if let editWord = self.editWord.text {
                    word!.word = editWord
                    label!.selectword = editWord
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func sheetEditBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

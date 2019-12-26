//
//  WordDeleteViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/21.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class WordDeleteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    @IBOutlet weak var wordDeletePicker: UIPickerView!
    
    //SheetViewで選択したセルのLabelIDを取得しておく
    var words = List<Word>()
    var wordList = List<Word>()
    var selectWordId:String = ""
    var selectWord:String = ""

    //引き継ぎラベルIDを入れる
//    var labelId:String?
    //引き継ぎラベルIDが入ってくる
    var labelIdBox:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        wordDeletePicker.dataSource = self
        wordDeletePicker.delegate = self
        
        //ページ内で用意していた変数に遷移後(viewDidLoad)のタイミングでデータを引き渡す
//        labelId = labelIdBox
    }
    
    //View表示前にデータを更新したいからviewWillAppearを採用
    override func viewWillAppear(_ animated: Bool) {
        lodeFile()
    }
    
    //viewWillAppearで呼び出すやつ。前のページで選択したlabelのidを引き継いでprimary取得。その一覧をwordListへ。
    func lodeFile() {
        let realm = try! Realm()
        let results = realm.object(ofType: Label.self, forPrimaryKey: "\(labelIdBox!)")
        wordList = results!.words
               
        wordDeletePicker.reloadAllComponents()
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return wordList.count
    }
     
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
               return wordList[row].word
    }
     
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        selectWord = wordList[row].word
        selectWordId = wordList[row].id
    }
    
    //selectWordに値がが入らない
    
    @IBAction func wordDeleteFix(_ sender: Any) {
            let alert = UIAlertController(title: "削除します", message: "よろしいですか？", preferredStyle: .alert)
                                       
            let okAction = UIAlertAction(title: "削除", style: .default) { (UIAlertAction) in
                if self.selectWordId == "" {
                    self.selectWordId = self.wordList[0].id
                    self.selectWord = self.wordList[0].word
                    let realm = try! Realm()
                    let results = realm.object(ofType: Word.self, forPrimaryKey: "\(self.selectWordId)")
                    let deleteWord = realm.object(ofType: Label.self, forPrimaryKey: "\(self.labelIdBox!)")
                    try! realm.write {
                        realm.delete(results!)
                        if deleteWord!.selectword == self.selectWord {
                            deleteWord!.selectword = ""
                        }
                    }
                } else {
                    let realm = try! Realm()
                    let results = realm.object(ofType: Word.self, forPrimaryKey: "\(self.selectWordId)")
                    let deleteWord = realm.object(ofType: Label.self, forPrimaryKey: "\(self.labelIdBox!)")
                    try! realm.write {
                        realm.delete(results!)
                        if deleteWord!.selectword == self.selectWord {
                            deleteWord!.selectword = ""
                        }
                    }
                }
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            let cancell = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                print("キャンセルをタップした時の処理を実行")
            }
            alert.addAction(okAction)
            alert.addAction(cancell)
            self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func wordDeleteBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

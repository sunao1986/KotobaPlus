//
//  WordSelectViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/15.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class WordSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var wordPickerView: UIPickerView!
    
    
    //SheetViewで選択したセルのLabelIDを取得しておく
    var words = List<Word>()
    var wordList = List<Word>()
    var selectWord:String = ""

    //引き継いだLabelIDをこのページで使えるようにするために格納する変数をて作っておく
//    var labelid:String?
    //引き継いだLabelIDをこのページで受けとめるための変数
    var idlabel:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordPickerView.dataSource = self
        wordPickerView.delegate = self
        
        //ページ内で用意していた変数に遷移後(viewDidLoad)のタイミングでデータを引き渡す
//        labelid = idlabel

    }
    
    //View表示前にデータを更新したいからviewWillAppearを採用
    override func viewWillAppear(_ animated: Bool) {
        lodeFile()
    }
    
    //viewWillAppearで呼び出すやつ。前のページで選択したlabelのidを引き継いでprimary取得。その一覧をwordListへ。
    func lodeFile() {
        let realm = try! Realm()
        let results = realm.object(ofType: Label.self, forPrimaryKey: "\(idlabel!)")
        wordList = results!.words
               
        wordPickerView.reloadAllComponents()
    }
    
    
    @IBAction func toSheetBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    }
    
    @IBAction func selectWordFix(_ sender: Any) {
        if selectWord == "" {
            let realm = try! Realm()
            let results = realm.object(ofType: Label.self, forPrimaryKey: "\(idlabel!)")
            
            try! realm.write() {
                results!.selectword = wordList[0].word
            }
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            let realm = try! Realm()
            let results = realm.object(ofType: Label.self, forPrimaryKey: "\(idlabel!)")
            
            try! realm.write() {
                results!.selectword = selectWord
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

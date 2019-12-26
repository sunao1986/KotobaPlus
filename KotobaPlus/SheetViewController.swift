//
//  SheetViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/15.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

class SheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //空のリストを用意
    var labels = List<Label>()
    //呼び出したリストを入れる用
    var labelList = List<Label>()
    
    //引き継いだファイルIDが入ってくる
    var fileTitleId:String?
    //引き継いだファイル名が入ってくる
    var fileTitleName:String?
    //ファイルIDを入れる。存在価値は要確認。
//    var idbox:String?
    //次に渡すラベルIDを入れる用
    var labelId:String?
    //次に渡すラベルparentIDを入れる用
    var labelParentId:String?
    //表示するラベル名を入れる用
    var labelname:String?
    //表示するセレクトワードを入れる用
    var selectword:String?
    var deleteword: Results<Word>?
    
    
    @IBOutlet weak var fileTitle: UILabel!
    
    @IBOutlet weak var tableSheetView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSheetView.dataSource = self
        tableSheetView.delegate = self
        //TOPにはのファイルタイトルを表示
        fileTitle.text = fileTitleName
        //idboxはいる？そのままfileTitleIdを渡せない？
//        idbox = fileTitleId
        //カスタムセルを使うための宣言
        tableSheetView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "SheetCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lodeFile()
     }
     
    func lodeFile() {
        let realm = try! Realm()
        let results = realm.object(ofType: Files.self, forPrimaryKey: "\(fileTitleId!)")
        labelList = results!.labels
            
        tableSheetView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SheetCell", for: indexPath) as! TableViewCell
        let label: Label = self.labelList[(indexPath as NSIndexPath).row]
        cell.sheetLabel.text = label.labelname
        cell.sheetWord.text = label.selectword
        
        return cell
    }
    
    //タップして移動する画面をList<word>の存在で分岐
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let label: Label = self.labelList[(indexPath as NSIndexPath).row]
        
        if label.words.count == 0 {
            performSegue(withIdentifier: "toCreate", sender: nil)
        } else {
            performSegue(withIdentifier: "toSelect", sender: nil)
        }
    }
    
    //選択したラベルのデータを取得
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let label: Label = self.labelList[(indexPath as NSIndexPath).row]
        labelId = label.id
        labelname = label.labelname
        selectword = label.selectword
    }
    
    //セルを左スワイプで「追加ボタン」と「編集ボタン」を表示
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let label: Label = self.labelList[(indexPath as NSIndexPath).row]
        labelId = label.id
        labelname = label.labelname
        selectword = label.selectword
        
        let plusAction = UIContextualAction(style: .normal,
                                        title: "コトバ＋") { (action, view, completionHandler) in
                                        //ラベルがコトバを持ってるかどうかでボタンと遷移先を分岐
                                    let label: Label = self.labelList[(indexPath as NSIndexPath).row]
                                    
                                    if label.words.count == 0 {
                                        tableView.deselectRow(at: indexPath, animated: true)
                                        self.performSegue(withIdentifier: "toCreate", sender: nil)
                                        completionHandler(true)
                                    } else {
                                        tableView.deselectRow(at: indexPath, animated: true)
                                        self.performSegue(withIdentifier: "toAdd", sender: nil)
                                        completionHandler(true)
                                    }
        }
        
        let addAction = UIContextualAction(style: .normal,
                                        title: "編集") { (action, view, completionHandler) in
                                        //ラベルがコトバを持ってるかどうかでボタンと遷移先を分岐
                                        let label: Label = self.labelList[(indexPath as NSIndexPath).row]
                                        
                                        if label.words.count == 0 || label.selectword == "" {
                                            tableView.deselectRow(at: indexPath, animated: true)
                                            self.performSegue(withIdentifier: "toLabelOnly", sender: nil)
                                            completionHandler(true)
                                        } else {
                                            tableView.deselectRow(at: indexPath, animated: true)
                                            self.performSegue(withIdentifier: "toSheetEdit", sender: nil)
                                            completionHandler(true)
                                        }
        }
        
        plusAction.backgroundColor = UIColor(red: 83/255.0, green: 141/255.0, blue: 176/255.0, alpha: 0.85)
        addAction.backgroundColor = UIColor(red: 83/255.0, green: 141/255.0, blue: 176/255.0, alpha: 0.85)

        let configuration = UISwipeActionsConfiguration(actions: [plusAction,addAction])
        return configuration
    }
    
    //セルを右スワイプで「削除ボタン(一括)」を表示
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,title: "削除")  { (action, view, completionHandler) in
                            //確認のポップアップを表示
                            let alert = UIAlertController(title: "削除します", message: "中身のコトバも一括削除されます。よろしいですか？", preferredStyle: .alert)
                                
                            let okAction = UIAlertAction(title: "削除", style: .default) { (UIAlertAction) in
                                                
                                let realm = try! Realm()
                                let label: Label = self.labelList[(indexPath as NSIndexPath).row]
                                self.labelId = label.id
                                let labelresults = realm.object(ofType: Label.self, forPrimaryKey: "\(self.labelId!)")
                                self.deleteword = realm.objects(Word.self).filter("parentid == '\(self.labelId!)'")
                                
                                try! realm.write {
                                    realm.delete(labelresults!)
                                    if let wordresults = self.deleteword {
                                        realm.delete(wordresults)
                                    }
                                }
                                self.tableSheetView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.right)
                                self.tableSheetView.reloadData()
                            }
            
                            let cancell = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                                    //キャンセルのみ
                            }
                        alert.addAction(okAction)
                        alert.addAction(cancell)
                        self.present(alert, animated: true, completion: nil)
                                
                        completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    //親Filesのidと選択されたlabelのidを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewWord") {
            let nextView:NewWordViewController = (segue.destination as? NewWordViewController)!
            nextView.parentId = fileTitleId
        } else if (segue.identifier == "toSelect") {
            let nextView:WordSelectViewController = (segue.destination as? WordSelectViewController)!
            nextView.idlabel = labelId
        } else if (segue.identifier == "toCreate") {
            let nextView:WordCreateViewController = (segue.destination as? WordCreateViewController)!
            nextView.parentId = labelId
            nextView.grandparentId = fileTitleId
        } else if (segue.identifier == "toAdd") {
            let nextView:WordAddViewController = (segue.destination as? WordAddViewController)!
            nextView.idlabel = labelId
            nextView.grandparentId = fileTitleId
        } else if (segue.identifier == "toLabelOnly") {
            let nextView:LabelOnlyViewController = (segue.destination as? LabelOnlyViewController)!
            nextView.idlabel = labelId
            nextView.namelabel = labelname
        } else if (segue.identifier == "toSheetEdit") {
            let nextView:SheetEditViewController = (segue.destination as? SheetEditViewController)!
            nextView.idlabel = labelId
            nextView.namelabel = labelname
            nextView.wordselect = selectword
        } else {
            //該当なし
        }
    }
    
}

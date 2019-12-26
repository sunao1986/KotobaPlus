//
//  ViewController.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/14.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    //一覧表示をするデータが入る変数を先に用意。オプショナル型にして初期値設定をする
    var fileList: Results<Files>!
    var deleteLabel: Results<Label>?
    var deleteWord: Results<Word>?
    var selectFileId:String = ""
    var selectFileTitle:String = ""
    
    let ud = UserDefaults.standard
    
    var bannerView: GADBannerView!
    
    
    @IBOutlet weak var tableFileView: UITableView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableFileView.dataSource = self
        tableFileView.delegate = self
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        addBannerViewToView(bannerView)
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        //下部にアラートを出す
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let reset = UIAlertAction(title: "データリセット", style: UIAlertAction.Style.destructive, handler: {
                (action: UIAlertAction!) in
            
            let alert = UIAlertController(title: "データリセット", message: "すべてのデータが削除されます。よろしいですか？", preferredStyle: .alert)
                                       
            let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                print("削除をタップした時の処理を実行")
                
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                self.tableFileView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            let cancell = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                print("キャンセルしました")
            }
            alert.addAction(okAction)
            alert.addAction(cancell)
            self.present(alert, animated: true, completion: nil)
            
        })

        let sortC = UIAlertAction(title: "ソート(作成順)", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
            
            let sortCmode = UIAlertController(title: "順番を選んでください", message: "ファイルが作成された日時で並べ替えます", preferredStyle: .alert)
                                       
            let new = UIAlertAction(title: "新しいファイルが上", style: .default) { (UIAlertAction) in
                
                let realm = try! Realm()
                self.fileList = realm.objects(Files.self).sorted(byKeyPath:"createAt", ascending: true)
                self.ud.set("", forKey: "switch")
                self.tableFileView.reloadData()
                print("新しいファイルが上になりました")
                
                self.dismiss(animated: true, completion: nil)
            }
            let old = UIAlertAction(title: "古いファイルが上", style: .default) { (UIAlertAction) in
                
                let realm = try! Realm()
                self.fileList = realm.objects(Files.self).sorted(byKeyPath:"createAt", ascending: false)
                self.ud.set("1", forKey: "switch")
                self.tableFileView.reloadData()
                print("古いファイルが上になりました")
                
                self.dismiss(animated: true, completion: nil)
            }
            let cancell = UIAlertAction(title: "戻る", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                print("キャンセルしました")
            }
            sortCmode.addAction(new)
            sortCmode.addAction(old)
            sortCmode.addAction(cancell)
            self.present(sortCmode, animated: true, completion: nil)
            
        })

        let sortN = UIAlertAction(title: "ソート(名前順)", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
            
            let sortNmode = UIAlertController(title: "順番を選んでください", message: "ファイルの名前で並び替えます", preferredStyle: .alert)
                                       
            let up = UIAlertAction(title: "五十音順", style: .default) { (UIAlertAction) in
                
                let realm = try! Realm()
                self.fileList = realm.objects(Files.self).sorted(byKeyPath:"filename", ascending: true)
                self.ud.set("2", forKey: "switch")
                self.tableFileView.reloadData()
                print("五十音順に並び替えました")
                
                self.dismiss(animated: true, completion: nil)
            }
            let down = UIAlertAction(title: "逆五十音順", style: .default) { (UIAlertAction) in
                
                let realm = try! Realm()
                self.fileList = realm.objects(Files.self).sorted(byKeyPath:"filename", ascending: false)
                self.ud.set("3", forKey: "switch")
                self.tableFileView.reloadData()
                print("逆五十音順に並び替えました")
                
                self.dismiss(animated: true, completion: nil)
            }
            let cancell = UIAlertAction(title: "戻る", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                print("キャンセルしました")
            }
            sortNmode.addAction(up)
            sortNmode.addAction(down)
            sortNmode.addAction(cancell)
            self.present(sortNmode, animated: true, completion: nil)
                
        })
        
        let review = UIAlertAction(title: "レビューを書く", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
            
            let applink = UIAlertController(title: "AppStoreに飛びます", message: "よろしいですか？", preferredStyle: .alert)
                                       
            let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                print("飛びます")
                guard let url = URL(string: "https://itunes.apple.com/app/id{Apple ID}?action=write-review")else{ return }
                UIApplication.shared.open(url)
                
                self.dismiss(animated: true, completion: nil)
            }
            let cancell = UIAlertAction(title: "戻る", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                print("キャンセルしました")
            }
            applink.addAction(ok)
            applink.addAction(cancell)
            self.present(applink , animated: true, completion: nil)
        })

        let back = UIAlertAction(title: "戻る", style: UIAlertAction.Style.cancel, handler: {
                (action: UIAlertAction!) in
                print("キャンセルしました")
            })

            actionSheet.addAction(reset)
            actionSheet.addAction(sortC)
            actionSheet.addAction(sortN)
            actionSheet.addAction(review)
            actionSheet.addAction(back)

            self.present(actionSheet, animated: true, completion: nil)
        
    }

    //基本のセルの高さを指定。StoryBoradではAuto。
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //ヘッダーを作成して色を変更
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
            view.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.00)
        return view
    }
    
    //ヘッダーの高さを指定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        let File: Files = self.fileList[(indexPath as NSIndexPath).row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = File.filename
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lodeFile()
     }
     
    func lodeFile() {
        let sort:String? = ud.string(forKey: "switch")
        if sort == "" {
            let realm = try! Realm()
            self.fileList = realm.objects(Files.self).sorted(byKeyPath:"createAt", ascending: true)
            tableFileView.reloadData()
        } else if sort == "1" {
            let realm = try! Realm()
            self.fileList = realm.objects(Files.self).sorted(byKeyPath:"createAt", ascending: false)
            tableFileView.reloadData()
        } else if sort == "2" {
            let realm = try! Realm()
            self.fileList = realm.objects(Files.self).sorted(byKeyPath:"filename", ascending: true)
            tableFileView.reloadData()
        } else if sort == "3" {
            let realm = try! Realm()
            self.fileList = realm.objects(Files.self).sorted(byKeyPath:"filename", ascending: false)
            tableFileView.reloadData()
        } else {
            let realm = try! Realm()
            self.fileList = realm.objects(Files.self)
            tableFileView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shouldPerformSegue(withIdentifier: "toSheet", sender: nil)
    }
    
    //
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let File: Files = self.fileList[(indexPath as NSIndexPath).row]
        selectFileId = File.id
        selectFileTitle = File.filename
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSheet") {
            let nextView:SheetViewController = (segue.destination as? SheetViewController)!
            nextView.fileTitleId = selectFileId
            nextView.fileTitleName = selectFileTitle
        } else if (segue.identifier == "toFileEdit") {
            let nextView:FileEditViewController = (segue.destination as? FileEditViewController)!
            nextView.fileTitleId = selectFileId
            nextView.fileTitleName = selectFileTitle
        } else {
            print("値渡し失敗/又はしない遷移先")
        }
    }
    
    //セルを左スワイプで「削除ボタン」と「編集ボタン」を表示
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let File: Files = self.fileList[(indexPath as NSIndexPath).row]
        selectFileId = File.id
        selectFileTitle = File.filename
        
        let editAction = UIContextualAction(style: .normal,
                title: "編集") { (action, view, completionHandler) in
                // ボタンをタップした時のアクションを指定
                tableView.deselectRow(at: indexPath, animated: true)
                self.performSegue(withIdentifier: "toFileEdit", sender: nil)
                print("toFileEdit")
                // 処理の実行結果に関わらず completionHandler を呼ぶのがポイント
                completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive,
                title: "一括削除") { (action, view, completionHandler) in
                    //確認のポップアップを表示
                    let alert = UIAlertController(title: "削除します", message: "中身のコトバも一括削除されます。よろしいですか？", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "削除", style: .default) { (UIAlertAction) in
                        print("削除をタップした時の処理を実行")
                        //処理を書く
                        let realm = try! Realm()
                        let deleteFile = realm.object(ofType: Files.self, forPrimaryKey: "\(self.selectFileId)")
                        self.deleteLabel = realm.objects(Label.self).filter("parentid == '\(self.selectFileId)'")
                        self.deleteWord = realm.objects(Word.self).filter("grandparentid == '\(self.selectFileId)'")
                    
                        try! realm.write {
                            realm.delete(deleteFile!)
                            if let label = self.deleteLabel {
                                realm.delete(label)
                            }
                            if let word = self.deleteWord {
                                realm.delete(word)
                            }
                        }
                        self.tableFileView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.right)
                        self.tableFileView.reloadData()
                    }
                    let cancell = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                        print("キャンセルをタップした時の処理を実行")
                        //処理を書く
                    }
                    alert.addAction(okAction)
                    alert.addAction(cancell)
                    self.present(alert, animated: true, completion: nil)
                    
                // 処理の実行結果に関わらず completionHandler を呼ぶのがポイント
                completionHandler(true)
        }
        
        editAction.backgroundColor = UIColor(red: 83/255.0, green: 141/255.0, blue: 176/255.0, alpha: 0.85)
        deleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)

        let configuration = UISwipeActionsConfiguration(actions: [editAction,deleteAction])
        return configuration
    }
    
}


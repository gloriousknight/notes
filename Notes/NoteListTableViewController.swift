////
////  NoteListTableViewController.swift
////  Notes
////
////  Created by BaronZhang on 2020/9/16.
////  Copyright © 2020 Glorious. All rights reserved.
////
//
//import UIKit
//
//class NoteListTableViewController: UITableViewController {
//    //数据源数组
//    var dataArray = Array<NoteModel>()
//    //当前分组
//    var name:String?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //设置导航栏标题
//        self.title = name
//        /*测试创建10条数据，已废除
//        for _ in 0...10 {
//            let model = NoteModel()
//            model.time = "2020-09-11"
//            model.title = "My First App"
//            model.body = "This is a test app for learning Swift!"
//            dataArray.append(model)
//        }*/
//        //进行导航按钮加载
//        installNavigationItem()
//        //从数据库中读取记事
////        dataArray = DataManager.getNote(group: name!)
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        dataArray = DataManager.getNote(group: name!)
//        self.tableView.reloadData()
//    }
//    /**
//        定义导航按钮加载函数
//     */
//    func installNavigationItem() {
//        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
//        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteGroup))
//        self.navigationItem.rightBarButtonItems = [addItem, deleteItem]
//
//    }
//    /**
//        定义新增笔记方法addNote( )
//     */
//    @objc func addNote() {
//        let infoViewController = NoteInfoViewController()
//        infoViewController.group = name!
//        infoViewController.isNew = true
//        self.navigationController?.pushViewController(infoViewController, animated: true)
//    }
//    /**
//        定义删除分组方法deleteGroup( )
//     */
//    @objc func deleteGroup() {
//        let alertController = UIAlertController(title: "警告", message: "是否确定删除这个分组下的所有记事呢？", preferredStyle: .alert)
//        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let action2 = UIAlertAction(title: "删除", style: .destructive, handler: {(UIAlertAction) -> Void in
//            DataManager.deleteGroup(name: self.name!)
//            self.navigationController?.popViewController(animated: true)
//
//        })
//        alertController.addAction(action)
//        alertController.addAction(action2)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    //设置行数为数据源中的数据个数
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataArray.count
//    }
//    //进行数据载体Cell的设置
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cellID = "noteListCellID"
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
//        if cell == nil {
//            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
//        }
//        let model = dataArray[indexPath.row]
//        cell?.textLabel?.text = model.title
//        cell?.detailTextLabel?.text = model.time
//        cell?.accessoryType = .disclosureIndicator
//        return cell!
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //取消当前cell选中状态
//        tableView.deselectRow(at: indexPath, animated: true)
//        let infoViewController = NoteInfoViewController()
//        infoViewController.group = name!
//        infoViewController.isNew = false
//        infoViewController.noteModel = dataArray[indexPath.row]
//        self.navigationController?.pushViewController(infoViewController, animated: true)
//    }
//
//}


//
//  NoteListTableViewController.swift
//  NoteBook
//
//  Created by vip on 16/11/12.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class NoteListTableViewController: UITableViewController {

    //数据源数组
    var dataArray = Array<NoteModel>()
    //当前分组
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        installNavigationItem()
        //从数据库中读取记事
        //dataArray =  DataManager.getNote(group: name!)
    }
    
    func installNavigationItem() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteGroup))
        self.navigationItem.rightBarButtonItems = [addItem,deleteItem]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataArray = DataManager.getNote(group: name!)
        self.tableView.reloadData()
    }
    
    @objc func addNote()  {
        let infoViewController = NoteInfoViewController()
        infoViewController.group = name!
        infoViewController.isNew = true
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    @objc func deleteGroup()  {
        let alertController = UIAlertController(title: "警告", message: "您确定要删除此分组下所有记事么？", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "删除", style: .destructive, handler: {(UIAlertAction) -> Void in
                DataManager.deleteGroup(name: self.name!)
                self.navigationController!.popViewController(animated: true)
            
        })
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "noteListCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
        }
        let model = dataArray[indexPath.row]
        cell?.textLabel?.text = model.title
        cell?.detailTextLabel?.text = model.time
        cell?.accessoryType = .disclosureIndicator

        return cell!
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let infoViewController = NoteInfoViewController()
        infoViewController.group = name!
        infoViewController.isNew = false
        infoViewController.noteModel = dataArray[indexPath.row]
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    

}

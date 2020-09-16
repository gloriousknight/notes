//
//  ViewController.swift
//  Notes
//
//  Created by BaronZhang on 2020/9/14.
//  Copyright © 2020 Glorious. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HomeButtonDelegate {
    var homeView:HomeView?
    var dataArray:Array<String>?
    override func viewDidLoad() {
        super.viewDidLoad()
        //页面标题
        self.title = "Notes"
        //取消导航栏对页面布局的影响
        self.edgesForExtendedLayout = UIRectEdge()
//        dataArray = ["生活","学习","工作","待办","健身计划"]
        //从DataManager中获取分组数据
        dataArray = DataManager.getGroupData()
        self.installUI()
    }
    /**
        初始化UI方法
     */
    func installUI() {
        //对HomeView实例化
        homeView = HomeView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64))
        self.view.addSubview(homeView!)
        //同步分组信息
        homeView?.dataArray = dataArray
        //进行homeView布局
        homeView?.updateLayout()
        //进行导航功能按钮创建
        installNavigationItem()
    }
    /**
        初始化导航栏方法
     */
    func installNavigationItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    /**
        导航功能交互方法
     */
    @objc func addGroup() {
        //创建UIAlertController实例，风格为alert风格
        let alertController = UIAlertController(title: "添加新分组", message: "添加的分组不能与已有分组重复或者为空", preferredStyle: .alert)
        //向警告框中添加一个文本输入框
        alertController.addTextField{ (textField) in
            textField.placeholder = "请输入新分组名称"
        }
        //向警告框中添加取消按钮
        let alertItem = UIAlertAction(title: "取消", style: .cancel, handler: {(UIAlertAction) in
            return
        })
        //向警告框中添加确定按钮
        let alertItemAdd = UIAlertAction(title: "确定", style: .default, handler: {(UIAlertAction)-> Void in
            //进行有效性判断
            var exist = false
            self.dataArray?.forEach({ (element) in
                //如果此分组已经存在或者用户输入为空，标志改为true
                if element == alertController.textFields?.first!.text || alertController.textFields?.first!.text?.count==0 {
                  exist = true
                }
            })
            if exist {
                return
            }
            //将用户的分组名称添加到dataArray中
            self.dataArray?.append(alertController.textFields!.first!.text!)
            //进行homeView的刷新
            self.homeView?.dataArray = self.dataArray
            self.homeView?.updateLayout()
            //将添加的分组写入数据库
            DataManager.saveGroup(name: alertController.textFields!.first!.text!)
        })
        alertController.addAction(alertItem)
        alertController.addAction(alertItemAdd)
        //展示警告框
        self.present(alertController, animated: true, completion: nil)
    }
    /**
     实现协议方法
     */
    func homeButtonClick(title:String) {
        let controller =  NoteListTableViewController()
        controller.name = title
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


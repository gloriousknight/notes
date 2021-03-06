//
//  NoteInfoViewController.swift
//  Notes
//
//  Created by BaronZhang on 2020/9/16.
//  Copyright © 2020 Glorious. All rights reserved.
//

import UIKit
//导入SnapKit自动布局框架
import SnapKit
class NoteInfoViewController: UIViewController {
    //当前编辑的记事数据模型
    var noteModel:NoteModel?
    //标题文本框
    var titleTextField:UITextField?
    //记事本内容文本视图
    var bodyTextView:UITextView?
    //记事本所属分组
    var group:String?
    var isNew = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //消除导航对布局的影响
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = UIColor.white
        self.title = "记事"
        //监听键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        //进行界面的加载
        installUI()
        //进行导航功能按钮的加载
        installNavigationItem()
    }
    
    /**
     定义导航功能按钮初始化方法
     */
    func installNavigationItem() {
        //创建两个导航功能按钮，用户保存与删除记事
        let itemSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNote))
        let itemDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        self.navigationItem.rightBarButtonItems = [itemSave,itemDelete]
    }
    /**
     定义添加记事方法
     */
    @objc func addNote() {
        //判断是否为新建记事
        if isNew {
            if titleTextField?.text != nil  && titleTextField!.text!.count > 0 {
                noteModel = NoteModel()
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                //将当前的时间格式化
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFormatter.string(from: Date())
                noteModel?.group = group
                DataManager.addNote(note: noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
            //进行更新记事逻辑编写
        }else{
            if titleTextField?.text != nil && titleTextField!.text!.count > 0{
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFormatter.string(from: Date())
                DataManager.updateNote(note: noteModel!)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    /**
     定义删除记事方法
     */
    @objc func deleteNote() {
        let alertController = UIAlertController(title: "警告", message: "是否确定删除这条记事？", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "删除", style: .destructive, handler: {(UIAlertAction) -> Void in
            //如果不是新建记事，就进行删除操作
            if !self.isNew {
                DataManager.deleteNote(note: self.noteModel!)
                self.navigationController?.popViewController(animated: true)
            
            }
        })
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
    }
    /**
     定义当键盘出现时需要调用的方法
     */
    @objc func keyBoardBeShow(notification:Notification) {
        let userInfo = notification.userInfo!
        let frameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        //获取到键盘的高度
        let height = frameInfo.cgRectValue.size.height
        //进行布局更新
        bodyTextView?.snp.updateConstraints({
            (maker) in maker.bottom.equalTo(-30-height)
        })
        UIView.animate(withDuration: 0.3, animations: { () in
            self.view.layoutIfNeeded()
            
        })
    }
    /**
     定义当键盘消失时需要调用的方法
     */
    @objc func keyBoardBeHidden(notification:Notification) {
        bodyTextView?.snp.updateConstraints({ (maker) in
            maker.bottom.equalTo(-30)
        })
        UIView.animate(withDuration: 0.3, animations: { () in
            self.view.layoutIfNeeded()
        })
    }
    
    //当用户点击屏幕的非文本区域需要收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bodyTextView?.resignFirstResponder()
        titleTextField?.resignFirstResponder()
    }
    //在析构方法中移除通知的监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /**
     定义界面加载方法
     */
    func installUI() {
        titleTextField = UITextField()
        self.view.addSubview(titleTextField!)
        titleTextField?.borderStyle = .none
        titleTextField?.placeholder = "请输入标题"
        titleTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(30)
            maker.left.equalTo(30)
            maker.right.equalTo(30)
            maker.height.equalTo(30)
        })
        let line = UIView()
        self.view.addSubview(line)
        line.backgroundColor = UIColor.gray
        line.snp.makeConstraints( {(maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(titleTextField!.snp.bottom).offset(5)
            maker.right.equalTo(-15)
            maker.height.equalTo(0.5)
        })
        bodyTextView = UITextView()
        bodyTextView?.layer.borderColor = UIColor.gray.cgColor
        bodyTextView?.layer.borderWidth = 0.5
        self.view.addSubview(bodyTextView!)
        bodyTextView?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(30)
            maker.top.equalTo(line.snp.bottom).offset(10)
            maker.right.equalTo(-30)
            maker.height.equalTo(0.5)
        })
        if !isNew {
            titleTextField?.text = noteModel?.title
            bodyTextView?.text = noteModel?.body
        }
    }

}

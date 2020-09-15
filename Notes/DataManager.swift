//
//  DataManager.swift
//  Notes
//
//  Created by BaronZhang on 2020/9/15.
//  Copyright © 2020 Glorious. All rights reserved.
//
//导入SQLiteSwift3模块

import SQLiteSwift3

class DataManager: NSObject {
    //创建一个数据库操作对象属性
    static var sqlHandle:SQLiteSwift3?
    //标记是否已经打开数据库
    static var isOpen = false
    //提供一个对分组数据进行存储的类方法
    class func saveGroup(name:String){
        //判断数据库是否打开，如果没有打开，则打开数据库进行操作
        if !isOpen{
            self.openDataBase()
        }
        //创建一个数据表字段对象
        let key = SQLiteKeyObject()
        //设置字段名
        key.name = "groupName"
        //设置字段名为字符串
        key.fieldType = TEXT
        //将字段修饰为唯一
        key.modificationType = UNIQUE
        //进行分组表的创建，如果已经存在分组，则不执行操作
        sqlHandle!.createTable(withName: "groupTable", keys: [key])
        //进行数据的插入
        sqlHandle!.insertData(["groupName":name], intoTable: "groupTable")
    }
    //提供一个获取所有分组数据的类方法
    class func getGroupData()->[String]{
        if !isOpen {
            self.openDataBase()
        }
        //创建查询请求对象
        let request = SQLiteSearchRequest()
        //查询结果容器数组
        var array = Array<String>()
        //进行查询数据操作
        sqlHandle?.searchData(withReeuest: request, inTable: "groupTable", searchFinish: {
            (success, dataArray) in
            //遍历查询到的数据，赋值到结果数组中
            dataArray?.forEach({ (element) in array.append(element.values.first! as! String)
            })
        })
        return array
    }
    //打开数据库的方法
    class func openDataBase(){
        //获取沙盒路径
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //进行文件名的拼接
        let file = path + "/DataBase.sqlite"
        //打开数据库，如果数据库不存在就会进行创建
        sqlHandle = SQLiteSwift3.openDB(file)
        //设置数据库打开标志
        isOpen = true
    }
}

//
//  HomeView.swift
//  Notes
//
//  Created by BaronZhang on 2020/9/14.
//  Copyright © 2020 Glorious. All rights reserved.
//

import UIKit

class HomeView: UIScrollView {
    //定义行间距
    let lineSpace = 25
    //定义列间距
    let interItemSpace = 15
    //存放分组标题数据
    var dataArray:Array<String>?
    //存放分组按钮数据
    var itemArray:Array<UIButton> = Array<UIButton>()
    //提供更新布局的方法
    func updateLayout(){
        //根据视图尺寸计算每个按钮的宽度
        let itemWidth = (self.frame.size.width-CGFloat(4*interItemSpace))/3
        //计算每个按钮的高度
        let itemHeight = itemWidth/3*4
        //现将界面上所有的按钮清除
        itemArray.forEach({(element) in
            element.removeFromSuperview()
        })
        //移除数组所有元素
        itemArray.removeAll()
        //进行布局
        if dataArray != nil && dataArray!.count>0{
            //遍历数据
            for index in 0..<dataArray!.count {
                let btn = UIButton(type: .system)
                btn.setTitle(dataArray![index], for: .normal)
                //计算按钮位置
                btn.frame = CGRect(x: CGFloat(interItemSpace) + CGFloat(index%3)*(itemWidth+CGFloat(interItemSpace)), y: CGFloat(lineSpace)+CGFloat(index/3)*(itemHeight+CGFloat(lineSpace)), width: itemWidth, height: itemHeight)
                btn.backgroundColor = UIColor(red: 1, green: 242/255.0, blue: 216/255.0, alpha: 1)
                //设置按钮圆角
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 15
                btn.setTitleColor(UIColor.gray, for: .normal)
                btn.tag = index
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                self.addSubview(btn)
                //将按钮实例添加到数组中
                itemArray.append(btn)
            }
            //设置滚动视图内容尺寸
            self.contentSize = CGSize(width: 0, height: itemArray.last!.frame.origin.y+itemArray.last!.frame.size.height+CGFloat(lineSpace))
        }
    }
    //按钮触发方法
    @objc func btnClick(btn:UIButton) {
        print(dataArray![btn.tag])
    }

}

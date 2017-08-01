//
//  GuideViewController.swift
//  day170801
//
//  Created by 赵国进 on 2017/8/1.
//  Copyright © 2017年 上海途宝网络科技. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    //外部接口
    var imageNamesArray = [String]()
    var textImageArray = [String]()
    
    fileprivate let kBaseTag = 10000
    fileprivate let kRotateRate: CGFloat = 1
    fileprivate let kScreenWidth = UIScreen.main.bounds.width
    fileprivate let kScreenHeight = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()

        buildInterface()
    }
    
    private func buildInterface(){
        view.backgroundColor = UIColor(red: 140.0/255, green: 1, blue: 1, alpha: 1)
        
        let mainScrollView = UIScrollView(frame: UIScreen.main.bounds)
        mainScrollView.isPagingEnabled = true
        mainScrollView.contentSize = CGSize(width: kScreenWidth * CGFloat(imageNamesArray.count), height: kScreenHeight)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        view.addSubview(mainScrollView)
        
        //有需要可以添加修饰图片，带透明度会好看一点
//        let t_imageView = UIImageView(frame: CGRect(x: 0, y: 330, width: kScreenWidth, height: 170.fitScreenWidth))
//        t_imageView.image = UIImage(named: "yun")
//        view.addSubview(t_imageView)
        
        //添加引导图
        for i in 0..<imageNamesArray.count{
            let rotateView = UIView(frame: CGRect(x: kScreenWidth *  CGFloat(i), y: 0, width: kScreenWidth, height: kScreenHeight * 2))
            rotateView.tag = kBaseTag + i
            mainScrollView.addSubview(rotateView)
            rotateView.alpha = i == 0 ? 1 : 0
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            imageView.image = UIImage(named: imageNamesArray[i])
            rotateView.addSubview(imageView)
            
            let textImageView = UIImageView(frame: CGRect(x: kScreenWidth * CGFloat(i), y: 50.fitScreenHeight(), width: kScreenWidth, height: 150.fitScreenHeight()))
            textImageView.tag = kBaseTag * 2 + i
            textImageView.image = UIImage(named: textImageArray[i])
            mainScrollView.addSubview(textImageView)
            
            //最后一页添加按钮
            if i == imageNamesArray.count - 1 {
                let button = UIButton(frame: CGRect(x: 20.fitScreenWidth(), y: kScreenHeight - 80.fitScreenHeight(), width: kScreenWidth - 20.fitScreenWidth() * 2, height: 50.fitScreenHeight()))
                button.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
                button.setImage(UIImage(named: "icon_next"), for: .normal)
                rotateView.addSubview(button)
            }
        }
        
    }
    
    //Mark: - 按钮点击
    func buttonClicked(sender:UIButton){
        print("按钮点击")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//Mark: - UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let xOffset = scrollView.contentOffset.x
        for i in 0..<imageNamesArray.count{
            let imageView = scrollView .viewWithTag(kBaseTag + i)
            //根据偏移量旋转
            let rotateAngle = -1 * 1 / kScreenWidth * xOffset * CGFloat.pi/2 * kRotateRate
            imageView?.layer.transform = CATransform3DMakeRotation(rotateAngle + CGFloat.pi/2 * CGFloat(i), 0, 0, 1)
            //根据偏移量位移（保证中心点始终都在屏幕下方中间）
            imageView?.center = CGPoint(x: 0.5 * kScreenWidth + xOffset, y: kScreenHeight)
        }
        
        //原来的代码固定了4张图进行计算，这里我也不知道怎么改灵活，暂时也固定吧
        let view1 = scrollView.viewWithTag(kBaseTag)
        let view2 = scrollView.viewWithTag(kBaseTag + 1)
        let view3 = scrollView.viewWithTag(kBaseTag + 2)
        let view4 = scrollView.viewWithTag(kBaseTag + 3)
        let textIV1 = scrollView.viewWithTag(kBaseTag * 2)
        let textIV2 = scrollView.viewWithTag(kBaseTag * 2 + 1)
        let textIV3 = scrollView.viewWithTag(kBaseTag * 2 + 2)
        let textIV4 = scrollView.viewWithTag(kBaseTag * 2 + 3)
        
        //调节透明度
        let xOffsetMore = xOffset * 1.5 > kScreenWidth ? kScreenWidth : xOffset * 1.5
        if xOffset < kScreenWidth {
            view1?.alpha = (kScreenWidth - xOffsetMore) / kScreenWidth
            textIV1?.alpha = (kScreenWidth - xOffsetMore) / kScreenWidth
        }
        if xOffset <= kScreenWidth  {
            view2?.alpha = xOffsetMore / kScreenWidth
            textIV2?.alpha = xOffset / kScreenWidth
        }
        if xOffset > kScreenWidth && xOffset <= kScreenWidth * 2 {
            view2?.alpha = (kScreenWidth * 2 - xOffset) / kScreenWidth
            view3?.alpha = (xOffset - kScreenWidth) / kScreenWidth
            textIV2?.alpha = (kScreenWidth * 2 - xOffset) / kScreenWidth
            textIV3?.alpha = (xOffset - kScreenWidth) / kScreenWidth
        }
        if xOffset > kScreenWidth * 2 {
            view3?.alpha = (kScreenWidth * 3 - xOffset) / kScreenWidth
            view4?.alpha = (xOffset - kScreenWidth * 2) / kScreenWidth
            textIV3?.alpha = (kScreenWidth * 3 - xOffset) / kScreenWidth
            textIV4?.alpha = (xOffset - kScreenWidth * 2) / kScreenWidth
        }
        
        //调节背景色
        //调节背景色
        if (xOffset < kScreenWidth && xOffset > 0) {
            view.backgroundColor = UIColor(red: (140 - 40.0 / kScreenWidth * xOffset) / 255.0, green: (255 - 25.0 / kScreenWidth * xOffset) / 255.0, blue: (255 - 100.0 / kScreenWidth * xOffset) / 255.0, alpha: 1)
            
        }else if (xOffset >= kScreenWidth && xOffset < kScreenWidth * 2){
            view.backgroundColor = UIColor(red: (100 + 30.0 / kScreenWidth * (xOffset - kScreenWidth))/255.0, green: (230-40.0 / kScreenWidth * (xOffset - kScreenWidth)) / 255.0, blue: (155-5.0 / 320 * (xOffset - kScreenWidth)) / 255.0, alpha: 1)
            
        }else if (xOffset >= kScreenWidth * 2 && xOffset < kScreenWidth * 3){
            view.backgroundColor = UIColor(red: (130 - 50.0 / kScreenWidth * (xOffset - kScreenWidth * 2)) / 255.0, green: (190 - 40.0 / kScreenWidth * (xOffset - kScreenWidth * 2))/255.0, blue: (150 + 50.0 / kScreenWidth * (xOffset - kScreenWidth * 2)) / 255.0, alpha: 1)
            
        }else if (xOffset >= kScreenWidth * 3 && xOffset < kScreenWidth * 4){
            view.backgroundColor = UIColor(red: (80 - 10.0 / kScreenWidth * (xOffset - kScreenWidth * 3)) / 255.0, green: (150 - 25.0 / kScreenWidth*(xOffset - kScreenWidth * 3)) / 255.0, blue: (200 - 90.0 / kScreenWidth * (xOffset - kScreenWidth * 3)) / 255.0, alpha: 1)
        }
        
    }
    
}

//Mark: - 屏幕适配
extension Int {
    
    func fitScreenHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height - 64;
        let height : CGFloat = 667.0 - 64;
        let scale = screenHeight / height ;
        return scale * CGFloat(self);
    }
    
    func fitScreenWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width;
        let width : CGFloat = 375;
        let scale = screenWidth / width ;
        return scale * CGFloat(self);
    }
    
}

extension CGFloat {
    
    func fitScreenHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height - 64;
        let height : CGFloat = 667.0 - 64;
        let scale = screenHeight / height ;
        return scale * CGFloat(self);
    }
    
    func fitScreenWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.height;
        let width : CGFloat = 375;
        let scale = screenWidth / width ;
        return scale * CGFloat(self);
    }
    
}

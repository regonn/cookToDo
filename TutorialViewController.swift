//
//  TutorialViewController.swift
//  cookToDo
//
//  Created by 田上健太 on 3/11/15.
//  Copyright (c) 2015 SonicGarden. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {


    //@IBOutlet weak var tutorialScrollView: UIScrollView!


    var pageControl: UIPageControl!
    var tutorialScrollView: UIScrollView!
    var pageImagesArr = Array<String>();

    let C_NSUSERDEFAULT_FIRST_TIME = "isFirstTimeDone";

    override func viewDidLoad() {

        let width = self.view.frame.maxX, height = self.view.frame.maxY
        self.view.backgroundColor = UIColor.whiteColor()
        let pageSize = self.pageImagesArr.count;


        tutorialScrollView = UIScrollView(frame: self.view.frame)
        tutorialScrollView.showsHorizontalScrollIndicator = false;
        tutorialScrollView.showsVerticalScrollIndicator = false
        tutorialScrollView.pagingEnabled = true
        tutorialScrollView.delegate = self
        tutorialScrollView.contentSize = CGSizeMake(CGFloat(pageSize) * width, 0)
        self.view.addSubview(tutorialScrollView)


        for var i = 0; i < pageSize; i++ {
            let img:UIImage = UIImage(named:self.pageImagesArr[i])!;
            let iv:UIImageView = UIImageView(image:img);
            iv.frame = CGRectMake(CGFloat(i) * width, 0, width , height - 50);
            tutorialScrollView.addSubview(iv)
        }


        pageControl = UIPageControl(frame: CGRectMake(0, self.view.frame.maxY - 50, width, 50))
        pageControl.backgroundColor = UIColor.grayColor();
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        self.view.addSubview(pageControl)


        var button = UIButton(frame: CGRectMake(width-60, 40, 40, 40));
        button.backgroundColor = UIColor.grayColor();
        button.addTarget(self, action: "onClose:", forControlEvents:.TouchUpInside);
        button.setTitle("X", forState: UIControlState.Normal);
        button.layer.masksToBounds = true;
        button.layer.cornerRadius = 20.0
        self.view.addSubview(button);


        NSUserDefaults.standardUserDefaults().setBool(true, forKey: C_NSUSERDEFAULT_FIRST_TIME);
        NSUserDefaults.standardUserDefaults().synchronize();

    }


    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {


        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {

            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }


    func onClose(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil);
    }

    
    func isTutorialDone() ->Bool{
        let obj: Bool = NSUserDefaults.standardUserDefaults().boolForKey(C_NSUSERDEFAULT_FIRST_TIME);
        if (obj){
            return false;
        }
        return true;
    }
}

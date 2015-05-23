//
//  ViewController.swift
//  Matt Panzer
//
//  Created by Matt Panzer on 4/19/15.
//  Copyright (c) 2015 Matt Panzer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView?
    var pageControl: UIPageControl?
    var titles: [String]?
    var colors: [UIColor]?
    var images: [String]?
    var text: [String]?
    var pageViews: [UIView]?
    var pageCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor().MPLightGrey
        
        // All of the information we will need to create some beautiful MPCards
        self.titles = ["Welcome!", "About Me", "Education", "Interests", "Work", "This App", "Thanks"]
        self.colors = [UIColor().MPGreen, UIColor().MPDarkPurple, UIColor().MPIndigo, UIColor().MPPink, UIColor().MPBrown, UIColor().MPDarkOrange, UIColor().MPTeal]
        self.images = ["apple","user_male","student","laptop","work","about","happy"]
        self.text = ["WWDC 2015\n\nSwipe to learn more about me.",
                    "Hi, I'm Matt.\nI'm 16 years old, and I live just outside of NYC.\nI love developing for the iPhone, iPad, and Apple Watch.",
                    "I'm a junior in high school.\nI've taken all 3 programming courses my school offers.\n\nI've also taught myself many programming languages...\n...including Swift, which is totally awesome.",
                    "I love making apps that look cool and do awesome things.\nI'm an active member of my school's robotics team.\nI'm also the Tech editor of my school's newspaper.",
                    "I've worked on many apps with other teen developers.\nI occassionally build apps for clients.\nI produced my own website (mattpanzer.com)",
                    "This app is programmed completely in Swift.\nI used some of the awesome new features in Swift, as well as some other cool tricks, so be sure to check out my code.",
                    "I really appreciate you taking the time to review my app.\n\nHave a great day!"]
        
        // Keep track of how many cards we will have
        self.pageCount = titles?.count
        
        // Type inference is so cool!
        var viewWidth = self.view.frame.size.width
        var viewHeight = self.view.frame.size.height
        
        // Our scrollView will contain all of our MPCards
        self.scrollView = UIScrollView(frame: CGRect(x: viewWidth*0.1, y: (viewHeight-viewWidth)/2.0, width: viewWidth*0.8, height: viewWidth))
        self.scrollView?.delegate = self
        self.scrollView?.pagingEnabled = true
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.clipsToBounds = false
        self.view.addSubview(self.scrollView!)
        
        // Our pageControl will be a nice visual indicator
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: viewHeight-20, width: viewWidth, height: 20))
        self.pageControl?.currentPage = 0
        self.pageControl?.numberOfPages = self.pageCount!
        self.pageControl?.hidesForSinglePage = true;
        self.pageControl?.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl?.currentPageIndicatorTintColor = self.colors![0]
        self.view.addSubview(self.pageControl!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var pagesScrollViewSize : CGSize = self.scrollView!.frame.size
        self.scrollView!.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(self.pageCount!), pagesScrollViewSize.height)
        
        // Load all pages we have a title for
        for i in 0..<self.pageCount! {
            self.loadPage(i)
        }
    }
    
    func loadPage(page:Int) {
        if page < 0 || page >= self.titles!.count {
            // If it's outside the range of what we have to display, then do nothing
            return
        }
        var pageView = self.pageViews?[page]
        var bounds = self.scrollView?.bounds
        bounds!.origin.x = bounds!.size.width * CGFloat(page)
        bounds!.origin.y = 0.0
        bounds = CGRectInset(bounds!, bounds!.size.width*0.05, bounds!.size.height*0.05)
        
        var image = UIImage(named: self.images![page])
        var card : MPCard = MPCard(frame: bounds!, headerColor: self.colors![page], bodyText: self.text![page], image:image!)
        card.setTitle(self.titles?[page])
        
        //Parallax effect
        var verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -50
        verticalMotionEffect.maximumRelativeValue = 50
        var horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -50
        horizontalMotionEffect.maximumRelativeValue = 50
        var group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect];
        card.addMotionEffect(group)
        
        self.scrollView?.addSubview(card)
        self.pageViews?[page] = card
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Calculates what MPCard, or page, the user is currently viewing
        var pageWidth = self.scrollView!.frame.size.width
        var page = Int(floor((self.scrollView!.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        self.pageControl?.currentPageIndicatorTintColor = self.colors![page]
        self.pageControl?.currentPage = page
    }
    
    // A custom UIView subclass to display our information
    class MPCard: UIView {
        var headerView: UILabel?
        var textView: UITextView?
        var imageView: UIImageView?
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.whiteColor()
            self.clipsToBounds = false
            self.layer.shadowColor = UIColor.grayColor().CGColor
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 3.0
            self.layer.shadowOffset = CGSize(width: 2, height: 4)
            var width = self.frame.width
            var height = self.frame.height
            self.headerView = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: height/7))
            self.headerView?.textAlignment = NSTextAlignment.Center
            self.headerView?.textColor = UIColor.whiteColor()
            self.headerView?.font = UIFont(name: "HelveticaNeue-Medium", size: self.headerView!.frame.height/2)
            self.headerView?.backgroundColor = UIColor.clearColor()
            self.addSubview(self.headerView!)
            
            self.imageView = UIImageView(frame: CGRect(x: 0, y: height/7, width: self.frame.width, height: 2.5*height/7))
            var oldFrame = self.imageView?.frame
            self.imageView?.frame = CGRectInset(oldFrame!, 10, 10)
            self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            self.addSubview(self.imageView!)
            
            self.textView = UITextView(frame: CGRect(x: 0, y: 3.5*height/7, width: self.frame.width, height: 3.5*height/7))
            self.textView?.textAlignment = NSTextAlignment.Center
            self.textView?.font = UIFont(name: "HelveticaNeue", size: self.headerView!.frame.height/3)
            self.textView?.editable = false
            var textFrame = self.textView?.frame
            self.textView?.frame = CGRectInset(textFrame!, 10, 0)
            self.userInteractionEnabled = false
            self.addSubview(self.textView!)
        }
        // So convenient!
        convenience init(frame: CGRect, headerColor: UIColor) {
            self.init(frame: frame)
            self.headerView?.backgroundColor = headerColor
        }
        
        convenience init(frame: CGRect, headerColor: UIColor, bodyText: String) {
            self.init(frame:frame, headerColor:headerColor)
            self.textView?.text = bodyText
        }
        
        convenience init(frame: CGRect, headerColor: UIColor, bodyText: String, image: UIImage) {
            self.init(frame:frame, headerColor:headerColor, bodyText:bodyText)
            self.imageView?.image = image
        }
        
        func setTitle(title: String?) {
            self.headerView?.text = title
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }

}

// Let's use prettier colors :)
extension UIColor {
    convenience init?(hex: String?){
        var rgbValue: CUnsignedLongLong = 0
        var scanner = NSScanner(string: hex!)
        if hex?.hasPrefix("#") == true {scanner.scanLocation = 1}
        scanner.scanHexLongLong(&rgbValue)
        var color = UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x0000FF)/255.0, alpha: 1.0)
        self.init(CGColor: color.CGColor)
    }
    var MPRed: UIColor          {return UIColor(hex: "#F44336")!}
    var MPPink: UIColor         {return UIColor(hex: "#E91E63")!}
    var MPPurple: UIColor       {return UIColor(hex: "#9C27B0")!}
    var MPDarkPurple: UIColor   {return UIColor(hex: "#673AB7")!}
    var MPIndigo: UIColor       {return UIColor(hex: "#3F51B5")!}
    var MPBlue: UIColor         {return UIColor(hex: "#2196F3")!}
    var MPCyan: UIColor         {return UIColor(hex: "#00BCD4")!}
    var MPTeal: UIColor         {return UIColor(hex: "#009688")!}
    var MPGreen: UIColor        {return UIColor(hex: "#4CAF50")!}
    var MPLightGreen: UIColor   {return UIColor(hex: "#8BC34A")!}
    var MPYellow: UIColor       {return UIColor(hex: "#FFEB3B")!}
    var MPLightOrange: UIColor  {return UIColor(hex: "#FFC107")!}
    var MPOrange: UIColor       {return UIColor(hex: "#FF9800")!}
    var MPDarkOrange: UIColor   {return UIColor(hex: "#FF5722")!}
    var MPBrown: UIColor        {return UIColor(hex: "#795548")!}
    var MPGrey: UIColor         {return UIColor(hex: "#9E9E9E")!}
    var MPLightGrey: UIColor    {return UIColor(hex: "#EEEEEE")!}
    var MPDarkGrey: UIColor     {return UIColor(hex: "#424242")!}
}


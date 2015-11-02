//
//  LayoutController.swift
//

import UIKit

let timeStart = 6
let timeEnd = 18

var goalText = [String]()
let goalCategory = ["Career / Business", "Finance", "Spirituality", "Health / Fitness", "Learning / Creativity", "Love / Relationships", "Family / Friends"]
let images = ["career","finance","spirituality","health","creativity","social","family"]
var goalComplete = [Int]()
var loadParseFirstTime = true

let colorsArray = [
    UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0), //teal color
    UIColor(red: 222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0), //yellow color
    UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0), //red color
    UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0), //orange color
    UIColor(red: 77/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1.0), //dark color
    UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0), //purple color
    UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), //green color
]

let kMainHorizontalMargin: CGFloat = 30.0
let kMainVerticalMargin: CGFloat = 60.0

let kButtonSize: CGFloat = 25.0
let kButtonTopMargin: CGFloat = 30.0
let kButtonHorizontalMargin: CGFloat = 90.0
let sectionInsets = UIEdgeInsets(top: 0, left: kMainHorizontalMargin, bottom: 0, right: kMainHorizontalMargin)



class MorningGoalsLayoutController: UICollectionViewController {
    
    var currentCell : Int!
    var loadingView = UIView()
    
    var settingsView: UIView!
    var charCount: UILabel!
    var settingsTextView: UITextView!
    var settingsLabel: UILabel!
    
    @IBOutlet var collectionView1: UICollectionView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let isDay = checkTime()
        if(!isDay){
            self.performSegueWithIdentifier("segueToNight", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sunButton = UIButton.init(frame: CGRect(x: kButtonHorizontalMargin, y: kButtonTopMargin, width: kButtonSize, height: kButtonSize))
        sunButton.setImage(UIImage(named: "sunFill"), forState: UIControlState.Normal)
        view.addSubview(sunButton)
        
        let moonButton = UIButton.init(frame: CGRect(x: CGRectGetWidth(self.view.frame) - kButtonHorizontalMargin - kButtonSize, y: kButtonTopMargin, width: kButtonSize, height: kButtonSize))
        moonButton.addTarget(self, action: "moonButtonDidPress", forControlEvents: UIControlEvents.TouchUpInside)
        moonButton.setImage(UIImage(named: "moon"), forState: UIControlState.Normal)
        view.addSubview(moonButton)
        
        let changeButton   = UIButton(type: UIButtonType.System) as UIButton
        changeButton.frame = CGRectMake(kButtonHorizontalMargin, CGRectGetHeight(self.view.frame)-42 , kButtonSize, kButtonSize)
        changeButton.setImage(UIImage(named: "change"), forState: UIControlState.Normal)
        changeButton.addTarget(self, action: "change", forControlEvents: UIControlEvents.TouchUpInside)
        changeButton.tintColor = UIColor(red: 30.0/255, green: 185.0/255, blue: 213.0/255, alpha: 1.0)
        self.view.addSubview(changeButton)
        
        let helpButton   = UIButton(type: UIButtonType.System) as UIButton
        helpButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - kButtonHorizontalMargin, CGRectGetHeight(self.view.frame)-42 , kButtonSize, kButtonSize)
        helpButton.setImage(UIImage(named: "change"), forState: UIControlState.Normal)
        helpButton.addTarget(self, action: "logout", forControlEvents: UIControlEvents.TouchUpInside)
        helpButton.tintColor = UIColor(red: 30.0/255, green: 185.0/255, blue: 213.0/255, alpha: 1.0)
        self.view.addSubview(helpButton)
        
        activityLoaderIndicator()
        currentCell = 0
        loadContentFromParse()
    }
    
    func activityLoaderIndicator() {
        loadingView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        loadingView.backgroundColor = UIColor.whiteColor()
        loadingView.alpha = 0.8
        loadingView.layer.cornerRadius = 10
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.grayColor()
        textLabel.text = "Load content"
        
        loadingView.addSubview(activityView)
        loadingView.addSubview(textLabel)
        
        self.view.addSubview(loadingView)
    }
    
    func loadContentFromParse(){
        let query = PFQuery(className:"Goal")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.addAscendingOrder("priority")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as [PFObject]! {
                    if(loadParseFirstTime){
                        for object in objects {
                            goalText.append(object["title"] as! (String))
                            goalComplete.append(0)
                        }
                        loadParseFirstTime = false
                    }else{
                        var i = 0
                        for object in objects {
                            goalText[i] = (object["title"] as! (String))
                            goalComplete[i] = (0)
                            i++
                        }
                    }
                    self.collectionView?.reloadData()
                    self.loadingView.removeFromSuperview()
                }
            } else {
                print("Error: \(error!)")
            }
        }
    }
    
    func change(){
        let list = collectionView?.visibleCells()
        for cell in list! {
            let center = self.view.center
            var frame = cell.frame
            frame.origin.x -= (collectionView?.contentOffset.x)!
            
            if(CGRectGetMinX(frame) <= center.x && CGRectGetMaxX(frame) > center.x){
                currentCell = (collectionView?.indexPathForCell(cell)?.row)!
                print(currentCell)
            }
            print(goalText)
            print(goalCategory)
            print(goalComplete)
        }
        
        self.view.addSubview(self.loadingView)
        settingsView = UIView.init(frame: CGRectMake(30, 60, CGRectGetWidth(self.view.frame)-60, CGRectGetHeight(self.view.frame)-120))
        settingsView.backgroundColor = colorsArray[currentCell]
        settingsView.layer.cornerRadius = 10
        
        settingsLabel = UILabel.init(frame: CGRectMake(20, 30, settingsView.frame.size.width-40, 60))
        settingsLabel.text = "Change your goal in category: " + goalCategory[currentCell]
        settingsLabel.textColor = UIColor.whiteColor()
        settingsLabel.textAlignment = NSTextAlignment.Center
        settingsLabel.numberOfLines = 0
        settingsView.addSubview(settingsLabel)
        
        settingsTextView = UITextView.init(frame: CGRectMake(20, CGRectGetMaxY(settingsLabel.frame), CGRectGetWidth(settingsView.frame)-40, CGRectGetHeight(settingsView.frame)-20-60-70))
        settingsTextView.text = goalText[currentCell]
        settingsTextView.textColor = UIColor.whiteColor()
        settingsTextView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        settingsTextView.layer.borderWidth = 1
        settingsTextView.layer.cornerRadius = 5
        settingsTextView.layer.borderColor = UIColor.whiteColor().CGColor
        settingsTextView.textAlignment = NSTextAlignment.Center
        settingsTextView.font = UIFont(name: "arial", size: 18)
        settingsView.addSubview(settingsTextView)
        
        charCount = UILabel.init(frame: CGRectMake(CGRectGetMinX(settingsTextView.frame), CGRectGetMaxY(settingsTextView.frame)-25,  CGRectGetWidth(settingsTextView.frame), 20))
        charCount.textAlignment = NSTextAlignment.Center
        charCount.textColor = UIColor.whiteColor()
        charCount.text = "0/140"
        settingsView.addSubview(charCount)
        
        let saveButton = UIButton.init(frame: CGRectMake(20, CGRectGetMaxY(settingsTextView.frame)+13, (CGRectGetWidth(settingsView.frame)-40-10)/2,44 ))
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "saveButtonDidPress", forControlEvents: UIControlEvents.TouchUpInside)
        settingsView.addSubview(saveButton)
        
        let cancelButton = UIButton.init(frame: CGRectMake(CGRectGetMaxX(saveButton.frame)+10, CGRectGetMaxY(settingsTextView.frame)+13, (CGRectGetWidth(settingsView.frame)-40-10)/2,44 ))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "cancelButtonDidPress", forControlEvents: UIControlEvents.TouchUpInside)
        settingsView.addSubview(cancelButton)
        self.view.addSubview(settingsView)
    }
    
    func checkTime() -> Bool{
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        let time = Int(dateFormatter.stringFromDate(NSDate()))
        if(timeStart <= time && time < timeEnd){
            return true //day - true
        }else{
            return false //night - false
        }
    }
    
    func moonButtonDidPress(){
        let isDay = checkTime()
        if(isDay){
            let alert = UIAlertController(title: "Time is not come", message: "You can go to night mode after 6pm", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            self.performSegueWithIdentifier("segueToNight", sender: nil)
        }
    }
    
    func saveButtonDidPress(){
        let query = PFQuery(className:"Goal")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("priority", equalTo:currentCell+1)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
            } else {
                let id = object!.objectId!
                let query2 = PFQuery(className:"Goal")
                query2.getObjectInBackgroundWithId(id) {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else if let object = object {
                        object["title"] = self.settingsTextView.text
                        object.saveInBackground()
                        self.loadContentFromParse()
                        self.settingsView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func cancelButtonDidPress(){
        self.loadingView.removeFromSuperview()
        self.settingsView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: UICollectionViewDataSource
extension MorningGoalsLayoutController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalText.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.tag = indexPath.row
        cell.layer.cornerRadius = 10
        cell.backgroundColor = colorsArray[indexPath.row]
        cell.cellImage.image = UIImage(named: images[indexPath.row])
        cell.cellImage.clipsToBounds = true
        cell.cellImage.layer.cornerRadius = (CGRectGetWidth(self.view.frame) - 60 - 50)/2
        cell.cellLabel.text = goalCategory[indexPath.row]
        cell.cellTextView.text = goalText[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MorningGoalsLayoutController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: CGRectGetWidth(UIScreen.mainScreen().bounds)-kMainHorizontalMargin*2, height: CGRectGetHeight(UIScreen.mainScreen().bounds)-kMainVerticalMargin*2)
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}
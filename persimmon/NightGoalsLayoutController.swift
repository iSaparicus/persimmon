//
//  LayoutController.swift
//

import UIKit

class NightGoalsLayoutController: UICollectionViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    
    var currentCell : Int!
    var loadingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let sunButton = UIButton.init(frame: CGRect(x: kButtonHorizontalMargin, y: kButtonTopMargin, width: kButtonSize, height: kButtonSize))
        sunButton.setImage(UIImage(named: "sun"), forState: UIControlState.Normal)
        sunButton.addTarget(self, action: "sunButtonDidPress", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(sunButton)
        
        let moonButton = UIButton.init(frame: CGRect(x: CGRectGetWidth(self.view.frame) - kButtonHorizontalMargin - kButtonSize, y: kButtonTopMargin, width: kButtonSize, height: kButtonSize))
        moonButton.setImage(UIImage(named: "moonFill"), forState: UIControlState.Normal)
        view.addSubview(moonButton)
        
        let helpButton   = UIButton(type: UIButtonType.System) as UIButton
        helpButton.frame = CGRectMake(kButtonHorizontalMargin, CGRectGetHeight(self.view.frame)-42 , kButtonSize, kButtonSize)
        helpButton.setImage(UIImage(named: "change"), forState: UIControlState.Normal)
        helpButton.addTarget(self, action: "helpButtonDidPress", forControlEvents: UIControlEvents.TouchUpInside)
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
                    var i = 0
                    for object in objects {
                        goalText[i] = String(object["title"])
                        i++
                    }
                    self.collectionView?.reloadData()
                    self.loadingView.removeFromSuperview()
                }
            } else {
                print("Error: \(error!)")
            }
        }
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
    
    func sunButtonDidPress(){
        let isDay = checkTime()
        if(!isDay){
            let alert = UIAlertController(title: "Time is not come", message: "You can go to morning mode after 6am", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            self.performSegueWithIdentifier("segueToNight", sender: nil)
        }
    }
    
    @IBAction func yesButtonTouch(sender: UIButton) {
        print("da")
        currentCellNow()
    }
    
    @IBAction func noButtonTouch(sender: UIButton) {
        print("net")
        currentCellNow()
    }
    
    func currentCellNow(){
        let list = collectionView?.visibleCells()
        for cell in list! {
            let center = self.view.center
            var frame = cell.frame
            frame.origin.x -= (collectionView?.contentOffset.x)!
            
            if(CGRectGetMinX(frame) <= center.x && CGRectGetMaxX(frame) > center.x){
                currentCell = (collectionView?.indexPathForCell(cell)?.row)!
            }
        }
        print(currentCell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: UICollectionViewDataSource
extension NightGoalsLayoutController {
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
        cell.cellImageOpacityView.layer.cornerRadius = (self.view.frame.size.width - 60 - 50)/2
        cell.cellTextView.text = goalText[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension NightGoalsLayoutController: UICollectionViewDelegateFlowLayout {
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

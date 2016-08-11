//
//  LobbyViewController.swift
//
//
//  Created by Milton Leung on 2016-06-23.
//
//

import UIKit

class LobbyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var player3: UILabel!
    @IBOutlet weak var player4: UILabel!
    @IBOutlet weak var player5: UILabel!
    @IBOutlet weak var player6: UILabel!
    
    @IBOutlet weak var status1: UIButton!
    @IBOutlet weak var status2: UIButton!
    @IBOutlet weak var status3: UIButton!
    @IBOutlet weak var status4: UIButton!
    @IBOutlet weak var status5: UIButton!
    @IBOutlet weak var status6: UIButton!
    
    @IBOutlet weak var moviesButton: UIButton!
    @IBOutlet weak var celebritiesButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    @IBOutlet weak var famousButton: UIButton!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var avatar1: UIView!
    @IBOutlet weak var avatar2: UIView!
    @IBOutlet weak var avatar3: UIView!
    @IBOutlet weak var avatar4: UIView!
    @IBOutlet weak var avatar5: UIView!
    @IBOutlet weak var avatar6: UIView!
    
    var playerLabels:[UILabel]?
    var avatarViews:[UIView]?
    var statusButton:[UIButton]?
    var stockCategories:[UIButton]?
    
    var roomName:String?
    
    var rand:Int?
    var players:[String]?
    var avatars:[[String]]?
    var ready:[String]?
    
    var isReady:Bool = false
    var canStart:Bool = false
    var timer = NSTimer()
    var categorySelected = false
    var category:String?
    
    var timerRunning:Bool = false
    
    var done:[String: AnyObject]?
    
    var modules:[String: AnyObject]?
    var selectedModule:AnyObject?
    var selectedName:String?
    var selectedList: [String]?
    
    var publicList:[String: AnyObject]?
    var privateList:[String: AnyObject]?
    var isPublic:Bool = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var showingLabel: UIButton!
    @IBOutlet weak var expand: UIButton!
    
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var readyButton: UIButton!
    @IBAction func readyButton(sender: UIButton) {
        if isReady == false {
            isReady = true
            sender.selected = true
            if !ready!.contains(myName) {
                ready?.append(myName)
            }
        } else {
            isReady = false
            sender.selected = false
            if ready!.contains(myName) {
                let index = ready?.indexOf(myName)
                ready?.removeAtIndex(index!)
            }
        }
        ModelInterface.sharedInstance.iamready(roomName!, ready: ready!)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        willEnterBackground()
        self.performSegueWithIdentifier("roomsSegue", sender: nil)
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButton(sender: AnyObject) {
        
        if canStart == true && categorySelected == true {
            if timerRunning == true {
                invalidateTimer()
                ModelInterface.sharedInstance.startGame(roomName!, startTime: 0)
            } else {
                invalidateTimer()
                //            startButton.hidden = true
                startButton.setTitle("", forState: .Normal)
                timerRunning = true
                timerLabel.text = "\(countDownTime)"
                
                
                let startTime = Int(NSDate().timeIntervalSince1970) + countDownTime
                ModelInterface.sharedInstance.startGame(roomName!, startTime: startTime)
                countdownView.hidden = false
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LobbyViewController.updateCountdown), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            for button in stockCategories! {
                button.hidden = false
            }
            expand.hidden = true
            showingLabel.hidden = true
            collectionView.hidden = true
        case 1:
            for button in stockCategories! {
                button.hidden = true
            }
            collectionView.hidden = false
            expand.hidden = false
            showingLabel.hidden = false
            collectionView.flashScrollIndicators()
        default:
            break;
        }
    }
    
    @IBAction func stockCategorySelect(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            if isLeader == true {
                categorySelected = false
                startButton.alpha = 0.5
            }
        } else {
            if isLeader == true {
                sender.selected = true
                for button in stockCategories! {
                    if button != stockCategories![sender.tag] {
                        button.selected = false
                    }
                }
                categoryAction(stockLists[sender.tag])
            }
        }
    }
    
    func setConstraints() {
        self.collectionViewFullBottom.active = false
    }
    
    @IBOutlet weak var collectionViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var collectionViewFullBottom: NSLayoutConstraint!
    @IBAction func expand(sender: UIButton) {
        self.view.layoutIfNeeded()
        if sender.selected {
            sender.selected = false
            sender.setImage(UIImage(named: "expand"), forState: .Normal)
            UIView.animateWithDuration(0.25, animations: { _ in
                self.readyButton.hidden = false
                self.collectionViewBottom.active = true
                self.collectionViewFullBottom.active = false
                self.view.layoutIfNeeded()
                }, completion: nil)
            
        } else {
            sender.selected = true
            sender.setImage(UIImage(named: "collapse"), forState: .Normal)
            UIView.animateWithDuration(0.25, animations: { _ in
                self.readyButton.hidden = true
                
                self.collectionViewBottom.active = false
                self.collectionViewFullBottom.active = true
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    
    @IBAction func showingLabel(sender: UIButton) {
        items = ["add"]
        itemsImage = ["Add"]
        if sender.selected {
            sender.selected = false
            sender.setTitle("showing public lists", forState: .Normal)
            setLists(publicList!)
            isPublic = true
            
        } else {
            sender.selected = true
            sender.setTitle("showing private lists", forState: .Normal)
            setPrivateLists(privateList!)
            isPublic = false
        }
    }
    
    func categoryAction(listName: String) {
        selectedList = NSUserDefaults.standardUserDefaults().arrayForKey("\(listName)") as? [String]
        
        
        var temp_done = [Int]()
        
        if (self.done?.indexForKey("done\(listName)")) != nil {
            temp_done = self.done!["done\(listName)"] as! [Int]
        }
        
        repeat {
            self.rand = Int(arc4random_uniform(UInt32(selectedList!.count)))
        } while temp_done.contains(self.rand!)
        temp_done.append(self.rand!)
        ModelInterface.sharedInstance.updateDone(self.roomName!, done: temp_done, category: listName)
        if isLeader {
            self.categorySelected = true
            self.category = listName
        }
        
        let currentPlayer = self.players![(self.rand! % (self.players?.count)!)]
        ModelInterface.sharedInstance.updateTurn(self.roomName!, currentSelection: self.rand!, currentPlayer: currentPlayer, category: self.category!)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setWhiteGradientBackground()
        
        playerLabels = [player1 , player2 , player3 , player4 , player5 , player6]
        avatarViews = [avatar1, avatar2, avatar3, avatar4, avatar5, avatar6]
        statusButton = [status1 , status2 , status3 , status4 , status5 , status6]
        stockCategories = [moviesButton, famousButton, celebritiesButton, tvButton]
        
        roomNameLabel.text = roomName
        
        setupGame("movies")
        
        clearPlayers()
        
        setConstraints()
        
        expand.hidden = true
        showingLabel.hidden = true
        collectionView.hidden = true
        
        countdownView.hidden = true
        
        for button in stockCategories! {
            button.selected = false
        }
        
        if isLeader == true {
            startButton.alpha = 0.5
        } else {
            startButton.hidden = true
        }
        canStart = false
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func invalidateTimer() {
        NSNotificationCenter.defaultCenter().postNotificationName("timeStop", object: nil)
        countdownView.hidden = true
        timer.invalidate()
        timerLabel.text = ""
        countDownTime = 8
        timerRunning = false
        startButton.setTitle("start", forState: .Normal)
        
    }
    
    func willEnterBackground() {
        if ready!.contains(myName) {
            let index = ready?.indexOf(myName)
            ready?.removeAtIndex(index!)
            
        }
        if players!.count == 1 {
            ModelInterface.sharedInstance.removeListener(roomName!)
        }
        if isLeader == true {
            if players!.count > 1 {
                var newLeader:String?
                for player in players! {
                    if player != myName {
                        newLeader = player
                        break
                    }
                }
                ModelInterface.sharedInstance.setLeader(roomName!, name: newLeader!)
            } else {
                ModelInterface.sharedInstance.removeLeader(roomName!)
            }
        }
        ModelInterface.sharedInstance.iamleaving(roomName!, ready: ready!)
        
    }
    
    func updateCountdown() {
        if countDownTime > 0 {
            if canStart == true {
                countDownTime -= 1
                timerLabel.text = "\(countDownTime)"
                NSNotificationCenter.defaultCenter().postNotificationName("timeChange", object: nil)
            } else {
                invalidateTimer()
            }
        } else {
            invalidateTimer()
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
            performSegueWithIdentifier("movieSegue", sender: nil)
            
        }
    }
    
    func clearPlayers() {
        for player in playerLabels! {
            player.hidden = true
        }
        
        for avatar in avatarViews! {
            avatar.hidden = true
        }
        
        for status in statusButton! {
            status.hidden = true
        }
    }
    
    func setupLabels() {
        clearPlayers()
        
        for i in 0...players!.count - 1 {
            playerLabels![i].hidden = false
            statusButton![i].hidden = false
            statusButton![i].setTitle("..", forState: UIControlState.Normal)
            playerLabels![i].text = players![i]
            avatarViews![i].hidden = false
            avatarViews![i].setAvatarGameView(avatars![i])
        }
        
        for player in ready! {
            if let index = players?.indexOf("\(player)") {
                statusButton![index].setTitle("👍🏼", forState: UIControlState.Normal)
            }
        }
    }
    
    @IBOutlet weak var leadingFirst: NSLayoutConstraint!
    @IBOutlet weak var leadingSecond: NSLayoutConstraint!
    @IBOutlet weak var leadingThird: NSLayoutConstraint!
    @IBOutlet weak var leadingFourth: NSLayoutConstraint!
    @IBOutlet weak var leadingFifth: NSLayoutConstraint!
    @IBOutlet weak var leadingSixth: NSLayoutConstraint!
    // Sets up the first person to go and the first thing to see
    func setupGame(category: String) {
        
        
        ModelInterface.sharedInstance.readRoom(roomName!, completion: { room -> Void in
            //            self.players = room["scores"] as? [String: [String]]
            if let playersData = room["players"] as? [String: AnyObject] {
                var existingPlayers = [String]()
                var existingAvatars = [[String]]()
                for (_, data) in playersData {
                    for (name, avatar) in data as! [String: [String]] {
                        existingPlayers.append(name)
                        existingAvatars.append(avatar)
                    }
                }
                self.players = existingPlayers
                self.avatars = existingAvatars
            }
            if let ready = room["ready"] as? [String] {
                self.ready = ready
                if ready.contains(myName) {
                    self.readyButton.selected = true
                } else {
                    self.readyButton.selected = false
                }
                
            } else {
                self.ready = [String]()
            }
            self.setupLabels()
            if let done = room["done"] as? [String: AnyObject] {
                self.done = done
            }
            if let category = room["category"] as? String {
                if !isLeader {
                    self.category = category
                    self.locateList(category)
                }
            }
            
            if let leader = room["leader"] as? String {
                if leader == myName {
                    isLeader = true
                    if self.timerRunning == false {
                        self.startButton.hidden = false
                        self.startButton.alpha = 0.5
                    }
                } else {
                    isLeader = false
                }
            }
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            if screenWidth == 414 {
                self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                self.scroller.showsHorizontalScrollIndicator = false
                self.scroller.scrollEnabled = false
                self.leadingFirst.constant = 8
                self.leadingSecond.constant = 13
                self.leadingThird.constant = 13
                self.leadingFourth.constant = 13
                self.leadingFifth.constant = 13
                self.leadingSixth.constant = 13
                self.updateViewConstraints()
            } else if screenWidth == 375 {
                self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                self.scroller.showsHorizontalScrollIndicator = false
                self.scroller.scrollEnabled = false
            } else if screenWidth < 375 {
                if self.players!.count <= 5 {
                    self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                    self.scroller.showsHorizontalScrollIndicator = false
                    self.scroller.scrollEnabled = false
                } else if self.players!.count > 5 {
                    self.scroller.contentSize = CGSizeMake(screenWidth * 1.18, 180)
                    self.scroller.showsHorizontalScrollIndicator = true
                    self.scroller.scrollEnabled = true
                }
            }
            
            var startTime = room["startTime"] as? Int
            
            if self.players!.count == self.ready!.count {
                self.canStart = true
                if self.timerRunning == false && self.categorySelected == true {
                    self.startButton.alpha = 1
                }
            } else {
                self.canStart = false
                if self.timerRunning == false {
                    self.startButton.alpha = 0.5
                }
                self.invalidateTimer()
                startTime = 0
            }
            
            
            
            let currentTime = Int(NSDate().timeIntervalSince1970)
            if startTime >= currentTime {
                countDownTime = startTime! - currentTime
                if isLeader == false {
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LobbyViewController.updateCountdown), userInfo: nil, repeats: true)
                    self.countdownView.hidden = false
                    self.timerLabel.text = "\(countDownTime)"
                }
            } else {
                self.invalidateTimer()
            }
            
        })
        ModelInterface.sharedInstance.fetchPublicLists( { modules -> Void in
            self.publicList = modules
            if self.isPublic {
                self.setLists(modules)
            }
        })
        
        ModelInterface.sharedInstance.fetchPrivateLists( { modules -> Void in
            self.privateList = modules
            if !self.isPublic {
                self.setLists(modules)
            }
        })
    }
    
    func setLists(modules: [String: AnyObject]) {
        self.modules = modules
        for (name, _) in modules {
            if !self.items.contains(name) {
                self.items.insert(name, atIndex: 1)
                let list = modules[name] as! [String: AnyObject]
                let image = list["icon"] as! String
                self.itemsImage.insert(image, atIndex: 1)
            }
        }
        self.collectionView.reloadData()
    }
    
    func showPrivateList(modules: [String: AnyObject]) -> Bool {
        let authors = modules["author"] as! [String]
        var tempSet = Set<String>()
        for author in authors {
            tempSet.insert(author)
        }
        for player in players! {
            tempSet.insert(player)
        }
        return tempSet.count < players!.count + authors.count
    }
    
    func setPrivateLists(modules: [String: AnyObject]) {
        self.modules = modules
        for (name, attributes) in modules {
            if !self.items.contains(name) && showPrivateList(attributes as! [String : AnyObject]) {
                self.items.insert(name, atIndex: 1)
                let list = modules[name] as! [String: AnyObject]
                let image = list["icon"] as! String
                self.itemsImage.insert(image, atIndex: 1)
            }
        }
        self.collectionView.reloadData()
    }
    
    func locateList(listName: String) {
        if stockLists.contains(listName) {
            selectedList = NSUserDefaults.standardUserDefaults().arrayForKey("\(listName)") as? [String]
        } else {
            let currentModule = modules![listName] as! [String: AnyObject]
            let key = currentModule["list"] as! String
            
            ModelInterface.sharedInstance.fetchSingleList(key, completion: { list -> Void in
                self.selectedList = list
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieSegue" {
            let game = segue.destinationViewController as! GameViewController
            game.roomName = roomName
            game.movies = selectedList
            game.category = category
            if isLeader == true {
                game.firstMovie = self.rand
            }
        } else if segue.identifier == "newListSegue" {
            let newList = segue.destinationViewController as! NewListViewController
            newList.players = players
        } else if segue.identifier == "buildListSegue" {
            let buildList = segue.destinationViewController as! BuildListViewController
            buildList.module = selectedModule
            buildList.moduleName = selectedName
            buildList.listIsPublic = isPublic
            buildList.delegate = self
        } else if segue.identifier == "selectListSegue" {
            let selectList = segue.destinationViewController as! SelectListViewController
            selectList.module = selectedModule
            selectList.moduleName = selectedName
            selectList.delegate = self
        }
        
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["add"]
    var itemsImage = ["Add"]
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.name.text = self.items[indexPath.item]
        cell.image.image = UIImage(named: self.itemsImage[indexPath.item])
        cell.backgroundColor = UIColor.clearColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if items[indexPath.item] == "add" {
            performSegueWithIdentifier("newListSegue", sender: nil)
        } else {
            selectedName = items[indexPath.item]
            selectedModule = modules!["\(items[indexPath.item])"]
            let currentAuthors = selectedModule!["author"] as! [String]
            if currentAuthors.contains(myName) {
                performSegueWithIdentifier("buildListSegue", sender: nil)
            } else {
                performSegueWithIdentifier("selectListSegue", sender: nil)
            }
            
            
        }
    }
}

extension LobbyViewController: SelectListViewControllerDelegate, BuildListViewControllerDelegate{
    func customCategoryAction(listName: String) {
        let currentModule = modules![listName] as! [String: AnyObject]
        let key = currentModule["list"] as! String
        if isLeader {
            self.categorySelected = true
            self.category = listName
        }
        ModelInterface.sharedInstance.fetchSingleList(key, completion: { listValue -> Void in
            var list = listValue
            
            var temp_done = [Int]()
            
            if (self.done?.indexForKey("done\(listName)")) != nil {
                temp_done = self.done!["done\(listName)"] as! [Int]
            }
            
            repeat {
                self.rand = Int(arc4random_uniform(UInt32(list.count)))
            } while temp_done.contains(self.rand!)
            temp_done.append(self.rand!)
            ModelInterface.sharedInstance.updateDone(self.roomName!, done: temp_done, category: listName)
            
            self.selectedList = list
            
            let currentPlayer = self.players![(self.rand! % (self.players?.count)!)]
            ModelInterface.sharedInstance.updateTurn(self.roomName!, currentSelection: self.rand!, currentPlayer: currentPlayer, category: self.category!)
        })
    }
}
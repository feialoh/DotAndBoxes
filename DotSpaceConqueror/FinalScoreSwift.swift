//
//  FinalScoreSwift.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 01/12/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import Foundation
import UIKit


protocol FinalScoreViewDelegate{
    func quitButtonTouched()
    func restartButtonTouched()
}



class FinalScoreView: UIView,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    @IBOutlet weak var finalScoreTable: UITableView!

    
    @IBOutlet weak var quitButton: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    
    @IBOutlet weak var winnerLabel: UILabel!
    
    
    var playerInfo: [[String:AnyObject]]!
    var view: UIView!
    var delegate : FinalScoreViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, playerDetails: [[String:AnyObject]], parentView:UIView)
    {
        
         print("\(playerDetails)")
        
        self.playerInfo = playerDetails
        
        super.init(frame:frame)
        self.view = Utilities.loadViewFromNib("FinalScoreView", atIndex: 0, aClass: type(of: self),parent:self) as! UIView
        self.view.frame = frame
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.view.isHidden = true
        finalScoreTable.register(UINib(nibName: "FinalScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreCell")
//        finalScoreTable.delegate = self
//        finalScoreTable.dataSource = self
        addSubview(self.view)
        parentView.addSubview(self)
        finalScoreTable.tableFooterView = UIView()
        showWinner()
    }
    
    
    func show()
    {
    self.view.isHidden = false
        
    self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    
    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
    }


    @IBAction func quitAction(_ sender: UIButton)
    {
//        self.view.hidden = true
//        self.removeFromSuperview()
        delegate?.quitButtonTouched()
    }
    
    
    @IBAction func restartAction(_ sender: UIButton)
    {
        self.view.isHidden = true
        self.removeFromSuperview()
        delegate?.restartButtonTouched()
        
    }
    
    //MARK:- UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return playerInfo.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! FinalScoreTableViewCell

        let playerString: String = playerInfo[(indexPath as NSIndexPath).row]["player"] as! String
        let scoreString: String = String(playerInfo[(indexPath as NSIndexPath).row]["fillCount"] as! Int)
        let labelColor:UIColor = playerInfo[(indexPath as NSIndexPath).row]["Color"] as! UIColor
        
        tableCell.playerName.text = Utilities.filterString(playerString)
        tableCell.scoreLabel.text = scoreString
        tableCell.playerName.textColor = labelColor
        tableCell.scoreLabel.textColor = labelColor
        tableCell.backgroundColor = UIColor.clear
//        tableCell?.menuItemLabel.text = menuItems.objectAtIndex(indexPath.row) as? String
        
        return tableCell
    }

    
    func showWinner()
    {

        let count1:Int = playerInfo[0]["fillCount"] as! Int
        let count2:Int = playerInfo[1]["fillCount"] as! Int
        
        var playerString: String!
        var winnerName:String
        
        if (count1 == count2)
        {
            winnerName = "Its a Tie"
        }
        else
        {
            playerString = playerInfo[0]["player"] as! String
            winnerName  = Utilities.filterString(playerString) + " is the winner"
        }
        
        
        let labelColor:UIColor = playerInfo[0]["Color"] as! UIColor
        
        winnerLabel.text = winnerName
        winnerLabel.textColor = labelColor


    }
    
}

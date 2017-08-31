//
//  DotSpaceConquerorTests.swift
//  DotSpaceConquerorTests
//
//  Created by feialoh on 19/10/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import XCTest
@testable import DotSpaceConqueror

class DotSpaceConquerorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        XCTAssertEqual("123Feialoh", getFilteredName("123Feialoh"))
        
        XCTAssertEqual("Feialoh".characters.count,7)
        
        var playerTitle: [[String:AnyObject]] = []
        
         playerTitle.append(["player":"Feialoh" as AnyObject,"id":1 as AnyObject,"fillCount":3 as AnyObject,"Color":UIColor.red])
         playerTitle.append(["player":"Vishnu" as AnyObject,"id":2 as AnyObject,"fillCount":7 as AnyObject,"Color":UIColor.white])
         playerTitle.append(["player":"Akhil" as AnyObject,"id":3 as AnyObject,"fillCount":5 as AnyObject,"Color":UIColor.gray])
         playerTitle.append(["player":"Binoj" as AnyObject,"id":4 as AnyObject,"fillCount":6 as AnyObject,"Color":UIColor.green])
        
        print("\(playerTitle)")
        
        playerTitle.sort {
            item1, item2 in
            let date1 = item1["fillCount"] as! Int
            let date2 = item2["fillCount"] as! Int
            return date1 > date2
        }
        

        
        print("\(playerTitle)")
        
        XCTAssertEqual("Vishnu",playerTitle[0]["player"] as? String)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getFilteredName(_ str:String) ->String
    {
        
        if str.range(of: "$#$#$-") != nil{
            let equalRange: Range = (str.range(of: "$#$#$-"))!
            let result:String = str.substring(from: equalRange.upperBound)
            return result
        }
        else
        {
            return str
        }
    }
    
    func testExample() {
    
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

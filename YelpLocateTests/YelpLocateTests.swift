//
//  YelpLocateTests.swift
//  YelpLocateTests
//
//  Created by Vahagn Nurijanyan on 2018-11-26.
//  Copyright © 2018 BABELONi INC. All rights reserved.
//

import XCTest
@testable import YelpLocate

class YelpLocateTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSortedItems() {
        if YelpLocate.shared.sortedState == .byDistance {
            for (index, _) in YelpLocate.shared.businesses.enumerated() {
                if index == 0 {
                    continue
                }
                XCTAssertLessThan(YelpLocate.shared.businesses[index - 1].distance, YelpLocate.shared.businesses[index].distance)
            }
        }
        else {
            for (index, _) in YelpLocate.shared.businesses.enumerated() {
                if index == 0 {
                    continue
                }
                XCTAssertLessThan(YelpLocate.shared.businesses[index - 1].name, YelpLocate.shared.businesses[index].name)
            }
        }
    }

}

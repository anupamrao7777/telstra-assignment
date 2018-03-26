//
//  TelstraTests.m
//  TelstraTests
//
//  Created by Anupam Rao on 19/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AFNetworking.h>
#import "THomeViewController.h"
@interface TelstraTests : XCTestCase

@property THomeViewController *homeViewController;

@end

@implementation TelstraTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _homeViewController = [[THomeViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testViewController {
    
    XCTAssertNotNil(_homeViewController, @"ViewController should not be a nil");
    
    XCTAssertNotNil(_homeViewController.view, @"ViewController should not be a nil");
    NSArray *subviews = _homeViewController.view.subviews;
    UITableView *tableView = nil;
    for (UIView *view in subviews) {
        if (view.class == [UITableView class]) {
            tableView = (UITableView *)view;
            break;
        }
    }
    XCTAssertNotNil(tableView, @"CollectionView should not be a nil");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  TelstraApiTest.m
//  Telstra
//
//  Created by Anupam Rao on 26/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFactResponse.h"
@interface TelstraApiTest : XCTestCase
@property TFactResponse *factsResponseManger;
@end

@implementation TelstraApiTest


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _factsResponseManger = [[TFactResponse alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFactsAPIConnection {
    //Check API connection gets strat or not.
    XCTestExpectation *expectation = [self expectationWithDescription:@"API Response callback"];
    [_factsResponseManger getFactsDataWithCompletionHandler:^(NSError *error) {
        XCTAssertNil(error, "Error should be nil");
        [expectation fulfill];
    }];
    
    //Wait 30 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

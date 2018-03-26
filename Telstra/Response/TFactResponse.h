//
//  TFactResponse.h
//  Telstra
//
//  Created by Anupam Rao on 22/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFactResponse : NSObject
@property(nonatomic, strong) NSMutableArray *factsArray;
@property(nonatomic, strong) NSString *navTitleString;

//Facts API method service call to get data
- (void)getFactsDataWithCompletionHandler:(void (^)(NSError *error))completionHandler;

@end

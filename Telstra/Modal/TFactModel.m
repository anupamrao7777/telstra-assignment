//
//  TFactModel.m
//  Telstra
//
//  Created by Anupam Rao on 20/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import "TFactModel.h"

@implementation TFactModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"factTitle": @"title",
                                                                  @"factDescription": @"description",
                                                                  @"factImageURL": @"imageHref"
                                                                  }];
}

@end

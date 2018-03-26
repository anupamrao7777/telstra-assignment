//
//  TFactModel.h
//  Telstra
//
//  Created by Anupam Rao on 20/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>

@interface TFactModel : JSONModel

@property (nonatomic) NSString*factTitle;
@property (nonatomic) NSString<Optional>*factDescription;
@property (nonatomic) NSString<Optional>*factImageURL;
@property (nonatomic) UIImage<Optional>*factImage;


@end

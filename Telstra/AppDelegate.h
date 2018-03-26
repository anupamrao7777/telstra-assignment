//
//  AppDelegate.h
//  Telstra
//
//  Created by Anupam Rao on 19/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


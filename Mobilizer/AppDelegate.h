//
//  AppDelegate.h
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end


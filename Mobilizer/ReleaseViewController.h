//
//  ReleaseViewController.h
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "AFNetworking.h"

@interface ReleaseViewController : UITableViewController

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) Project *project;

@end

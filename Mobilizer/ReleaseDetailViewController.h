//
//  ReleaseDetailViewController.h
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Release.h"
#import "Project.h"
#import "AFNetworking.h"

@interface ReleaseDetailViewController : UIViewController

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) Release *releaseObject;
@property (nonatomic, strong) Project *project;

@end

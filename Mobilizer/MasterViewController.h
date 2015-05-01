//
//  MasterViewController.h
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFNetworking.h"

@class ReleaseViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) ReleaseViewController *releaseViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end


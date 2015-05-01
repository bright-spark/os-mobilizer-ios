//
//  ReleaseViewController.m
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import "ReleaseViewController.h"
#import "ReleaseDetailViewController.h"
#import "AppDelegate.h"
#import "Release.h"
#import "Constants.h"

@interface ReleaseViewController ()

@property (nonatomic, strong) NSDictionary *releases;
@property (nonatomic, strong) NSMutableArray *releaseArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).manager;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    [self.activityIndicator startAnimating];
    
    [self fetchReleases];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator setHidden:[self.releaseArray count] > 0];
    UIEdgeInsets insets = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height,
                                           0.0,
                                           0.0,
                                           0.0);
    self.tableView.contentInset = insets;
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)setProject:(Project*)project {
    if (_project != project) {
        _project = project;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showRelease"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Release *releaseObj = self.releaseArray[indexPath.row];
        
        ReleaseDetailViewController *controller = (ReleaseDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setReleaseObject:releaseObj];
        [controller setProject:self.project];
        controller.title = [NSString stringWithFormat:@"%@ (%@)", [releaseObj valueForKey:@"name"], [[releaseObj valueForKey:@"alpha"] boolValue] ? @"Alpha" : @"Beta"];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self releaseArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *releaseName = [[self.releaseArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    NSNumber *alpha = [[self.releaseArray objectAtIndex:indexPath.row] valueForKey:@"alpha"];
    NSNumber *beta = [[self.releaseArray objectAtIndex:indexPath.row] valueForKey:@"beta"];
    
    if ([alpha boolValue]) {
        releaseName = [releaseName stringByAppendingString:@" (Alpha)"];
    } else if ([beta boolValue]) {
        releaseName = [releaseName stringByAppendingString:@" (Beta)"];
    }
    cell.textLabel.text = releaseName;
    
    return cell;
}

- (void) fetchReleases {
    [self.manager GET:[NSString stringWithFormat:@"http://%@/api/releases/ios/%@", kServerHost, self.project.repo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        self.releases = [jsonDict valueForKey:@"releases"];
        self.releaseArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [[[self releases] allKeys] count]; i++) {
            NSString *key = [[[self releases] allKeys] objectAtIndex:i];
            [self.releaseArray addObjectsFromArray:(NSArray *)[self.releases valueForKey:key]];
        }
        
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"build_number" ascending:NO];
        [self.releaseArray sortUsingDescriptors:[NSArray arrayWithObject:desc]];
        
        [self.tableView reloadData];
        [self.activityIndicator setHidden:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[operation.responseObject valueForKey:@"msg"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.activityIndicator setHidden:true];
    }];
}

@end

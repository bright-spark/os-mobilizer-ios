//
//  MasterViewController.m
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import "MasterViewController.h"
#import "ReleaseViewController.h"
#import "Project.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <GooglePlus/GooglePlus.h>

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.releaseViewController = (ReleaseViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).manager;
    
    [self.logoutButton setTarget:self];
    [self.logoutButton setAction:@selector(logout:)];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    [self.activityIndicator startAnimating];
    
    [self fetchProjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator setHidden:[self.projects count] > 0];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Project *project = self.projects[indexPath.row];
        
        ReleaseViewController *controller = (ReleaseViewController *)[[segue destinationViewController] topViewController];
        [controller setProject:project];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.projects[indexPath.row] name];
}

- (void)logout:(id)sender {
    [[GPPSignIn sharedInstance] signOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchProjects {
    [self.manager GET:[NSString stringWithFormat:@"http://%@/api/projects/ios", kServerHost] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *jsonArray = (NSArray *)responseObject;
        
        NSMutableArray *tempProjects = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in jsonArray) {
            Project *project = [[Project alloc] initWithDictionary:dic];
            [tempProjects addObject:project];
        }
        
        
        self.projects = [[NSArray alloc] initWithArray:tempProjects];
        tempProjects = nil;
        
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

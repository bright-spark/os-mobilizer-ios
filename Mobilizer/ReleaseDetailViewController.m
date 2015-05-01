//
//  ReleaseDetailViewController.m
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import "ReleaseDetailViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ReleaseDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ReleaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).manager;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:true];

    self.body.text = [self.releaseObject valueForKey:@"body"];
    [self.downloadButton addTarget:self action:@selector(downloadRelease:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRelease:(Release*)release {
    if (_releaseObject != release) {
        _releaseObject = release;
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

- (void)downloadRelease:(id)sender {
    [self.downloadButton setEnabled:false];
    [self.activityIndicator setHidden:false];
    [self.downloadButton setTitle:@"Downloading..." forState:UIControlStateNormal];
    [self.manager GET:[NSString stringWithFormat:@"http://%@/api/codesign/%@/%@/%@?url=%@", kServerHost, [self.project valueForKey:@"repo"], [[self.releaseObject valueForKey:@"alpha"] boolValue] ? @"alpha" : @"beta", [self.releaseObject valueForKey:@"build_number"], [[self.releaseObject valueForKey:@"alpha"] boolValue] ? [self.releaseObject valueForKey:@"alpha_download_link"] : [self.releaseObject valueForKey:@"beta_download_link"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self.downloadButton setEnabled:true];
        [self.activityIndicator setHidden:true];
        [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[responseObject valueForKey:@"url"]]];
        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[operation.responseObject valueForKey:@"msg"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.downloadButton setEnabled:true];
        [self.activityIndicator setHidden:true];
        [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    }];
}

@end

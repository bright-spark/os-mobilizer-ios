//
//  GoogleSignInViewController.m
//  Mobilizer
//
//  Created by Joshua on 9/4/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import "GoogleSignInViewController.h"
#import "AppDelegate.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface GoogleSignInViewController ()

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

@end

@implementation GoogleSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.scopes = @[ @"profile" ];
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error: (NSError *) error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.description
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"showHome" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showHome"]) {
        UISplitViewController *splitViewController = (UISplitViewController *)[segue destinationViewController];
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        navigationController.topViewController.navigationItem.hidesBackButton = YES;
        splitViewController.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
}

@end

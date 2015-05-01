//
//  GoogleSignInViewController.h
//  Mobilizer
//
//  Created by Joshua on 9/4/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientId = @"";

@class GPPSignInButton;

@interface GoogleSignInViewController : UIViewController <GPPSignInDelegate>

@end

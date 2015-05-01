//
//  Project.m
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import "Project.h"

@implementation Project

//The designated initializer
- (id)initWithName:(NSString *)aName platform:(NSString *)aPlatform repo:(NSString *)aRepo store:(NSNumber *)aStore testing:(NSNumber *)aTesting uri:(NSString *)aUri {
    self = [super init];
    
    if (self) {
        self.name = aName;
        self.platform = aPlatform;
        self.repo = aRepo;
        self.store = aStore;
        self.testing = aTesting;
        self.uri = aUri;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [self initWithName:dic[@"name"] platform:dic[@"platform"] repo:dic[@"repo"] store:dic[@"store"] testing:dic[@"testing"] uri:dic[@"uri"]];
    return self;
}

- (id)init {
    self = [self initWithName:@"Undefined" platform:@"Undefined" repo:@"Undefined" store:false testing:false uri:@"Undefined"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
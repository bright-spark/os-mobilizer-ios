//
//  Release.m
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import "Release.h"

@implementation Release

//The designated initializer
- (id)initWithName:(NSString *)aName body:(NSString *)aBody releaseDate:(NSString *)aReleaseDate {
    self = [super init];
    
    if (self) {
        self.name = aName;
        self.body = aBody;
        self.releaseDate = aReleaseDate;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [self initWithName:dic[@"name"] body:dic[@"body"] releaseDate:dic[@"release_date"]];
    return self;
}

- (id)init {
    self = [self initWithName:@"Undefined" body:@"Undefined" releaseDate:@"Undefined"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.name];
}

@end

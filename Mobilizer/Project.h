//
//  Project.m
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *platform;
@property (strong, nonatomic) NSString *repo;
@property (strong, nonatomic) NSNumber *store;
@property (strong, nonatomic) NSNumber *testing;
@property (strong, nonatomic) NSString *uri;

- (id)initWithName:(NSString *)aName
         platform:(NSString *)aPlatform
             repo:(NSString *)aRepo
            store:(NSNumber *)aStore
           testing:(NSNumber *)aStore
               uri:(NSString *)aUri;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
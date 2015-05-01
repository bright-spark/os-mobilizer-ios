//
//  Release.h
//  Mobilizer
//
//  Created by Joshua on 30/3/15.
//  Copyright (c) 2015 Redmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Release : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *releaseDate;

- (id)initWithName:(NSString *)aName
          body:(NSString *)aBody
              releaseDate:(NSString *)aReleaseDate;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

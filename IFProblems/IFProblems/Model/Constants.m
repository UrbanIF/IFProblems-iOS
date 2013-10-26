//
//  Constants.m
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import "Constants.h"

NSString * const kServiceURLString = @"http://problems.apiary.io/";

@implementation Constants

+ (NSURL *)serviceURL
{
    return [[NSURL alloc] initWithString:kServiceURLString];
}

@end

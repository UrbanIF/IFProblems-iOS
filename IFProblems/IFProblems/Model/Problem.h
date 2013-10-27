//
//  Problem.h
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Problem : NSObject

@property (nonatomic) NSNumber *problemID;
@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, strong) NSNumber *subcategoryID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photoURLString;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;


@end

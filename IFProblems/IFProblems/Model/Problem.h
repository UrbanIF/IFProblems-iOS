//
//  Problem.h
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Problem : NSObject

@property (nonatomic, copy) NSString *problemID;
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *subcategoryID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photoURLString;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;


@end

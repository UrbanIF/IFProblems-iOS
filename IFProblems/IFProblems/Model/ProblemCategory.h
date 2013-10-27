//
//  ProblemCategory.h
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemCategory : NSObject

@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, strong) NSArray *subcategories;   // of ProblemSubcategory

@end

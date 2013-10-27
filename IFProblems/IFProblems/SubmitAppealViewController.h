//
//  SubmitAppealViewController.h
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemCategory.h"
#import "ProblemSubcategory.h"

@interface SubmitAppealViewController : UIViewController

@property (nonatomic, strong) ProblemCategory *category;
@property (nonatomic, strong) ProblemSubcategory *subcategory;

@end

//
//  CategoryListViewController.m
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <RestKit.h>
#import "CategoryListViewController.h"
#import "ProblemCategory.h"
#import "ProblemSubcategory.h"
#import "Constants.h"
#import "SubmitAppealViewController.h"

@interface CategoryListViewController ()

@property (nonatomic, strong) NSArray *categoriesArray;

@end

@implementation CategoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCategories];
}

- (void)loadCategories
{
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[ProblemCategory class]];
    [categoryMapping addAttributeMappingsFromDictionary:@{@"id": @"categoryID",
                                                          @"title": @"title",
                                                          @"image": @"imageURLString"}];
    
    
    RKObjectMapping *subcategoryMapping = [RKObjectMapping mappingForClass:[ProblemSubcategory class]];
    [subcategoryMapping addAttributeMappingsFromDictionary:@{@"id": @"subcategoryID",
                                                             @"title": @"title"}];
    
    [categoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"subcategories" toKeyPath:@"subcategories" withMapping:subcategoryMapping]];
    
    RKResponseDescriptor *categoryResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping method:RKRequestMethodGET pathPattern:@"/api/categories" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:kServiceURLString];
    urlComponents.path = @"/api/categories";
    NSURLRequest *request = [NSURLRequest requestWithURL:[urlComponents URL]];
    
    RKObjectRequestOperation *categoryRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[categoryResponseDescriptor]];
    [categoryRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.categoriesArray = mappingResult.array;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to fetch categories" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [categoryRequestOperation start];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubcategorySelectedSegue"]) {
        SubmitAppealViewController *submitAppealViewCotroller = (SubmitAppealViewController *)segue.destinationViewController;
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        submitAppealViewCotroller.category = self.categoriesArray[selectedRowIndexPath.section];
        submitAppealViewCotroller.subcategory = submitAppealViewCotroller.category.subcategories[selectedRowIndexPath.row];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.categoriesArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ProblemCategory *category = self.categoriesArray[section];
    return [category.subcategories count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ProblemCategory *category = self.categoriesArray[section];
    return category.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubcategoryCell" forIndexPath:indexPath];
    ProblemCategory *category = self.categoriesArray[indexPath.section];
    ProblemSubcategory *subcategory = category.subcategories[indexPath.row];
    cell.textLabel.text = subcategory.title;
    return cell;
}


@end

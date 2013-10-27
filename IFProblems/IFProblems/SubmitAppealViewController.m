//
//  SubmitAppealViewController.m
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <RestKit.h>
#import "SubmitAppealViewController.h"
#import "Problem.h"
#import "Constants.h"

NSInteger kSubmitSuccessAlertTag = 1;
NSInteger kSubmitFailureAlertTag = 2;

@interface SubmitAppealViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) UIActionSheet *selectImageSourceActionSheet;

@property (strong, nonatomic) UIImage *photo;

@end

@implementation SubmitAppealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *imageSelectTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto:)];
    [self.photoImageView addGestureRecognizer:imageSelectTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIActionSheet *)selectImageSourceActionSheet
{
    if (!_selectImageSourceActionSheet) {
            _selectImageSourceActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Select from library", @"Remove photo", nil];
    }
    return _selectImageSourceActionSheet;
}

- (void)dismissKeyboard
{
    if ([self.addressTextField isFirstResponder]) {
        [self.addressTextField resignFirstResponder];
    }
    else if ([self.commentTextView isFirstResponder]) {
        [self.commentTextView resignFirstResponder];
    }
}

- (IBAction)addPhoto:(id)sender
{
    [self.selectImageSourceActionSheet showInView:self.view];
}

- (void)takePhotoFromCamera
{
    [self presentImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)presentImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)takePhotoFromLibrary
{
    [self presentImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)removePhoto
{
    self.photo = nil;
    self.photoImageView.image = nil;
    self.photoImageView.hidden = YES;
    self.addPhotoButton.hidden = NO;
}

- (IBAction)submitProblem:(UIBarButtonItem *)sender
{
    RKObjectMapping *problemSubmitRequestMapping = [RKObjectMapping requestMapping];
    NSDictionary *requestAttributeMappingsDictionary = @{@"title": @"title",
                                                         @"categoryID": @"category_id",
                                                         @"subcategoryID": @"subcategory_id",
                                                         @"address": @"address",
                                                         @"problemID": @"id",
                                                         @"status": @"status"};
    [problemSubmitRequestMapping addAttributeMappingsFromDictionary:requestAttributeMappingsDictionary];
    
    RKRequestDescriptor *problemSubmitRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:problemSubmitRequestMapping objectClass:[Problem class] rootKeyPath:nil method:RKRequestMethodPOST];
    

    Problem *problem = [[Problem alloc] init];
    problem.categoryID = self.category.categoryID;
    problem.subcategoryID = self.subcategory.subcategoryID;
    problem.title = self.commentTextView.text;
    problem.address = self.addressTextField.text;
    
    RKObjectMapping *problemSubmitResponseMapping = [RKObjectMapping mappingForClass:[Problem class]];
    NSMutableDictionary *responseAttributeMappingsDictionary = [NSMutableDictionary dictionaryWithObjects:[requestAttributeMappingsDictionary allKeys] forKeys:[requestAttributeMappingsDictionary allValues]];
    
    [problemSubmitResponseMapping addAttributeMappingsFromDictionary:responseAttributeMappingsDictionary];
    RKResponseDescriptor *problemSubmitResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:problemSubmitResponseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kServiceURLString]];
    [manager addRequestDescriptor:problemSubmitRequestDescriptor];
    [manager addResponseDescriptor:problemSubmitResponseDescriptor];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"/api/categories/%@/subcategories/%@/problems", problem.categoryID, problem.subcategoryID];
    [manager postObject:problem path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Your appeal has been submitted" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = kSubmitSuccessAlertTag;
        [alertView show];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error while submitting appeal" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = kSubmitFailureAlertTag;
        [alertView show];
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self takePhotoFromCamera];
    }
    else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        [self takePhotoFromLibrary];
    }
    else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
        [self removePhoto];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.photo = info[UIImagePickerControllerOriginalImage];
    self.photoImageView.image = self.photo;
    self.photoImageView.hidden = NO;
    self.addPhotoButton.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kSubmitSuccessAlertTag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

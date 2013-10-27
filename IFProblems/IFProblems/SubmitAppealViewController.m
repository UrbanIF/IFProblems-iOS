//
//  SubmitAppealViewController.m
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import <RestKit.h>
#import "SubmitAppealViewController.h"

@interface SubmitAppealViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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

@end

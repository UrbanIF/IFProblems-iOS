//
//  LogInViewController.m
//  IFProblems
//
//  Created by Yuriy Pavlyshak on 26.10.13.
//  Copyright (c) 2013 UrbanIF. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"LogInSegue"]) {
        NSString *userName = self.loginTextField.text;
        NSString *password = self.passwordTextField.text;
        return [self logInWithUserName:userName password:password];
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (BOOL)logInWithUserName:(NSString *)userName password:(NSString *)password
{
    return YES;
}

@end





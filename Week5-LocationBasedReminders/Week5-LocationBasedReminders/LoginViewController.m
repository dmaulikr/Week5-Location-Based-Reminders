//
//  LoginViewController.m
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 9/3/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface LoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  }

- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
  
  if (![PFUser currentUser]) {
    PFLogInViewController *login = [[PFLogInViewController alloc] init];
    login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton;
   // PFSignUpViewController *signUp = [[PFSignUpViewController alloc] init];
    login.delegate = self;
    login.signUpController.delegate = self;
    [self presentViewController:login animated:YES completion:nil];
  } else {
    [self performSegueWithIdentifier:@"PresentMap" sender:self];
  }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user {
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController * __nonnull)logInController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController * __nonnull)signUpController didSignUpUser:(PFUser * __nonnull)user {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController * __nonnull)signUpController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end

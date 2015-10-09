//
//  PLLoginViewController.m
//  thePlug
//
//  Created by Chappy Asel on 10/8/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import "PLLoginViewController.h"

@interface PLLoginViewController ()

@property bool isLoggingIn;
@property bool isCreatingAccount;

@property AWSLambdaInvoker *lambdaInvoker;

@end

@implementation PLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    _view2.alpha = 0.0;
    _view2.userInteractionEnabled = NO;
    _backButton.alpha = 0.0;
    self.isLoggingIn = NO;
    self.isCreatingAccount = NO;
    self.textField3.secureTextEntry = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    if (self.isLoggingIn) {
        self.loginButton.userInteractionEnabled = NO;
        self.backButton.userInteractionEnabled = NO;
        if ([self.textField2.text isEqualToString:@""] || [self.textField3.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                       message:@"Please enter a valid username and password."
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil] show];
            self.textField3.text = @"";
            [self.textField3 becomeFirstResponder];
        }
        else {
            [[self.lambdaInvoker invokeFunction:@"LambdAuthLogin"
                                JSONObject:@{@"email" : self.textField2.text,
                                             @"password" : self.textField3.text,
                                             @"isError" : @NO}] continueWithBlock:^id(AWSTask *task) {
                if (task.result) {
                    NSLog(@"Result: %@", task.result);
                    NSDictionary *JSONObject = task.result;
                    BOOL userLoggedIn = [JSONObject[@"login"] boolValue];
                    if (userLoggedIn) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"Logged in");
                            [self.textField3 resignFirstResponder];
                            [self dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Username or password is incorrect. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] show];
                            self.textField3.text = @"";
                            [self.textField3 becomeFirstResponder];
                        });
                    }
                }
                return nil;
            }];
        }
        self.loginButton.userInteractionEnabled = YES;
        self.backButton.userInteractionEnabled = YES;
    }
    else {
        [self.textField2 setKeyboardType:UIKeyboardTypeEmailAddress];
        self.textField2.secureTextEntry = NO;
        self.textField2.placeholder = @"Email";
        self.textField3.placeholder = @"Password";
        self.textField1.alpha = 0.0;
        self.textField1.userInteractionEnabled = NO;
        self.loginButton.userInteractionEnabled = NO;
        self.createAccountButton.userInteractionEnabled = NO;
        self.backButton.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.view2.alpha = 1.0;
            self.backButton.alpha = 1.0;
            self.createAccountButton.alpha = 0.0;
            self.loginButton.center = CGPointMake(140,20);
        } completion:^(BOOL finished) {
            self.loginButton.userInteractionEnabled = YES;
            self.backButton.userInteractionEnabled = YES;
            self.isLoggingIn = YES;
            _view2.userInteractionEnabled = YES;
            [self.textField2 becomeFirstResponder];
        }];
    }
}

- (IBAction)createAccountButtonPressed:(UIButton *)sender {
    if (self.isCreatingAccount) {
        self.createAccountButton.userInteractionEnabled = NO;
        self.backButton.userInteractionEnabled = NO;
        if ([self.textField1.text isEqualToString:@""] || [self.textField2.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Please enter a valid username and password."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            [self.textField2 becomeFirstResponder];
            return;
        }
        else if (![self.textField2.text isEqualToString:self.textField3.text]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Passwords do not match. Please try again."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            self.textField2.text = @"";
            self.textField3.text = @"";
            [self.textField2 becomeFirstResponder];
        }
        else {
            
        }
        self.createAccountButton.userInteractionEnabled = YES;
        self.backButton.userInteractionEnabled = YES;
    }
    else {
        [self.textField2 setKeyboardType:UIKeyboardTypeDefault];
        self.textField2.secureTextEntry = YES;
        self.textField1.placeholder = @"Email";
        self.textField2.placeholder = @"Password";
        self.textField3.placeholder = @"Re-enter Password";
        self.loginButton.userInteractionEnabled = NO;
        self.createAccountButton.userInteractionEnabled = NO;
        self.backButton.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.view2.alpha = 1.0;
            self.backButton.alpha = 1.0;
            self.loginButton.alpha = 0.0;
            self.createAccountButton.center = CGPointMake(140,20);
        } completion:^(BOOL finished) {
            self.createAccountButton.userInteractionEnabled = YES;
            self.backButton.userInteractionEnabled = YES;
            self.isCreatingAccount = YES;
            _view2.userInteractionEnabled = YES;
            [self.textField1 becomeFirstResponder];
        }];
    }
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    self.isCreatingAccount = NO;
    self.isLoggingIn = NO;
    self.loginButton.userInteractionEnabled = NO;
    self.createAccountButton.userInteractionEnabled = NO;
    self.backButton.userInteractionEnabled = NO;
    _view2.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.6 animations:^{
        self.view2.alpha = 0.0;
        self.backButton.alpha = 0.0;
        self.loginButton.alpha = 1.0;
        self.createAccountButton.alpha = 1.0;
        self.loginButton.center = CGPointMake(140,55);
        self.createAccountButton.center = CGPointMake(140,95);
    } completion:^(BOOL finished) {
        self.textField1.userInteractionEnabled = YES;
        self.textField1.alpha = 1.0;
        self.loginButton.userInteractionEnabled = YES;
        self.createAccountButton.userInteractionEnabled = YES;
    }];
}

-(void)keyboardWillShow: (NSNotification *)notification {
    NSDictionary *info  = notification.userInfo;
    CGRect rawFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    [self.scrollView setContentOffset:CGPointMake(0, keyboardFrame.size.height-120) animated:YES];
}

-(void)keyboardWillHide: (NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

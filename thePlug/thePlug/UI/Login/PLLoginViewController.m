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
    self.textField4.secureTextEntry = YES;
    _activityIndicator.alpha = 0.0;
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
    //prep for beginning animation
    _label1.alpha = 0.0;
    _label2.alpha = 0.0;
    _view3.alpha = 0.0;
    _leftPlug.alpha = 0.0;
    _rightPlug.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    _leftPlug.center = CGPointMake(_leftPlug.center.x-200, _leftPlug.center.y);
    _rightPlug.center = CGPointMake(_rightPlug.center.x+200, _rightPlug.center.y);
    _label2.center = CGPointMake(_label2.center.x, _label2.center.y+30);
    
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.0
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
        _leftPlug.alpha = 1.0;
        _rightPlug.alpha = 1.0;
        _leftPlug.center = CGPointMake(_leftPlug.center.x+200, _leftPlug.center.y);
        _rightPlug.center = CGPointMake(_rightPlug.center.x-200, _rightPlug.center.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            _label1.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5
                                  delay:0.5
                                options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                 _label2.alpha = 1.0;
                _label2.center = CGPointMake(_label2.center.x, _label2.center.y-30);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5
                                      delay:0.8
                                    options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    _view3.alpha = 1.0;
                } completion:^(BOOL finished) {
                    _view3.userInteractionEnabled = YES;
                }];
            }];
        }];
    }];
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
        if ([self.textField3.text isEqualToString:@""] || [self.textField4.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                       message:@"Please enter a valid username and password."
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil] show];
            self.textField4.text = @"";
            [self.textField4 becomeFirstResponder];
            self.loginButton.userInteractionEnabled = YES;
            self.backButton.userInteractionEnabled = YES;
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _activityIndicator.alpha = 1.0;
                [_activityIndicator startAnimating];
            });
            [[self.lambdaInvoker invokeFunction:@"LambdAuthLogin"
                                JSONObject:@{@"email" : self.textField3.text,
                                             @"password" : self.textField4.text,
                                             @"isError" : @NO}] continueWithBlock:^id(AWSTask *task) {
                if (task.result) {
                    //NSLog(@"Result: %@", task.result);
                    NSDictionary *JSONObject = task.result;
                    BOOL userLoggedIn = [JSONObject[@"login"] boolValue];
                    BOOL userVerified = [JSONObject[@"verified"] boolValue];
                    if (userLoggedIn) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"Logged in");
                            [self.textField4 resignFirstResponder];
                            [UIView animateWithDuration:0.7
                                                  delay:0.0
                                                options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
                                _leftPlug.center = CGPointMake(_leftPlug.center.x+10, _leftPlug.center.y);
                                _rightPlug.center = CGPointMake(_rightPlug.center.x-10, _rightPlug.center.y);
                            } completion:^(BOOL finished) {
                                [self.delegate userLoggedInWithUsername:JSONObject[@"username"]
                                                             IdentityID:JSONObject[@"identityId"]
                                                                  Token:JSONObject[@"token"]];
                                [self dismissViewControllerAnimated:YES completion:^{
                                    
                                }];
                            }];
                        });
                    }
                    else if (userLoggedIn && !userVerified) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You have not verified your account yet. Please check your email."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] show];
                            [self.textField4 resignFirstResponder];
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Username or password is incorrect. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] show];
                            self.textField4.text = @"";
                            [self.textField4 becomeFirstResponder];
                        });
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    _activityIndicator.alpha = 0.0;
                    [_activityIndicator stopAnimating];
                    self.loginButton.userInteractionEnabled = YES;
                    self.backButton.userInteractionEnabled = YES;
                });
                return nil;
            }];
        }
    }
    else {
        [self.textField3 setKeyboardType:UIKeyboardTypeEmailAddress];
        self.textField3.secureTextEntry = NO;
        self.textField3.placeholder = @"Email";
        self.textField4.placeholder = @"Password";
        self.textField1.alpha = 0.0;
        self.textField2.alpha = 0.0;
        self.textField1.userInteractionEnabled = NO;
        self.textField2.userInteractionEnabled = NO;
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
            [self.textField3 becomeFirstResponder];
        }];
    }
}

- (IBAction)createAccountButtonPressed:(UIButton *)sender {
    if (self.isCreatingAccount) {
        self.createAccountButton.userInteractionEnabled = NO;
        self.backButton.userInteractionEnabled = NO;
        if ([self.textField1.text isEqualToString:@""] ||
            [self.textField2.text isEqualToString:@""] ||
            [self.textField3.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Please enter a valid email, username and password."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            [self.textField2 becomeFirstResponder];
            self.createAccountButton.userInteractionEnabled = YES;
            self.backButton.userInteractionEnabled = YES;
        }
        else if (![self.textField3.text isEqualToString:self.textField4.text]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Passwords do not match. Please try again."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            self.textField3.text = @"";
            self.textField4.text = @"";
            [self.textField3 becomeFirstResponder];
            self.createAccountButton.userInteractionEnabled = YES;
            self.backButton.userInteractionEnabled = YES;
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _activityIndicator.alpha = 1.0;
                [_activityIndicator startAnimating];
            });
            [[self.lambdaInvoker invokeFunction:@"LambdAuthCreateUser"
                                     JSONObject:@{@"email": self.textField2.text,
                                                  @"password": self.textField4.text,
                                                  @"username": self.textField1.text,
                                                  @"isError": @NO}] continueWithBlock:^id(AWSTask *task) {
                if (task.result) {
                    //NSLog(@"Result: %@", task.result);
                    NSDictionary *JSONObject = task.result;
                    BOOL userCreated = [JSONObject[@"created"] boolValue];
                    if (userCreated) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"User created");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"Logged in");
                                [self.textField4 resignFirstResponder];
                                [UIView animateWithDuration:0.7
                                                      delay:0.0
                                                    options:UIViewAnimationOptionCurveEaseIn
                                                 animations:^{
                                                     _leftPlug.center = CGPointMake(_leftPlug.center.x+10, _leftPlug.center.y);
                                                     _rightPlug.center = CGPointMake(_rightPlug.center.x-10, _rightPlug.center.y);
                                                 } completion:^(BOOL finished) {
                                                     [self.delegate userLoggedInWithUsername:JSONObject[@"username"]
                                                                                  IdentityID:JSONObject[@"identityId"]
                                                                                       Token:JSONObject[@"token"]];
                                                     [self dismissViewControllerAnimated:YES completion:^{
                                                         
                                                     }];
                                                 }];
                            });
                            /*
                            [self.textField4 resignFirstResponder];
                            [self backButtonPressed:nil];
                            [[[UIAlertView alloc] initWithTitle:@"Important"
                                                        message:@"You must verify your email in order to log in. Once you have verified via email, you can log in."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] show];
                             */
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"User could not be created at this time. Please try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] show];
                            [self.textField4 resignFirstResponder];
                            [self backButtonPressed:nil];
                        });
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"There was an error proccessing your request. Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil] show];
                        [self.textField4 resignFirstResponder];
                        [self backButtonPressed:nil];
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    _activityIndicator.alpha = 0.0;
                    [_activityIndicator stopAnimating];
                    self.createAccountButton.userInteractionEnabled = YES;
                    self.backButton.userInteractionEnabled = YES;
                });
                return nil;
            }];
        }
    }
    else {
        self.textField1.alpha = 1.0;
        self.textField2.alpha = 1.0;
        [self.textField3 setKeyboardType:UIKeyboardTypeDefault];
        self.textField3.secureTextEntry = YES;
        self.textField3.placeholder = @"Password";
        self.textField4.placeholder = @"Re-enter Password";
        self.loginButton.userInteractionEnabled = NO;
        self.createAccountButton.userInteractionEnabled = NO;
        self.backButton.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.view2.alpha = 1.0;
            self.backButton.alpha = 1.0;
            self.loginButton.alpha = 0.0;
            self.label2.alpha = 0.0; //TEMPORARY
            self.createAccountButton.center = CGPointMake(140,20);
        } completion:^(BOOL finished) {
            self.textField1.userInteractionEnabled = YES;
            self.textField2.userInteractionEnabled = YES;
            self.createAccountButton.userInteractionEnabled = YES;
            self.backButton.userInteractionEnabled = YES;
            self.isCreatingAccount = YES;
            _view2.userInteractionEnabled = YES;
            [self.textField1 becomeFirstResponder];
        }];
    }
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    self.textField1.text = @"";
    self.textField2.text = @"";
    self.textField3.text = @"";
    self.textField4.text = @"";
    self.isCreatingAccount = NO;
    self.isLoggingIn = NO;
    self.loginButton.userInteractionEnabled = NO;
    self.createAccountButton.userInteractionEnabled = NO;
    self.backButton.userInteractionEnabled = NO;
    _view2.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.label2.alpha = 1.0; //TEMPORARY
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

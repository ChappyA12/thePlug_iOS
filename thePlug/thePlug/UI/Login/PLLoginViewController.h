//
//  PLLoginViewController.h
//  thePlug
//
//  Created by Chappy Asel on 10/8/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLLoginViewControllerDelegate <NSObject>
-(void) userLoggedInWithUsername: (NSString *) username IdentityID: (NSString *) IndentityId Token: (NSString *) token;
@end

@interface PLLoginViewController : UIViewController

@property id <PLLoginViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *leftPlug;
@property (weak, nonatomic) IBOutlet UIImageView *rightPlug;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

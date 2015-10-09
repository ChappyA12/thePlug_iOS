//
//  FirstViewController.m
//  thePlug
//
//  Created by Chappy Asel on 10/1/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import "FirstViewController.h"
#import "PLUserID.h"
#import "PLLoginViewController.h"

@interface FirstViewController ()

@property bool userLoggedIn;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userLoggedIn = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.userLoggedIn) {
        PLLoginViewController *vc = [[PLLoginViewController alloc] initWithNibName:@"PLLoginViewController" bundle:nil];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
    //AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userLoggedInWithUsername:(NSString *)username IdentityID:(NSString *)IndentityId Token:(NSString *)token {
    self.userLoggedIn = YES;
    NSLog(@"Logged in: %@",username);
    _textView.text = [NSString stringWithFormat:@"Welcome, %@",username];
}

@end

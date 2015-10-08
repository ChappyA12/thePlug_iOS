//
//  PLLoginViewController.m
//  thePlug
//
//  Created by Chappy Asel on 10/8/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import "PLLoginViewController.h"

@interface PLLoginViewController ()

@end

@implementation PLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)func {
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    [[lambdaInvoker invokeFunction:@"myFunction"
                        JSONObject:@{@"key1" : @"value1",
                                     @"key2" : @2,
                                     @"key3" : [NSNull null],
                                     @"key4" : @[@1, @"2"],
                                     @"isError" : @NO}] continueWithBlock:^id(AWSTask *task) {
        // Handle response
        return nil;
    }];
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

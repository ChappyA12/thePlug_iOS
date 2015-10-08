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

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (true) {
        PLLoginViewController *vc = [[PLLoginViewController alloc] initWithNibName:@"PLLoginViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

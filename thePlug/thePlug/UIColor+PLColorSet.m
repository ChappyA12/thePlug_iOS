//
//  UIColor+PLColorSet.m
//  thePlug
//
//  Created by Chappy Asel on 10/8/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import "UIColor+PLColorSet.h"

@implementation UIColor (PLColorSet)

+ (UIColor *)PLPrimaryColor {
    static UIColor *PLPrimaryColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PLPrimaryColor = [UIColor colorWithRed:118.0 / 255.0
                                         green:255.0 / 255.0
                                          blue:003.0 / 255.0
                                         alpha:1.0];
    });
    return PLPrimaryColor;
}

+ (UIColor *)PLSecondaryColor {
    static UIColor *PLSecondaryColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PLSecondaryColor = [UIColor colorWithRed:100.0 / 255.0
                                           green:221.0 / 255.0
                                            blue:023.0 / 255.0
                                           alpha:1.0];
    });
    return PLSecondaryColor;
}

@end

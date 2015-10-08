//
//  PLUserID.m
//  thePlug
//
//  Created by Chappy Asel on 10/1/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import "PLUserID.h"

@implementation PLUserID

+ (NSString *)dynamoDBTableName {
    return @"ThePlug_Users";
}

+ (NSString *)hashKeyAttribute {
    return @"userID";
}

@end

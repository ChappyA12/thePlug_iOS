//
//  PLUserID.h
//  thePlug
//
//  Created by Chappy Asel on 10/1/15.
//  Copyright © 2015 CD. All rights reserved.
//

#import "AWSDynamoDBObjectMapper.h"

@interface PLUserID : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;

@end

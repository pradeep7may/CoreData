//
//  Employee.h
//  CoreDataHelper
//
//  Created by Pradeep Yadav on 15/06/15.
//  Copyright (c) 2015 iOSBucket.blogspot.in. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bank;

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSNumber * bankdetail;
@property (nonatomic, retain) NSNumber * empid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Bank *bankrelation;

@end

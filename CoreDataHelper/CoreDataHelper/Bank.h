//
//  Bank.h
//  CoreDataHelper
//
//  Created by Pradeep Yadav on 15/06/15.
//  Copyright (c) 2015 iOSBucket.blogspot.in. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employee;

@interface Bank : NSManagedObject

@property (nonatomic, retain) NSNumber * bankid;
@property (nonatomic, retain) NSString * bankname;
@property (nonatomic, retain) Employee *employeerelation;

@end

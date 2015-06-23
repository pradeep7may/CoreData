//
//  ViewController.m
//  CoreDataHelper
//
//  Created by Pradeep Yadav on 15/06/15.
//  Copyright (c) 2015 iOSBucket.blogspot.in. All rights reserved.
//

#import "ViewController.h"
#import "Bank.h"
#import "Employee.h"
#import "CoreDataHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self saveEmployeeDetail];
    [self getEmployeeDetail];
    [self deleteEmployee];
    [self getEmployeeDetail];
}

- (void)saveEmployeeDetail
{
    //USING HELPER CLASS
    Employee *empObj = (Employee*)[[CoreDataHelper sharedManager]createEntityWithName:@"Employee"];
    empObj.empid = [NSNumber numberWithInt:12];
    empObj.name = @"ABX14";
    
    Bank *bankObj = (Bank*)[[CoreDataHelper sharedManager]createEntityWithName:@"Bank"];
    bankObj.bankid = [NSNumber numberWithInt:18];
    bankObj.bankname = @"AXI24";
    empObj.bankrelation = bankObj;
    bankObj.employeerelation = empObj;
    
    [[CoreDataHelper sharedManager]saveContext];
    
    //USING NATIVE METHOD

    
    //get the managed object context. By default It will be created on shared app delegate but in our demo we have created it on our helper class.
/*    NSManagedObjectContext *managedObjectContext = [[CoreDataHelper sharedManager]managedObjectContext];
    
    //It will create a new entity object in current managed context.
    Employee *empObj = (Employee*)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:managedObjectContext];
    
    //Set the values
    empObj.empid = [NSNumber numberWithInt:1];
    empObj.name = @"ABX1";
    
    //Create the bank object and set all the values.
    Bank *bankObj = (Bank*)[NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:managedObjectContext];
    bankObj.bankid = [NSNumber numberWithInt:11];
    bankObj.bankname = @"AXI1";
    
    //Set the relationship objects
    empObj.bankrelation = bankObj;
    bankObj.employeerelation = empObj;
    
    //save function will save all the values in the database
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
 */
    
}

- (void)getEmployeeDetail
{
    //USING HELPER CLASS

    NSArray *arrayRecords =[[CoreDataHelper sharedManager]getListOfEntityWithName:@"Employee" predicate:nil sortKey:nil];
    NSLog(@"EmployeeDetails = %@",arrayRecords);
    for (Employee *emp in arrayRecords)
    {
        NSLog(@"Name: %@",emp.name);
        Bank *bank = emp.bankrelation;
        NSLog(@"Bank name: %@",bank.bankname);
    }
    
    //USING NATIVE METHOD

    
 /*   NSManagedObjectContext *managedObjectContext = [[CoreDataHelper sharedManager]managedObjectContext];
    
    //Create a NSFetchRequest object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get the specified entity
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employee" inManagedObjectContext:managedObjectContext];
    NSError *error =nil;
    //Set the entity inthe fetch request
    [fetchRequest setEntity:entity];
    
    //Execute the fetch request which will give the array of stored data
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Employee *emp in fetchedObjects)
    {
        NSLog(@"Name: %@",emp.name);
        Bank *bank = emp.bankrelation;
        NSLog(@"Bank name: %@",bank.bankname);
    }
    */
}

- (void)deleteEmployee
{
    //USING HELPER CLASS

    NSArray *arrayRecords =[[CoreDataHelper sharedManager]getListOfEntityWithName:@"Employee" predicate:nil sortKey:nil];
    [[CoreDataHelper sharedManager]deleteEntity:[arrayRecords objectAtIndex:0]];
    
    //USING NATIVE METHOD

    
  /*  NSManagedObjectContext *managedObjectContext = [[CoreDataHelper sharedManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employee" inManagedObjectContext:managedObjectContext];
    NSError *error =nil;
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Pass the entity in the delete object that was previously fetched.
    [managedObjectContext deleteObject:[fetchedObjects objectAtIndex:0]];
    
    //Save the context so that changes gets saved on the database
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
   */
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

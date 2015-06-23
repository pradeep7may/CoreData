//
//  CoreDataHelper.m
//  LottBot
//
//  Created by Sunidhi Gupta on 09/06/15.
//  Copyright (c) 2015 Techahead. All rights reserved.
//

#import "CoreDataHelper.h"

static CoreDataHelper *sharedInstance;

@implementation CoreDataHelper

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "com.TA.LottBot.CoreData" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataHelper" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataHelper.sqlite"];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Public Methods

+ (CoreDataHelper *)sharedManager
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[CoreDataHelper alloc] init];
  });
  return sharedInstance;
}

- (NSManagedObject *)createEntityWithName:(NSString *)entityName
{
  NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:self.managedObjectContext];
  return entity;
}

- (NSManagedObject *)getStoredEntityWithName:(NSString *)entityName
                                  predicate:(NSPredicate *)predicate
                                    sortKey:(NSString *)sortKey
{
  NSManagedObject *entity = nil;
		
  NSFetchRequest *request = [self getBasicRequestForEntityName:entityName];
  if (predicate)
  {
    [request setPredicate:predicate];
  }
  
  if (sortKey)
  {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
      NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
      [request setSortDescriptors:sortDescriptors];
  }
		
  NSError* error = nil;
  NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
		
  if (error)
  {
    NSLog(@"Fetch request error on %@: %@",entityName, [error localizedDescription]);
  }
  else
  {
    entity = [results firstObject];
  }
  return entity;
}

- (NSArray *)getListOfEntityWithName:(NSString *)entityName
                          predicate:(NSPredicate *)predicate
                            sortKey:(NSString *)sortKey
{
  NSArray* entities = nil;
  
  NSFetchRequest *request = [self getBasicRequestForEntityName:entityName];
  if (predicate)
  {
    [request setPredicate:predicate];
  }
  
  if (sortKey)
  {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
  }
  
  NSError* error = nil;
  NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
  
  if (error)
  {
    NSLog(@"Fetch request error on %@: %@",entityName, [error localizedDescription]);
  }
  else
  {
    entities = [NSArray arrayWithArray:results];
  }
  return entities;
}

- (NSInteger)totalObjectsCountFromEntity:(NSString *)entityName
                           withPredicate:(NSPredicate *)predicate
{
  NSFetchRequest *request = [self getBasicRequestForEntityName:entityName];
  
  if (predicate != nil)
  {
    [request setPredicate: predicate];
  }
  
  [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
  
  NSError *error = nil;
  NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
  
  if (count == NSNotFound)
  {
    return 0;
  }
  else
  {
    return count;
  }
}

- (void)deleteEntity:(NSManagedObject *)entity
{
  if (!entity)
  {
    return;
  }
  
  [self.managedObjectContext deleteObject:entity];
  
  NSError *error = nil;
  if (![self.managedObjectContext save:&error])
  {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
  }
}

- (void)deleteAllEntity:(NSString *)entityName
{
  NSArray *arrayOfList = [self getListOfEntityWithName:entityName predicate:nil sortKey:nil];
  
  if ([arrayOfList count] > 0)
  {
    for (NSManagedObject *object in arrayOfList)
    {
      [self deleteEntity:object];
    }
    [self saveContext];
  }
}

- (void)saveContext
{
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

#pragma mark - Private Methods

/**
 *  Get request for the entity 
 *
 *  @param entityName Name of the Entity to be deleted
 *
 *  @return NSFetchRequest object
 */
- (NSFetchRequest *)getBasicRequestForEntityName:(NSString *)entityName
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:self.managedObjectContext];
  [request setEntity:entity];
  
  return request;
}

@end

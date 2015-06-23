//
//  CoreDataHelper.h
//  LottBot
//
//  Created by Sunidhi Gupta on 09/06/15.
//  Copyright (c) 2015 Techahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject
{
  
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  This function is used to get singelton object of this class.
 *
 *  @return shared instance of the class
 */
+ (CoreDataHelper *)sharedManager;

/**
 *	Create new entity by name in managed object context.
 *
 *	@param entityName Name of the entity
 *
 *	@return NSManagedObject object.
 */
- (NSManagedObject *)createEntityWithName:(NSString *)entityName;

/**
 *	Fetch the Stored Entity from coredate given name and predicate. Sort the result on given |sortKey|
 *
 *	@param entityName Name of the Entity to be fetched.
 *	@param predicate to be set on Fetch request.
 *	@param sortKey Sort the result on sortKey.
 *
 *	@return NSManagedObject object.
 */
- (NSManagedObject *)getStoredEntityWithName:(NSString *)entityName
                                  predicate:(NSPredicate *)predicate
                                    sortKey:(NSString *)sortKey;

/**
 *	Fetch all the Stored Entities from coredate given name and predicate. Sort the result on given |sortKey|
 *
 *	@param entityName Name of the Entity to be fetched.
 *	@param predicate to be set on Fetch request.
 *	@param sortKey Sort the result on sortKey.
 *
 *	@return NSArray object.
 */
- (NSArray *)getListOfEntityWithName:(NSString *)entityName
                          predicate:(NSPredicate *)predicate
                            sortKey:(NSString *)sortKey;

/**
 *  Fetch the total number of Stored Entity from coredate given name and predicate.
 *
 *  @param entityName Name of the Entity to be fetched
 *  @param predicate  to be set on Fetch request.
 *
 *  @return total number of count
 */
- (NSInteger)totalObjectsCountFromEntity:(NSString *)entityName
                           withPredicate:(NSPredicate *)predicate;

/**
 * Delete NSManagedObject from NSManagedObjectContext and save the context.
 *
 * @param entity NSManagedObject to delete.
 **/
- (void)deleteEntity:(NSManagedObject *)entity;

/**
 * Delete NSManagedObject from NSManagedObjectContext and save the context.
 *
 * @param entityName Name of the Entity to be deleted.
 **/
- (void)deleteAllEntity:(NSString *)entityName;

/**
 * @details Save the context in coredata.
 **/
- (void)saveContext;

@end

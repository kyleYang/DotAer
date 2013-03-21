//
//  DSBaseModel.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DSBaseModel : NSManagedObject

/* insert to database with dictionary */
+ (id)insertWithManagedObjectContext:(NSManagedObjectContext *)context value:(NSDictionary *)dictionary;

/* fetch a list of data from database with a certain sort, what's more, put all the fetched results into a fetchedResultsController */
+ (NSFetchedResultsController *)fetchedResultsControllerWithManagedObjectContext:(NSManagedObjectContext *)context sortDescriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate;

/* fetch a list of data from database with a certain sort */
+ (NSMutableArray *)fetchedResultsWithManagedObjectContext:(NSManagedObjectContext *)context sortDescriptors:(NSArray *)sortDescriptors;

/* fetch a list of data from database with a certain predicate */
+ (NSMutableArray *)fetchedResultsWithManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

+ (NSMutableArray *)fetchedResultsWithManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

/* fetch with a pair of attributeName and attributeValue , which usually means primary key's name and value */
+ (id)fetchWithManagedObjectContext:(NSManagedObjectContext *)context keyAttributeName:(NSString *)name keyAttributeValue:(id)attribute;

/* fetch with a certain predicate , which can use in different situations */
+ (id)fetchWithManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

/* delete self from database */
- (BOOL)removeObject;


@end

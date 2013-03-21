//
//  Upgrade.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-21.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "Upgrade.h"
#import "Constants.h"

@implementation Upgrade

@dynamic equipSN;
@dynamic upgradSN;

+ (id)insertWithManagedObjectContext:(NSManagedObjectContext *)context value:(NSDictionary *)dictionary
{
    NSNumber *num = [dictionary objectForKey:kUpgradSN];
    if ([num intValue] == 0) {
        return nil;
    }
    Upgrade *upgrade = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    upgrade.equipSN = [dictionary objectForKey:kEquipSN];
    upgrade.upgradSN = [dictionary objectForKey:kUpgradSN];
    NSError *error;
    if (![upgrade.managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // Fail
        return nil;
    }
    return upgrade;
}

@end

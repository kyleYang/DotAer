//
//  Material.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-21.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "Material.h"
#import "Constants.h"


@implementation Material

@dynamic equipSN;
@dynamic materialSN;

+ (id)insertWithManagedObjectContext:(NSManagedObjectContext *)context value:(NSDictionary *)dictionary
{
    NSNumber *num = [dictionary objectForKey:kMaterialSN];
    if ([num intValue] == 0) {
        return nil;
    }

    Material *material = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    material.materialSN = [dictionary objectForKey:kMaterialSN];
    material.equipSN = [dictionary objectForKey:kEquipSN];
    NSError *error;
    if (![material.managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // Fail
        return nil;
    }
    return material;
}

@end

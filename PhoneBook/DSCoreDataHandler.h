//
//  DSCoreDataHandler.h
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSCoreDataHandler : NSObject



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(instancetype)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(id)prepareObjectWithEntityName:(NSString*) entityName;
-(NSArray*) entitiesForEntityName:(NSString*) entityName;
-(void) deleteObject:(id)entity;

@end

//
//  DSCoreDataHandler.m
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import "DSCoreDataHandler.h"
#import "DSContact.h"
#import "DSCategory.h"


@implementation DSCoreDataHandler

NSString * const DSCoreDataEntityContact = @"DSContact";
NSString * const DSCoreDataEntityCategory = @"DSCategory";



+(instancetype)sharedInstance {
    DSCoreDataHandler static *cdHandler;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cdHandler = [[DSCoreDataHandler alloc] init];
        [cdHandler managedObjectContext];
        [cdHandler checkForRootCategory];
    });
    
    return cdHandler;
}


-(void)checkForRootCategory{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"aTitle like 'Root category'"];
    NSArray* result = [self entitiesForEntityName:DSCoreDataEntityCategory withBachSize:0 usingSortDescriptors:nil andPredicate:predicate];
    if([result count] == 0){
        DSCategory* category = [self prepareObjectWithEntityName:DSCoreDataEntityCategory];
        category.aTitle = @"Root category";
        [category.managedObjectContext save:nil];
    }
}


-(id)prepareObjectWithEntityName:(NSString*) entityName {
    id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
    return entity;
}


-(NSArray*) entitiesForEntityName:(NSString*) entityName withBachSize:(NSInteger) batchSize usingSortDescriptors:(NSArray*) descriptors andPredicate:(NSPredicate*) predicate{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    [request setFetchBatchSize:batchSize];
    [request setSortDescriptors:descriptors];
    [request setPredicate:predicate];
    
    NSError* error;
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(error){
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return result;
}


-(NSArray*) entitiesForEntityName:(NSString*) entityName withBachSize:(NSInteger) batchSize usingSortDescriptors:(NSArray*) descriptors{
    return [self entitiesForEntityName:entityName withBachSize:batchSize usingSortDescriptors:descriptors andPredicate:nil];
}


-(NSArray*) entitiesForEntityName:(NSString*) entityName withBachSize:(NSInteger) batchSize{
    return [self entitiesForEntityName:entityName withBachSize:batchSize usingSortDescriptors:nil];
}

-(NSArray*) entitiesForEntityName:(NSString*) entityName {
    return [self entitiesForEntityName:entityName withBachSize:20];
}


-(void) deleteObject:(id)entity{
    [self.managedObjectContext deleteObject:entity];
    [self.managedObjectContext save:nil];
}


#pragma mark - ==============================
#pragma mark Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "DS.PhoneBook" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PhoneBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PhoneBook.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
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
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

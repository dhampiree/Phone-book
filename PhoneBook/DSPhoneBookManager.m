//
//  DSPhoneBookManager.m
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import "DSPhoneBookManager.h"
#import "DSCoreDataHandler.h"
#import "DSCategory.h"
#import "DSContact.h"

@interface DSPhoneBookManager ()

@property( nonatomic, strong) DSCoreDataHandler* cdHandler;

@end

@implementation DSPhoneBookManager
/*
+(instancetype) defaultManager{
    DSPhoneBookManager static *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DSPhoneBookManager alloc] init];
        manager.cdHandler = [DSCoreDataHandler sharedInstance];
    });
    return manager;
}*/


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cdHandler = [DSCoreDataHandler sharedInstance];
    }
    return self;
}


-(DSCategory*) rootCategory {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"aTitle like 'Root category'"];
    NSArray* result = [self.cdHandler entitiesForEntityName:DSCoreDataEntityCategory withBachSize:0 usingSortDescriptors:nil andPredicate:predicate];
    return [result firstObject];
}


-(NSArray*) subcategoriesInCategory:(DSCategory*) category{
    NSString* entityName = @"DSCategory";
    NSInteger batchSize = 20;
    NSSortDescriptor* sortByName = [NSSortDescriptor sortDescriptorWithKey:@"aTitle" ascending:YES];
    
    
    NSString* predicateString = [NSString stringWithFormat:@"rParentCategory.aTitle like '%@'",category.aTitle];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateString];
    
    return [self.cdHandler entitiesForEntityName:entityName withBachSize:batchSize usingSortDescriptors:@[sortByName] andPredicate:predicate];
}

-(NSArray*) contactsInCategory:(DSCategory*) category{
    
    NSString* entityName = @"DSContact";
    NSInteger batchSize = 20;
    NSSortDescriptor* sortByName = [NSSortDescriptor sortDescriptorWithKey:@"aName" ascending:YES];
    
    
    NSString* predicateString = [NSString stringWithFormat:@"rCategory.aTitle like '%@'",category.aTitle];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateString];
    
    return [self.cdHandler entitiesForEntityName:entityName withBachSize:batchSize usingSortDescriptors:@[sortByName] andPredicate:predicate];
}


-(NSArray*) allContacts{
    NSArray* result = [self.cdHandler entitiesForEntityName:@"DSContact"];
    
    return result;
}


-(void) addCategory:(NSString*)categoryTitle toCategory:(DSCategory*)category{
    NSString* predicateAtring = [NSString stringWithFormat:@"aTitle like '%@'",categoryTitle];
    NSPredicate* predicte = [NSPredicate predicateWithFormat:predicateAtring];
    NSArray* result = [self.cdHandler entitiesForEntityName:DSCoreDataEntityCategory withBachSize:0 usingSortDescriptors:nil andPredicate:predicte];
    
    BOOL categoryExist = [result count] > 0;
    
    NSError* error;
    if(categoryExist) {
        error = [NSError errorWithDomain:@"Core data handler" code:1 userInfo:@{@"Error reason": @"Category already exist"}];
        [self.delegate updateTableView:@"OOPS." error:error];
        return;
    }
    
    DSCategory* categoryNew =  [self.cdHandler prepareObjectWithEntityName:@"DSCategory"];
    categoryNew.aTitle = categoryTitle;
    categoryNew.rParentCategory = category ? category : [self rootCategory];
    
    [categoryNew.managedObjectContext save:&error];
    
    if(error){
        [self.delegate updateTableView:@"OOPS." error:error];
    } else {
        [self.delegate updateTableView:@"Category was successfully created." error:nil];
    }
}


-(void) addContact:(NSString*) contactName withPhoneNumber:(NSString*)phoneNumber toCategory:(DSCategory*)category{
    DSContact* contact = [self.cdHandler prepareObjectWithEntityName:@"DSContact"];
    contact.aName = contactName;
    contact.aPhoneNumber = phoneNumber;
    contact.rCategory = category ? category : [self rootCategory];
    
    
    NSError* error;
    [contact.managedObjectContext save:&error];
    
    if(error){
        [self.delegate updateTableView:@"OOPS." error:error];
    } else {
        [self.delegate updateTableView:@"Contact was successfully created." error:nil];
    }
}


-(void) deleteObject:(id)object{
    [self.cdHandler deleteObject:object];
}


-(void) deleteCategory:(DSCategory*)category{
    NSArray* subcategories = [self subcategoriesInCategory:category];
    
    for(DSCategory* cat in subcategories){
        [self deleteCategory:cat];
    }
    
    NSArray* contatsArray = [self contactsInCategory:category];
    for (DSContact* contact in contatsArray) {
        contact.rCategory = [self rootCategory];
    }
    
    [self deleteObject:category];
}


@end

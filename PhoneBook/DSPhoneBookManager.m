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

+(instancetype) defaultManager{
    DSPhoneBookManager static *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DSPhoneBookManager alloc] init];
        manager.cdHandler = [DSCoreDataHandler sharedInstance];
    });
    return manager;
}


-(NSArray*) objectsInCategory:(NSString*) categoryTitle{
    
    return [NSArray array];
}


-(NSArray*) allContacts{
    NSArray* result = [self.cdHandler entitiesForEntityName:@"DSContact"];
    
    return result;
}


-(void) addCategory:(NSString*)categoryTitle{
    
    DSCategory* category =  [self.cdHandler prepareObjectWithEntityName:@"DSCategory"];
    category.aTitle = categoryTitle;
    [category.managedObjectContext save:nil];
    
}


-(void) addContact:(NSString*) contactName withPhoneNumber:(NSString*)phoneNumber{
    DSContact* contact = [self.cdHandler prepareObjectWithEntityName:@"DSContact"];
    contact.aName = contactName;
    contact.aPhoneNumber = phoneNumber;
    
    NSError* error;
    [contact.managedObjectContext save:&error];
    
    if(error){
        NSLog(@" >>> Error: %@",[error localizedDescription]);
    } else {
        [self.delegate updateTableView:@"Contact was successfully created."];
    }
}


-(void) deleteObject:(id)object{
    [self.cdHandler deleteObject:object];
}


@end

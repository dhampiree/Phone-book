//
//  DSPhoneBookManager.h
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSCategory;


@protocol DSPhoneBookManagerDelegate <NSObject>

@required
-(void)updateTableView:(NSString*) message error:(NSError*) error;

@end

@interface DSPhoneBookManager : NSObject

@property (nonatomic, weak) id <DSPhoneBookManagerDelegate> delegate;

+(instancetype) defaultManager;

-(void) addCategory:(NSString*)categoryTitle toCategory:(DSCategory*)category;
-(void) addContact:(NSString*) contactName withPhoneNumber:(NSString*)phoneNumber toCategory:(DSCategory*)category;

-(DSCategory*) rootCategory;

-(NSArray*) subcategoriesInCategory:(DSCategory*) category;
-(NSArray*) contactsInCategory:(DSCategory*) category;
-(NSArray*) allContacts;


-(void) deleteObject:(id)object;

@end

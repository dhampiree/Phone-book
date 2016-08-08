//
//  DSPhoneBookManager.h
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DSPhoneBookManagerDelegate <NSObject>

@required
-(void)updateTableView:(NSString*) message;

@end

@interface DSPhoneBookManager : NSObject

@property (nonatomic, weak) id <DSPhoneBookManagerDelegate> delegate;

+(instancetype) defaultManager;
-(NSArray*) objectsInCategory:(NSString*) categoryTitle;
-(NSArray*) allContacts;
-(void) addCategory:(NSString*)categoryTitle;
-(void) addContact:(NSString*) contactName withPhoneNumber:(NSString*)phoneNumber;
-(void) deleteObject:(id)object;

@end

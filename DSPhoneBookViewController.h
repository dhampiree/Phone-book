//
//  DSPhoneBookViewController.h
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSPhoneBookManagerDelegate;

@interface DSPhoneBookViewController : UITableViewController <DSPhoneBookManagerDelegate>

- (IBAction)actionAddContact:(id)sender;
- (IBAction)actionEditTable:(UIBarButtonItem *)sender;

@end

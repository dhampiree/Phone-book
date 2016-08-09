//
//  DSCategoriesViewController.h
//  PhoneBook
//
//  Created by Anton on 09.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSCategory;

@protocol DSPhoneBookManagerDelegate;

@interface DSCategoriesViewController : UITableViewController <DSPhoneBookManagerDelegate>

@property (nonatomic, strong) DSCategory* currentCategory;
- (IBAction)actionEdit:(UIBarButtonItem *)sender;

@end

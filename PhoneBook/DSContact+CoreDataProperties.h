//
//  DSContact+CoreDataProperties.h
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DSContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *aName;
@property (nullable, nonatomic, retain) NSString *aPhoneNumber;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *rCategories;

@end

@interface DSContact (CoreDataGeneratedAccessors)

- (void)addRCategoriesObject:(NSManagedObject *)value;
- (void)removeRCategoriesObject:(NSManagedObject *)value;
- (void)addRCategories:(NSSet<NSManagedObject *> *)values;
- (void)removeRCategories:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END

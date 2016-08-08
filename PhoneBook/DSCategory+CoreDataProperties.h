//
//  DSCategory+CoreDataProperties.h
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DSCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *aTitle;
@property (nullable, nonatomic, retain) NSSet<DSContact *> *rContacts;
@property (nullable, nonatomic, retain) NSSet<DSCategory *> *rCategories;

@end

@interface DSCategory (CoreDataGeneratedAccessors)

- (void)addRContactsObject:(DSContact *)value;
- (void)removeRContactsObject:(DSContact *)value;
- (void)addRContacts:(NSSet<DSContact *> *)values;
- (void)removeRContacts:(NSSet<DSContact *> *)values;

- (void)addRCategoriesObject:(DSCategory *)value;
- (void)removeRCategoriesObject:(DSCategory *)value;
- (void)addRCategories:(NSSet<DSCategory *> *)values;
- (void)removeRCategories:(NSSet<DSCategory *> *)values;

@end

NS_ASSUME_NONNULL_END

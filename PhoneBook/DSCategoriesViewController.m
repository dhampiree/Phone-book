//
//  DSCategoriesViewController.m
//  PhoneBook
//
//  Created by Anton on 09.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import "DSCategoriesViewController.h"
#import "DSPhoneBookManager.h"
#import "DSContact.h"
#import "DSCategory.h"


@interface DSCategoriesViewController ()


@property (nonatomic, strong) NSArray* listOfCategories;
@property (nonatomic, strong) NSArray* listOfContacts;
@property (nonatomic, strong) UIAlertController* alertController;
@property (nonatomic, strong) DSPhoneBookManager* phoneBookManager;

@end

@implementation DSCategoriesViewController

NSInteger const DSTableViewSectionContact  = 1;
NSInteger const DSTableViewSectionCategory = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.currentCategory){
        self.phoneBookManager = [[DSPhoneBookManager alloc] init];
        self.phoneBookManager.delegate = self;
        self.currentCategory = [self.phoneBookManager rootCategory];
    }
    self.navigationItem.title = self.currentCategory.aTitle;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setCurrentCategory:(DSCategory *)currentCategory{
    _currentCategory = currentCategory;
    
    self.phoneBookManager = [[DSPhoneBookManager alloc] init];
    self.phoneBookManager.delegate = self;
    
    self.listOfContacts = [self.phoneBookManager contactsInCategory:_currentCategory];
    self.listOfCategories = [self.phoneBookManager subcategoriesInCategory:_currentCategory];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case DSTableViewSectionCategory:{
            return @"Categories";
        }
        case DSTableViewSectionContact: {
            return @"Contacts";
        }
            
        default:
            break;
    }
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DSTableViewSectionCategory:
            return [self.listOfCategories count] +1;
            
        case DSTableViewSectionContact:
            return [self.listOfContacts count] +1;
            
        default:
            break;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString static *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    switch (indexPath.section) {
        case DSTableViewSectionCategory: {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Add category";
                cell.imageView.image = nil;

            } else {
                DSCategory* category = [self.listOfCategories objectAtIndex:indexPath.row-1];
                cell.imageView.image = [UIImage imageNamed:@"group.png"];
                cell.textLabel.text = category.aTitle;
            }
            break;
        }
            
        case DSTableViewSectionContact: {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Add contact";
                cell.imageView.image = nil;

            } else {
                DSContact* contact = [self.listOfContacts objectAtIndex:indexPath.row-1];
                cell.imageView.image = [UIImage imageNamed:@"contact.png"];
                cell.textLabel.text = contact.aName;
            }
            break;
        }
        
        default:
            break;
    }
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(indexPath.row == 0);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        switch (indexPath.section) {
            case DSTableViewSectionCategory: {
                DSCategory* category = [self.listOfCategories objectAtIndex:indexPath.row-1];
                NSMutableArray *temp = [self.listOfCategories mutableCopy];
                [temp removeObjectAtIndex:indexPath.row-1];
                self.listOfCategories = [temp copy];
                [self.phoneBookManager deleteCategory:category];
                break;
            }
                
            case DSTableViewSectionContact: {
                DSContact* contact = [self.listOfContacts objectAtIndex:indexPath.row-1];
                NSMutableArray *temp = [self.listOfContacts mutableCopy];
                [temp removeObjectAtIndex:indexPath.row-1];
                self.listOfContacts = [temp copy];
                [self.phoneBookManager deleteObject:contact];
                break;
            }
                
            default:
                break;
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case DSTableViewSectionCategory:
            if(indexPath.row == 0){
                [self addNewCategory];
            } else {
                DSCategoriesViewController* cvc= [self.storyboard instantiateViewControllerWithIdentifier:@"DSCategoriesViewController"];
                DSCategory* newCategory = [self.listOfCategories objectAtIndex:indexPath.row-1];
                cvc.currentCategory = newCategory;
                [self.navigationController pushViewController:cvc animated:YES];
            }
            break;
            
        case DSTableViewSectionContact:
            if(indexPath.row == 0){
                [self addNewContact];
            }
            break;
            
        default:
            break;
    }
    
}




#pragma mark - ALERTS

-(void) addNewCategory {
    self.alertController = [UIAlertController alertControllerWithTitle:@"New category" message:@"Enter title" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak id weakSelf = self;
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Title"; //NSLocalizedString(@"NamePlaceholder", @"Name");
        [textField addTarget:weakSelf action:@selector(creatingObject:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* title = [[self.alertController textFields] firstObject].text;
        [self.phoneBookManager addCategory:title toCategory:self.currentCategory];
    }];
    
    okBtn.enabled = NO;
    
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.alertController addAction:okBtn];
    [self.alertController addAction:cancelBtn];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
}



-(void) addNewContact {
    self.alertController = [UIAlertController alertControllerWithTitle:@"New contact" message:@"Enter name and phone number" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak id weakSelf = self;
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name"; //NSLocalizedString(@"NamePlaceholder", @"Name");
        [textField addTarget:weakSelf action:@selector(creatingObject:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Phone number"; //NSLocalizedString(@"PhoneNumberPlaceholder", @"Phone number");
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* name = [[self.alertController textFields] firstObject].text;
        NSString* phoneNumber = [[self.alertController textFields] lastObject].text;
        
        [self.phoneBookManager addContact:name withPhoneNumber:phoneNumber toCategory:self.currentCategory];
    }];
    
    okBtn.enabled = NO;
    
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.alertController addAction:okBtn];
    [self.alertController addAction:cancelBtn];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
}


-(void)creatingObject:(UITextField*) sender{
    UIAlertAction* okAction = [self.alertController.actions firstObject];
    NSString* name = sender.text;
    okAction.enabled = name.length > 2;
}


-(void) alertWithError:(NSError*) error{
    NSString* message = [error.userInfo objectForKey:@"Error reason"];
    self.alertController = [UIAlertController alertControllerWithTitle:@"OOPS!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.alertController addAction:okBtn];
    [self presentViewController:self.alertController animated:YES completion:nil];
}


#pragma mark - DSPhoneBookManagerDelegate
-(void)updateTableView:(NSString*) message error:(NSError*) error{
    if(!error){
        self.listOfContacts = [self.phoneBookManager contactsInCategory:_currentCategory];
        self.listOfCategories = [self.phoneBookManager subcategoriesInCategory:_currentCategory];
        [self.tableView reloadData];
    } else {
        [self alertWithError:error];
    }
}


#pragma mark - Actions
- (IBAction)actionEdit:(UIBarButtonItem *)sender {
    BOOL isEditing = ![self.tableView isEditing];
    [self.tableView setEditing:isEditing animated:YES];
    
    if (isEditing) {
        sender.title = @"Done";
    } else {
        sender.title = @"Delete";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateTableView:nil error:nil];
        });
    }
}




@end

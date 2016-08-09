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

@end

@implementation DSCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.currentCategory){
        self.currentCategory = [[DSPhoneBookManager defaultManager] rootCategory];
    }
    [DSPhoneBookManager defaultManager].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setCurrentCategory:(DSCategory *)currentCategory{
    _currentCategory = currentCategory;
    self.listOfContacts = [[DSPhoneBookManager defaultManager] contactsInCategory:_currentCategory];
    self.listOfCategories = [[DSPhoneBookManager defaultManager] subcategoriesInCategory:_currentCategory];
    
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return @"Categories";
        }
        case 1: {
            return @"Contacts";
        }
            
        default:
            break;
    }
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.listOfCategories count] +1;
            
        case 1:
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
        case 0: {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Add category";
            } else {
                DSCategory* category = [self.listOfCategories objectAtIndex:indexPath.row-1];
                cell.imageView.image = [UIImage imageNamed:@"group.png"];
                cell.textLabel.text = category.aTitle;
            }
            break;
        }
            
        case 1: {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Add contact";
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case 0:
            if(indexPath.row == 0){
                [self addNewCategory];
            }
            break;
            
        case 1:
            if(indexPath.row == 0){
                [self addNewContact];
            }
            break;
            
        default:
            break;
    }
    
}


-(void) addNewCategory {
    self.alertController = [UIAlertController alertControllerWithTitle:@"New category" message:@"Enter title" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak id weakSelf = self;
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Title"; //NSLocalizedString(@"NamePlaceholder", @"Name");
        [textField addTarget:weakSelf action:@selector(creatingObject:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* title = [[self.alertController textFields] firstObject].text;
        [[DSPhoneBookManager defaultManager] addCategory:title toCategory:self.currentCategory];
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
        
        [[DSPhoneBookManager defaultManager] addContact:name withPhoneNumber:phoneNumber toCategory:self.currentCategory];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - DSPhoneBookManagerDelegate
-(void)updateTableView:(NSString*) message error:(NSError*) error{
    if(!error){
        self.listOfContacts = [[DSPhoneBookManager defaultManager] contactsInCategory:_currentCategory];
        self.listOfCategories = [[DSPhoneBookManager defaultManager] subcategoriesInCategory:_currentCategory];
        [self.tableView reloadData];
    }
}

@end

//
//  DSPhoneBookViewController.m
//  PhoneBook
//
//  Created by Anton on 08.08.16.
//  Copyright © 2016 DhampireeSoftware. All rights reserved.
//

#import "DSPhoneBookViewController.h"
#import "DSPhoneBookManager.h"
#import "DSCategory.h"
#import "DSContact.h"


@interface DSPhoneBookViewController ()

@property (nonatomic, strong) NSArray* contactsArray;
@property (nonatomic, weak) UIAlertController* alertController;
@property (nonatomic, strong) DSPhoneBookManager* phoneBookManager;

@end

@implementation DSPhoneBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneBookManager = [DSPhoneBookManager defaultManager];
    self.phoneBookManager.delegate = self;
    
    self.contactsArray = [self.phoneBookManager allContacts];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString static *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    DSContact* contact  = [self.contactsArray objectAtIndex:indexPath.row];
    NSLog(@"%@",contact.rCategory.aTitle);
    cell.textLabel.text = contact.aName;
    cell.detailTextLabel.text = contact.aPhoneNumber;
    
  
    return cell;
}




#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        DSContact* contact = [self.contactsArray objectAtIndex:indexPath.row];
        [self.phoneBookManager deleteObject:contact];
        
        NSMutableArray* temp = [self.contactsArray mutableCopy];
        [temp removeObjectAtIndex:indexPath.row];
        self.contactsArray = [temp copy];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ================================
#pragma mark Actions

- (IBAction)actionAddContact:(id)sender {
    self.alertController = [UIAlertController alertControllerWithTitle:@"New contact" message:@"Enter name and phone number" preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name"; //NSLocalizedString(@"NamePlaceholder", @"Name");
        [textField addTarget:self action:@selector(creatingContactName:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Phone number"; //NSLocalizedString(@"PhoneNumberPlaceholder", @"Phone number");
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* name = [[self.alertController textFields] firstObject].text;
        NSString* phoneNumber = [[self.alertController textFields] lastObject].text;
        
        //[[DSPhoneBookManager defaultManager] addContact:name withPhoneNumber:phoneNumber];
    }];
    
    okBtn.enabled = NO;
    
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.alertController addAction:okBtn];
    [self.alertController addAction:cancelBtn];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
}

-(void)creatingContactName:(UITextField*) sender{
    UIAlertAction* okAction = [self.alertController.actions firstObject];
    NSString* name = sender.text;
    okAction.enabled = name.length > 2;
}


- (IBAction)actionEditTable:(UIBarButtonItem *)sender {
    BOOL isEditing = ![self.tableView isEditing];
    [self.tableView setEditing:isEditing animated:YES];
    
    if(isEditing){
        sender.title = @"Done";
    } else {
        sender.title = @"Delete";
    }
    
}


#pragma mark - DSPhoneBookManagerDelegate
-(void)updateTableView:(NSString*) message error:(NSError*) error{
    if(!error) {
        self.contactsArray = [self.phoneBookManager allContacts];
        [self.tableView reloadData];
    } else {
        NSLog(@">>> ERROR: %@",[error localizedDescription]);
    }
}


@end

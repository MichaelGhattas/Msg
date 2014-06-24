//
//  ContactsViewController.m
//  Msg
//
//  Created by Michael Ghattas on 2014-04-30.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

/*

 TO DO:
 
 1- Change image views to buttons
 2- Clicking on buttons actions
 3- Add DB for friends 
 4- 
 
*/


#import "ContactsViewController.h"

@interface ContactsViewController ()

@property (strong, nonatomic) NSArray *searchArray;
@property (strong, nonatomic) NSMutableArray *contactsArray;
@property (strong, nonatomic) NSMutableArray *friendsArray;

@end

@implementation ContactsViewController

@synthesize contactsPage1, contactsPage2, contactsPage3, contactsSegmentControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //DISPLAY FIRST TABLE
    [self.contactsSegmentControl setSelectedSegmentIndex:0];
    self.contactsPage1.hidden = NO;
    self.contactsPage2.hidden = YES;
    self.contactsPage3.hidden = YES;
    
    self.contactsArray = [[NSMutableArray alloc] init];
    self.friendsArray = [[NSMutableArray alloc] init];
    self.searchArray = [[NSArray alloc] init];
    
    [self getPersonOutOfAddressBook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ACTION METHODS

- (IBAction)contactsSegmentAction:(UISegmentedControl*)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.contactsPage1.hidden = NO;
            self.contactsPage2.hidden = YES;
            self.contactsPage3.hidden = YES;
            break;
        case 1:
            self.contactsPage1.hidden = YES;
            self.contactsPage2.hidden = NO;
            self.contactsPage3.hidden = YES;
            break;
        case 2:
            self.contactsPage1.hidden = YES;
            self.contactsPage2.hidden = YES;
            self.contactsPage3.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.contactsPage1) {
        return [self.friendsArray count];
    }else if(tableView == self.contactsPage2){
        return [self.contactsArray count];
    }else if(tableView == self.contactsPage3){
        return [self.searchArray count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    if(tableView == contactsPage1){
        
        FriendTableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        }
        Person *person = [self.contactsArray objectAtIndex:indexPath.row];
        
        cell.friendName.text = person.fullName;
        
        return cell;
        
    }else if (tableView == contactsPage2){
        
        ContactTableViewCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIdentifier];
        }
        Person *person = [self.contactsArray objectAtIndex:indexPath.row];
        
        cell.contactName.text = person.fullName;
        
        return cell;
        
    }else if (tableView == contactsPage3){
        SearchTableViewCell *cell = [tableView
                                      dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellIdentifier];
        }
        Person *person = [self.searchArray objectAtIndex:indexPath.row];
        
        cell.searchName.text = person.fullName;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}



#pragma SEARCH BAR DELEGATE

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    [self filterContentForSearchText:searchText
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"name contains[c] %@", searchText);
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullName contains[c] %@", searchText];
    //NSArray  *myArray = [[NSArray alloc] initWithObjects:@"foo",@"bar",@"baz", nil];
    self.searchArray = [self.contactsArray filteredArrayUsingPredicate:resultPredicate];
    [self.contactsPage3 reloadData];
}

#pragma DATABASE

- (void)getPersonOutOfAddressBook
{
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook =
    ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook != nil)
    {
        NSLog(@"Succesful.");
        
        NSArray *allContacts = (__bridge_transfer NSArray
                                *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            Person *person = [[Person alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString
                                   *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString
                                   *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                                  firstName, lastName];
            
            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            NSLog(@"First = %@, Second = %@", firstName, fullName);
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson,
                                                       kABPersonEmailProperty);
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString
                                   *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                {
                    person.homeEmail = email;
                    NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                else if (j==1)
                    person.workEmail = email;
            }
            
            [self.contactsArray addObject:person];
        }
    }
    
    CFRelease(addressBook);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AddressTableViewController.m
//  Msg
//
//  Created by Michael Ghattas on 2014-04-28.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//  Test

#import "AddressTableViewController.h"

@interface AddressTableViewController ()

@property (strong, nonatomic) NSArray *searchArray;
@property (strong, nonatomic) NSMutableArray *contactsArray;
@property (strong, nonatomic) NSMutableArray *friendsArray;

@end

@implementation AddressTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contactsArray = [[NSMutableArray alloc] init];
    
    [self getPersonOutOfAddressBook];
    
    [self setupFriends];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupFriends{
    
}

- (void)setupContacts{
    
}

- (void)setupSearch{
    
}

#pragma ACTIONS

- (IBAction)contactsSegmentAction:(UISegmentedControl*)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self setupFriends];
            break;
        case 1:
            [self setupContacts];
            break;
        case 2:
            [self setupSearch];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
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
    return [self.contactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.contactsSegmentControl selectedSegmentIndex] == 0 ) {
        cellIdentifier = @"friends";
    }else if ([self.contactsSegmentControl selectedSegmentIndex] == 1 ){
        cellIdentifier = @"contacts";
    }else if ([self.contactsSegmentControl selectedSegmentIndex] == 2 ){
        cellIdentifier = @"search";
    }
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    Person *person = [self.contactsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = person.fullName;
    
    return cell;
}

#pragma SEARCH METHODS

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"Searching");
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"name contains[c] %@", searchText);
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    NSArray  *myArray = [[NSArray alloc] initWithObjects:@"foo",@"bar",@"baz", nil];
    self.searchArray = [myArray filteredArrayUsingPredicate:resultPredicate];
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

//
//  ContactsViewController.h
//  Msg
//
//  Created by Michael Ghattas on 2014-04-30.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Person.h"
#import "ContactTableViewCell.h"
#import "FriendTableViewCell.h"
#import "SearchTableViewCell.h"

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

//VIEWS
@property (weak, nonatomic) IBOutlet UITableView *contactsPage1;
@property (weak, nonatomic) IBOutlet UITableView *contactsPage2;
@property (weak, nonatomic) IBOutlet UITableView *contactsPage3;

//SEGMENT
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactsSegmentControl;

//ACTIONS
- (IBAction)contactsSegmentAction:(id)sender;


@end

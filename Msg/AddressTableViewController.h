//
//  AddressTableViewController.h
//  Msg
//
//  Created by Michael Ghattas on 2014-04-28.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Person.h"

@interface AddressTableViewController : UITableViewController{
    NSString *cellIdentifier;
}

//SEGMENT
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactsSegmentControl;

//ACTIONS
- (IBAction)contactsSegmentAction:(id)sender;

@end

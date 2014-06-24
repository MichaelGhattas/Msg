//
//  ContactTableViewCell.h
//  Msg
//
//  Created by Michael Ghattas on 2014-04-28.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UILabel *contactDescription;

@end

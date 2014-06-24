//
//  AddressTableViewCell.h
//  Msg
//
//  Created by Michael Ghattas on 2014-05-04.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *addressImage;
@property (strong, nonatomic) IBOutlet UILabel *addresshName;
@property (strong, nonatomic) IBOutlet UILabel *addressDescription;


@end

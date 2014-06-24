//
//  SearchTableViewCell.h
//  Msg
//
//  Created by Michael Ghattas on 2014-05-04.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *searchImage;
@property (strong, nonatomic) IBOutlet UILabel *searchName;
@property (strong, nonatomic) IBOutlet UILabel *searchDescription;

@end

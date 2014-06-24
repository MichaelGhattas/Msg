//
//  ChatsTableViewCell.h
//  Msg
//
//  Created by Michael Ghattas on 2014-04-28.
//  Copyright (c) 2014 Ghattas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatsTableViewCell : UITableViewCell{
    
    IBOutlet UIImageView *chatsImage;
    IBOutlet UILabel *chatsName;
    IBOutlet UILabel *chatsDescription;
}

@end

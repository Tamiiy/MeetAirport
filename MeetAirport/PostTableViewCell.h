//
//  PostTableViewCell.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/11.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PFImageView.h"

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (weak, nonatomic) IBOutlet PFImageView *userImg;

- (void)setDataIndexPath:(NSIndexPath *)indexPath;
- (void)setDataOfParse:(NSDictionary *)dataOfParse;

@end

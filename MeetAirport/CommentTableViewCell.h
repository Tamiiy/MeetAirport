//
//  CommentTableViewCell.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/26.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *nationality;

- (void)setDataOfComments:(NSDictionary *)dataOfComments;

@end

//
//  CommentTableViewCell.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/26.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <Parse/Parse.h>

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setDataOfComments:(NSDictionary *)dataOfComments {
    
    [self initFont];
    
    //string系の表示
    self.nameLabel.text = dataOfComments[@"userName"];
    self.contentsTextView.text = dataOfComments[@"comment"];
    
    //画像の表示
    [dataOfComments[@"userImg"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            self.userImg.image = image;
        }
    }];
}

-(void)initFont {
    self.nameLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:10.0f];
    self.contentsTextView.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14.0f];
    self.nationality.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:9.0f];
}


@end

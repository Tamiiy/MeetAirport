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
    NSLog(@"==========================");
    NSLog(@"セルから出力してるぜよ%@",dataOfComments);
    NSLog(@"==========================");
    
    //string系の表示
    self.nameLabel.text = dataOfComments[@"userName"];
    self.contentsTextView.text = dataOfComments[@"comment"];
    
    //画像の表示
    [dataOfComments[@"useImg"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"%@",image);
            self.userImg.image = image;
        }
    }];
    
}


@end

//
//  PostTableViewCell.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/11.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "PostTableViewCell.h"
#import "PFImageView.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


// PostTableViewControllerから渡ってきたデータを表示
- (void)setDataOfParse:(NSDictionary *)dataOfParse {
    
    [self initFont];
    
    //string系の表示
    self.nameLabel.text = dataOfParse[@"userName"];
    self.titleLabel.text = dataOfParse[@"title"];
    self.contentsTextView.text = dataOfParse[@"contents"];
    
    //DateTime系の表示
    NSDateFormatter * form = [[NSDateFormatter alloc] init]; //フォーマッタを生成
    [form setDateFormat: @"yyyy/MM/dd HH:mm"]; //フォーマットを設定
    NSString * departureTime = [form stringFromDate: dataOfParse[@"departureTime"]]; //日付をフォーマット
    self.datetimeLabel.text = departureTime; //ラベルに設定
    
    [dataOfParse[@"userImg"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            self.userImg.image = image;
        }
    }];
}

-(void)initFont {
    self.nameLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:10.0f];
    self.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:17.0f];
    self.contentsTextView.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14.0f];
    self.datetimeLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:12.0f];
    self.nationality.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:9.0f];
    
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nationality.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentsTextView.lineBreakMode = NSLineBreakByWordWrapping;
}


@end

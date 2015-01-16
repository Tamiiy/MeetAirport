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


//PostTableViewControllerから渡ってきたデータを表示
- (void)setDataOfParse:(NSDictionary *)dataOfParse {
    
    NSLog(@"==========================");
    NSLog(@"セルから出力してるぜよ%@",dataOfParse);
    NSLog(@"==========================");
    
    //string系の表示
    self.nameLabel.text = dataOfParse[@"Name"];
    self.titleLabel.text = dataOfParse[@"Title"];
    self.contentsTextView.text = dataOfParse[@"Contents"];
    
    //DateTime系の表示
    NSDateFormatter * form = [[NSDateFormatter alloc] init]; //フォーマッタを生成
    [form setDateFormat: @"yyyy/MM/dd HH:mm"]; //フォーマットを設定
    NSString * departureTime = [form stringFromDate: dataOfParse[@"DepartureTime"]]; //日付をフォーマット
    self.datetimeLabel.text = departureTime; //ラベルに設定
    
    //Imageの読み込み
    //        PFImageView *_pfImgView;
    //        self.userImg.file = dataOfParse[@"Image"]; // 表示する画像をPFFileとして指定
    //        [self.userImg loadInBackground]; // 画像読み込み
    //        NSLog(@"%@",self.userImg.image);
    //        self.userImg = _pfImgView;
    
    [dataOfParse[@"Image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"%@",image);
            self.userImg.image = image;
        }
    }];
}



/*
- (void)setDataIndexPath:(NSIndexPath *)indexPath {

    // Parseからデータ読み込み
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:@"Oj6tj81LrS" block:^(PFObject *object, NSError *error) {

        NSLog(@"==========================");
        NSLog(@"%@",object);
        NSLog(@"==========================");
        
        //string系の表示
        self.nameLabel.text = object[@"Name"];
        self.titleLabel.text = object[@"Title"];
        self.contentsTextView.text = object[@"Contents"];
        
        //DateTime系の表示
        NSDateFormatter * form = [[NSDateFormatter alloc] init]; //フォーマッタを生成
        [form setDateFormat: @"yyyy/MM/dd HH:mm"]; //フォーマットを設定
        NSString * departureTime = [form stringFromDate: object[@"DepartureTime"]]; //日付をフォーマット
        self.datetimeLabel.text = departureTime; //ラベルに設定
        
        //Imageの読み込み
//        PFImageView *_pfImgView;
//        self.userImg.file = object[@"Image"]; // 表示する画像をPFFileとして指定
//        [self.userImg loadInBackground]; // 画像読み込み
//        NSLog(@"%@",self.userImg.image);
//        self.userImg = _pfImgView;
        
        [object[@"Image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"%@",image);
                self.userImg.image = image;
            }
        }];
    }];
}
*/


@end

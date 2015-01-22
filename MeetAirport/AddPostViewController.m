//
//  AddPostViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "AddPostViewController.h"
#import "PostTableViewController.h"
#import <Parse/Parse.h>

@interface AddPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RMDateSelectionViewControllerDelegate>

@property NSDate *tmpDate;
@property NSData *imgData;


@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //国籍が選択されたら、ラベルに入れ直す
    if (self.selectedNationality != nil) {
        self.outputNationality.text = self.selectedNationality;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * 画像をカメラロールから取得してUIViewに表示
 */

//カメラロールの起動と画像選択処理
- (IBAction)changePhoto:(id)sender {
    UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
//画像選択後にUIimageViewに表示させる
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        // Parseに保存するため、Data型にコンバートして格納
        self.imgData = UIImageJPEGRepresentation(image, 0.5f);
        // 選択した画像を表示
        self.userImage.image = image;
    }];
}


/**
 * 時刻をActionSheet＋DatePickerで入力(RMていう素敵ライブラリ使用)
 */

- (IBAction)actionDatePicker:(id)sender {
    NSLog(@"日付設定のボタンが押されたよ！");
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    [dateSelectionVC show];
}
//NSDate → NSString に変換する関数
+ (NSString*)dateToString:(NSDate *)baseDate formatString:(NSString *)formatString
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    //24時間表示 & iPhoneの現在の設定に合わせる
    [inputDateFormatter setLocale:[NSLocale currentLocale]];
    [inputDateFormatter setDateFormat:formatString];
    NSString *str = [inputDateFormatter stringFromDate:baseDate];
    return str;
}
//時刻設定完了時の処理
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateStr = [AddPostViewController dateToString:aDate formatString:@"yyyy-MM-dd HH:mm"];
    self.tmpDate = aDate;
    self.outputTime.text = dateStr;
}
//時刻設定キャンセル時の処理
- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    //Do Nothing
}


/**
 * 入力したデータをINSERTして、画面を閉じる
 */

- (IBAction)insertPost:(id)sender {
    PFObject *insertObject = [PFObject objectWithClassName:@"Post"];
    insertObject[@"Name"] = self.inputName.text;
    insertObject[@"Title"] = self.inputTitle.text;
    insertObject[@"Contents"] = self.inputContents.text;
    insertObject[@"DepartureTime"] = self.tmpDate;
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.imgData];
    insertObject[@"Image"] = imageFile;

    [insertObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Save成功");
        }
        else{
            // Error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    //Post一覧に遷移
    PostTableViewController *postTableViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"postTableViewController"];
    [self presentViewController:postTableViewController animated:YES completion:nil];
}


@end

//
//  AddPostViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "AddPostViewController.h"
#import "PostTableViewController.h"
#import "SelectNationalityTableViewController.h"
#import <Parse/Parse.h>

@interface AddPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RMDateSelectionViewControllerDelegate>

@property NSDate *tmpDate;
@property NSData *imgData;


@end

@implementation AddPostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * 国籍選択から戻ってきたときの処理
 */

- (void)viewWillAppear:(BOOL)animated {
    // ユーザデフォルトの国籍を呼び出して、文字列として出力
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *nationality = [defaults stringForKey:@"nationality"];
    self.outputNationality.text = nationality;
}


/**
 * 画像をカメラロールから取得してUIViewに表示
 */

// カメラロールの起動と画像選択処理
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
// 画像選択後にUIimageViewに表示させる
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
// NSDate → NSString に変換する関数
+ (NSString*)dateToString:(NSDate *)baseDate formatString:(NSString *)formatString
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    // 24時間表示 & iPhoneの現在の設定に合わせる
    [inputDateFormatter setLocale:[NSLocale currentLocale]];
    [inputDateFormatter setDateFormat:formatString];
    NSString *str = [inputDateFormatter stringFromDate:baseDate];
    return str;
}
// 時刻設定完了時の処理
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateStr = [AddPostViewController dateToString:aDate formatString:@"yyyy-MM-dd HH:mm"];
    self.tmpDate = aDate;
    self.outputTime.text = dateStr;
}
// 時刻設定キャンセル時の処理
- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    //Do Nothing
}


/**
 * 入力したデータをINSERTして、画面を閉じる
 */

- (IBAction)insertPost:(id)sender {
    PFObject *insertObject = [PFObject objectWithClassName:@"Post"];
    insertObject[@"userName"] = self.inputName.text;
    insertObject[@"nationality"] = self.outputNationality.text;
    insertObject[@"title"] = self.inputTitle.text;
    insertObject[@"contents"] = self.inputContents.text;
    insertObject[@"departureTime"] = self.tmpDate;
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:self.imgData];
    insertObject[@"userImg"] = imageFile;
    
    // ユーザデフォルトのAirportのIDを呼び出して、objectに格納
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *airportId = [defaults stringForKey:@"airportId"];
    insertObject[@"airportId"] = airportId;

    [insertObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Save成功");
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    // Post一覧に遷移
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

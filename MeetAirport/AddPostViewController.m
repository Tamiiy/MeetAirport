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

@interface AddPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RMDateSelectionViewControllerDelegate, UITextViewDelegate>

@property NSDate *tmpDate;
@property NSData *imgData;
@property NSMutableDictionary *storeObject;
@property UIScrollView *myScrollView;

@end

@implementation AddPostViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // ユーザデフォルトのユーザ情報を呼び出して、初期値として出力(if文の分岐いらんのか?)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"userName"] != nil) {
        self.inputName.text = [defaults stringForKey:@"userName"];
        NSData *imgData = [defaults dataForKey:@"userImg"];
        self.userImage.image = [[UIImage alloc] initWithData:imgData];
        self.imgData = imgData;
    }
    
    self.inputContents.delegate = self;
    [self setTapGesture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * 国籍選択から戻ってきたときの処理
 */

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.outputNationality.text = [defaults stringForKey:@"userNationality"];
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

    /**
     * Parse上のデータベースに保存する
     */
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
    
    /**
     * ユーザデフォルトに、選択されたデータ履歴を格納
     */
    self.storeObject = [[NSMutableDictionary alloc] init];
    
    // 非常に美しくないけどuserDefault用にもうひとつDictionaryをつくる
    [self.storeObject setObject:self.inputName.text forKey:@"userName"];
    [self.storeObject setObject:self.outputNationality.text forKey:@"nationality"];
    [self.storeObject setObject:self.inputTitle.text forKey:@"title"];
    [self.storeObject setObject:self.inputContents.text forKey:@"contents"];
    [self.storeObject setObject:self.tmpDate forKey:@"departureTime"];
    [self.storeObject setObject:self.imgData forKey:@"imageFile"];
    [self.storeObject setObject:airportId forKey:@"airportId"];
    
    // userDefaultに保存するため、Arrayに追加・NSDataに変換して格納する
    NSData *storePostData = [defaults dataForKey:@"storePost"];
    NSMutableArray *addStorePost = [[NSMutableArray alloc] init];
    addStorePost = [NSKeyedUnarchiver unarchiveObjectWithData:storePostData];
    [addStorePost addObject:self.storeObject];
    
    NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:addStorePost];
    [defaults setObject:classData forKey:@"storePost"];
    
    // ユーザー情報の更新
    [defaults setObject:self.inputName.text forKey:@"userName"];
    [defaults setObject:self.imgData forKey:@"userImg"];
    
    // 保存
    [defaults synchronize];
    
    // Post一覧に遷移
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)readUserDefaultString:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults stringForKey:key];
    return string;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 * 画面のどこかをタップしたら、キーボードが引っ込むようにする
 */

- (void)setTapGesture{
    // シングルタップ
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    // デリゲートをセット
    tapGesture.delegate = self;
    // view に追加
    [self.view addGestureRecognizer:tapGesture];
}
- (void)tapped:(UITapGestureRecognizer *)sender{
    // 画面のどこかをシングルタップしたら、キーボードを閉じる
    [self.view endEditing:YES];
}


/**
 * キーボードを出現させたときに画面を動かす処理
 */

- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGPoint scrollPoint = CGPointMake(0.0,300.0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}



@end

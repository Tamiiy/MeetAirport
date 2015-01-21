//
//  AddPostViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "AddPostViewController.h"
#import <Parse/Parse.h>

@interface AddPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)insertPost:(id)sender {
    PFObject *insertObject = [PFObject objectWithClassName:@"Post"];
    insertObject[@"Name"] = self.inputName.text;
    [insertObject saveInBackground];
}


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
        self.userImage.image = image;
    }];
}

/**
 * 時刻をActionSheet＋DatePickerで入力
 */
- (IBAction)actionDatePicker:(id)sender {
    NSLog(@"日付設定のボタンが押されたよ！");

    /**
     * UIActionViewを、何も入っていない状態で生成
     */
    basicSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    //アクションシートのスタイルを黒に設定
    [basicSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    /**
     * UIDatePickerの生成
     */
    //アクションシートの箱を基準として、上から(y座標)44の位置に表示させる
    CGRect pickerFrame = CGRectMake(0, 44, 320, 520);
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    //日時分どれを表示するか設定(ModeDateAndTime:日時・ModeTime:時間のみ)
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    //5分刻みで選べるようにする
    datePicker.minuteInterval = 5;
    // 日付ピッカーの値が変更されたときに呼ばれるメソッドを設定
//    [datePicker addTarget:self
//                   action:@selector(datePicker_ValueChanged:)
//         forControlEvents:UIControlEventValueChanged];
    // UIDatePickerのインスタンスをアクションビューに追加
    [basicSheet addSubview:datePicker];
    
    //アクションシートを表示
    [basicSheet setBounds:CGRectMake(0, 0, 320, 520)];
    [basicSheet showInView:self.view];
    
    
    /**
     * 決定・キャンセルボタンの作成
     */
    
    
    /**
     * UIDatePickerの値を反映させる
     */
    //日付の表示形式を設定
//    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
//    //ja_JPは24h表示、AM、PMの場合はen_US
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [inputDateFormatter setLocale:locale];
//    [inputDateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
//    [inputDateFormatter setDateFormat:@"YY:H:mm"];
////    NSString *inputDateStr = 
////    NSDate *inputDate = [inputDateFormatter dateFromString:inputDateStr];
//    [datePicker setLocale:locale];
////    [datePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
////    [datePicker setDate:inputDate];
//    
//     //UIDatePickerをUIActionSheetに組み込む
//     [basicSheet addSubview:datePicker];
//     
//     //モーダルから抜け出すためのボタン生成
//    UIToolbar *controlToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, basicSheet.bounds.size.width, 44)];
//    [controlToolBar setBarStyle:UIBarStyleBlack];
//    [controlToolBar sizeToFit];
    
//    UIBarButtonItem *spacer
    
}

- (void)datePicker_ValueChanged:(id)sender {
    
}

@end

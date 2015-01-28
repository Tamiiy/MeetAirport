//
//  AddCommentViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/27.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "AddCommentViewController.h"
#import "SelectNationalityTableViewController.h"
#import "CommentTableViewController.h"

@interface AddCommentViewController ()

@property NSData *imgData;

@end

@implementation AddCommentViewController

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
    NSLog(@"こくせき%@",nationality);
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
 * 入力したデータをINSERTして、画面を閉じる
 */

- (IBAction)insertPost:(id)sender {
    PFObject *insertObject = [PFObject objectWithClassName:@"Comment"];
    insertObject[@"postObjectId"] = self.selectedObjectId;
    insertObject[@"userName"] = self.inputName.text;
    insertObject[@"nationality"] = self.outputNationality.text;
    insertObject[@"comment"] = self.inputContents.text;
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.imgData];
    insertObject[@"userImg"] = imageFile;
    
    [insertObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Save成功");
            CommentTableViewController *commentTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"commentView"];
            [commentTableViewController reload];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    // Comment一覧に遷移
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
#import "SVProgressHUD.h"

@interface AddCommentViewController () <UITextViewDelegate, UIGestureRecognizerDelegate>

@property NSData *imgData;

@end

@implementation AddCommentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // ユーザ初期値設定
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.inputName.text = [defaults stringForKey:@"userName"];
    NSData *imgData = [defaults dataForKey:@"userImg"];
    self.userImage.image = [[UIImage alloc] initWithData:imgData];
    self.imgData = imgData;
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2);
    
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
    // ユーザデフォルトの国籍を呼び出して、文字列として出力
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
 * 入力したデータをINSERTして、画面を閉じる
 */

- (IBAction)insertPost:(id)sender {
    [SVProgressHUD show];
    
    PFObject *insertObject = [PFObject objectWithClassName:@"Comment"];
    insertObject[@"postObjectId"] = self.selectedObjectId;
    insertObject[@"userName"] = self.inputName.text;
    insertObject[@"nationality"] = self.outputNationality.text;
    insertObject[@"comment"] = self.inputContents.text;
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.imgData];
    insertObject[@"userImg"] = imageFile;
    
    [insertObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // 今SaveしたデータのPostのIDをとってくる
            PFQuery *queryPost = [PFQuery queryWithClassName:@"Comment"];
            [queryPost orderByDescending:@"createdAt"];
            PFObject *firstObject = queryPost.getFirstObject;
            NSString *selectedObjectId = [firstObject objectForKey:@"postObjectId"];
            NSLog(@"%@",selectedObjectId);
            
            // とってきたIDをユーザデフォルトに保存
            NSMutableArray *myObjectIdArray = [[NSMutableArray alloc]init];
            // 既にユーザデフォルトのデータがある場合、Arrayにセットする
            if([defaults arrayForKey:@"myObjectIdArray"] != nil) {
                myObjectIdArray = [[defaults arrayForKey:@"myObjectIdArray"] mutableCopy];
            }
            // 新しいデータを追加
            [myObjectIdArray addObject:selectedObjectId];
            [defaults setObject:myObjectIdArray forKey:@"myObjectIdArray"];
            
            [defaults synchronize];
            
            [SVProgressHUD showSuccessWithStatus:@"Save Success!"];
            
            CommentTableViewController *commentTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"commentView"];
            [commentTableViewController reload];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [SVProgressHUD showErrorWithStatus:@"Save Faild.."];
        }
    }];
    
    
    /**
     * 履歴表示のため、PostDataをユーザデフォルトに保存する（これ悪手やな・・）
     */
    
    PFQuery *queryPost = [PFQuery queryWithClassName:@"Post"];
    // postSelectedIdと一致するデータをfindする
    [queryPost whereKey:@"objectId" equalTo: self.selectedObjectId];
    NSArray *postObject = queryPost.findObjects;
    NSDictionary *storePost = postObject.firstObject;
    
    // ユーザデフォルトに保存できるように整形
    NSMutableDictionary *storePostDic = [[NSMutableDictionary alloc]init];
    [storePostDic setObject:storePost[@"userName"] forKey:@"userName"];
    [storePostDic setObject:storePost[@"nationality"] forKey:@"nationality"];
    [storePostDic setObject:storePost[@"title"] forKey:@"title"];
    [storePostDic setObject:storePost[@"contents"] forKey:@"contents"];
    [storePostDic setObject:storePost[@"departureTime"] forKey:@"departureTime"];
    NSData *imgData = [storePost[@"userImg"] getData];
    [storePostDic setObject:imgData forKey:@"imageFile"];
    [storePostDic setObject:storePost[@"airportId"] forKey:@"airportId"];
    NSLog(@"%@", storePostDic);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *addStorePost = [[NSMutableArray alloc] init];
    // 既にユーザデフォルトのデータがある場合、Arrayにセットする
    if([defaults arrayForKey:@"storePostArray"] != nil) {
        addStorePost = [[defaults arrayForKey:@"storePostArray"] mutableCopy];
    }
    // 新しいデータを追加
    [addStorePost addObject:storePostDic];
    [defaults setObject:addStorePost forKey:@"storePostArray"];
    // ユーザー情報の更新
    [defaults setObject:self.inputName.text forKey:@"userName"];
    [defaults setObject:self.imgData forKey:@"userImg"];
    // 保存
    [defaults synchronize];

    // Comment一覧に遷移
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD dismiss];
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
// 画面のどこかをシングルタップしたら、キーボードを閉じる
- (void)tapped:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

/**
 * キーボードを出現させたときに画面を動かす処理
 */

- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGPoint scrollPoint = CGPointMake(0.0,200.0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}


// Nationalityを選択したときのローディング表示
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [SVProgressHUD show];
}

// cancelボタンの処理
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

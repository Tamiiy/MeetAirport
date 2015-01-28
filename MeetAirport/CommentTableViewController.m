//
//  CommentTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/26.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "CommentTableViewController.h"
#import "PostTableViewCell.h"
#import "CommentTableViewCell.h"
#import "AddCommentViewController.h"

@interface CommentTableViewController ()

@property (nonatomic, retain) NSDictionary *dataOfPost;
@property (nonatomic, retain) NSArray *dataOfComment;

@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // objectIdと一致するPostをfindする(1データ) / 1データ用のfindメソッドありそう・・
    PFQuery *queryPost = [PFQuery queryWithClassName:@"Post"];
    [queryPost whereKey:@"objectId" equalTo: self.selectedObjectId];
    NSArray *postObject = queryPost.findObjects;
    self.dataOfPost = postObject[0];
    
    // postObjectIdと一致するCommentをfindする(複数データ)
    PFQuery *queryComment = [PFQuery queryWithClassName:@"Comment"];
    [queryComment whereKey:@"postObjectId" equalTo: self.selectedObjectId];
    self.dataOfComment = queryComment.findObjects;
}

- (void)viewWillAppear:(BOOL)animated {
    // INSERT後に、即時反映するための処理をかく(あとで)
}

- (void)reload {
    // INSERTされたデータを反映する
    PFQuery *queryComment = [PFQuery queryWithClassName:@"Comment"];
    [queryComment whereKey:@"postObjectId" equalTo: self.selectedObjectId];
    self.dataOfComment = queryComment.findObjects;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        NSInteger count = [self.dataOfComment count];
        return count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 1行目だけ、PostTableViewと同じ表示をする
        PostTableViewCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
        [postCell setDataOfParse: self.dataOfPost];
        return postCell;
    } else {
        // 2行目以降は、CommentTableViewCellの形で表示
        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        NSInteger row = indexPath.row;
        NSDictionary *commentData = self.dataOfComment[row];
        [commentCell setDataOfComments:commentData];
        return commentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 70;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    switch(section) {
        case 0:
            return @"POST";
        case 1:
            return @"COMMENT";
        default:
            return @"セクション";
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToAddComment"]) {
        // コメント追加画面にいくときに、POSTのIDを渡す
        AddCommentViewController *addCommentView = [segue destinationViewController];
        addCommentView.selectedObjectId = self.selectedObjectId;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

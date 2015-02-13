//
//  HistoryTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/02/03.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "PostTableViewCell.h"
#import "CommentTableViewController.h"
#import "SVProgressHUD.h"

@interface HistoryTableViewController ()

@property NSMutableArray *storePostArray;
@property NSArray *myObjectIdArray;
@property NSDictionary *historyPost;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults arrayForKey:@"myObjectIdArray"] != nil) {
        NSArray *tmpMyObjectIdArray = [[defaults arrayForKey:@"myObjectIdArray"] mutableCopy];
        self.myObjectIdArray = [[tmpMyObjectIdArray reverseObjectEnumerator]allObjects];
        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
        self.storePostArray = [[NSMutableArray alloc]init];
        for(NSString *objectId in self.myObjectIdArray){
            [query whereKey:@"objectId" equalTo:objectId];
            NSArray *postObject = query.findObjects;
            NSDictionary *tmpPost = postObject[0];
            [self.storePostArray addObject:tmpPost];
        }
        [SVProgressHUD dismiss];
    }
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.myObjectIdArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    PostTableViewCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];

    [postCell setDataOfParse:self.storePostArray[row]];
    
    return postCell;
}


-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD show];
    NSInteger selectedRow = indexPath.row;
    
    CommentTableViewController *commentView = [self.storyboard instantiateViewControllerWithIdentifier:@"commentView"];
    // 選択されたPOSTのオブジェクトIDを渡す
    commentView.selectedObjectId = self.myObjectIdArray[selectedRow];
    
    [self.navigationController pushViewController:commentView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

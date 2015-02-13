//
//  PostTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/12.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "PostTableViewController.h"
#import "PostTableViewCell.h"
#import "CommentTableViewController.h"
#import "SVProgressHUD.h"


@interface PostTableViewController ()
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToSportTypeMap;
@property (nonatomic, retain) NSArray *dataOfParse;
@property (nonatomic, retain) NSString *airportId;
@end

@implementation PostTableViewController


- (void)viewDidLoad {    
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    // ユーザデフォルトのAirportのIDと空港名を呼び出す
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.airportId = [defaults stringForKey:@"airportId"];
    
    // タイトルに空港名をセット
    self.navigationItem.title = [defaults stringForKey:@"airportName"];;
    
    // AirportIdと一致するデータをfindする
    [query whereKey:@"airportId" equalTo: self.airportId];
    [query orderByDescending:@"createdAt"];

    [SVProgressHUD show];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.dataOfParse = objects;
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"Loading Success!"];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [SVProgressHUD showErrorWithStatus:@"load faild.."];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
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
    NSInteger count = [self.dataOfParse count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    // PostTableViewCellのsetDataOfParseメソッドに、データを1セルずつ引数として渡して呼び出す
    [cell setDataOfParse:self.dataOfParse[row]];
    return cell;
}

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD show];
    NSInteger selectedRow = indexPath.row;
    
    CommentTableViewController *commentView = [self.storyboard instantiateViewControllerWithIdentifier:@"commentView"];
    // 選択されたPOSTのオブジェクトIDを渡す
    PFObject *myObject = self.dataOfParse[selectedRow];
    commentView.selectedObjectId = [myObject objectId];

    [self.navigationController pushViewController:commentView animated:YES];
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

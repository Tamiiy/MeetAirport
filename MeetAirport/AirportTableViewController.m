//
//  AirportTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/09.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "AirportTableViewController.h"
#import "PostTableViewController.h"
#import "SVProgressHUD.h"

@interface AirportTableViewController ()

@property NSArray *airportList;
@property NSArray *airportNames;
@property NSArray *airportCountries;
@property NSArray *airportIds;
@property NSMutableArray *searchResultsArrayDic;
@property BOOL connectionError;
@property (nonatomic, strong) NSArray *searchResults;


@end

@implementation AirportTableViewController


/**
 * イニシャライザ
 */
- (id)init
{
    if (self = [super init]) {
        self.airportList = [[NSArray alloc]init];
        self.connectionError = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delegateメソッドを使う
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // キャッシュがあれば、UserDefaultのデータを入れて終了
    if ([defaults dataForKey:@"airportList"] != nil) {
        self.airportList = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults dataForKey:@"airportList"]];
        [SVProgressHUD dismiss];
        
    // なければ、jsonからデータを取得する
    } else {
        NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/tdreyno/4278655/raw/755b1cfc5ded72d7b45f97b9c7295d525be18780/airports.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        // データが取得できた場合
        if (json_data != nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:nil];

            self.airportList = jsonObject;
            
            // userDefaultにキャッシュとして保存
            NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:jsonObject];
            [defaults setObject:classData forKey:@"airportList"];
            [defaults synchronize];
            [SVProgressHUD dismiss];
            
        // データが取得できなかった場合(ネット通信がBADな場合)
        } else {
            self.connectionError = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.connectionError == NO) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return self.searchResults.count;
        } else {
            return self.airportList.count;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"airportListCell"];
    NSInteger row = indexPath.row;
    
    // 一括でラベルのフォントをAppleSDGothicNeo-Thinのサイズ20.0fに統一する
    cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:20.0f];

    if (self.connectionError == NO) {
        NSDictionary *airportListCell;
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            airportListCell = self.searchResultsArrayDic[row];
        } else {
            airportListCell = self.airportList[row];
        }
        cell.textLabel.text = airportListCell[@"name"];
        cell.detailTextLabel.text = airportListCell[@"country"];
        return cell;
    } else {
        cell.textLabel.text = @"connection Error";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.connectionError == NO) {
        return UITableViewAutomaticDimension;
    } else {
        CGRect cr = [[UIScreen mainScreen] applicationFrame];
        return cr.size.height - 90;
    }
}

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    
    if (self.connectionError == NO) {
        
        //ユーザデフォルトに、選択されたAirportのIDを格納
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selectedAirport;
        if (self.searchResultsArrayDic != nil) {
            selectedAirport = self.searchResultsArrayDic[selectedRow];
        } else {
            selectedAirport = self.airportList[selectedRow];
        }
        [defaults setObject:selectedAirport[@"code"] forKey:@"airportId"];
        [defaults setObject:selectedAirport[@"name"] forKey:@"airportName"];
        [defaults synchronize];
        
        PostTableViewController *postListNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"postTableViewController"];
        [self.navigationController pushViewController:postListNavi animated:YES];
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

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reloadBtn:(id)sender {
    [self.tableView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [SVProgressHUD show];
}


/**
 * 検索機能の実装
 * 【保留】本当は名前だけじゃなくて、辞書型で検索をかけれるようにしたい
 */

- (void)filterContainsWithSearchText:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    self.searchResults = [[self.airportList valueForKeyPath:@"name"] filteredArrayUsingPredicate:predicate];
    
    self.searchResultsArrayDic = [[NSMutableArray alloc]init];

NSLog(@"%d", [self.searchResults count]);
    
    for (NSString *searchResult in self.searchResults) {
        NSDictionary *searchResultDic = [self.airportList objectAtIndex:[[self.airportList valueForKeyPath:@"name"] indexOfObject:searchResult]];
        [self.searchResultsArrayDic addObject:searchResultDic];
    }
}
- (BOOL)searchDisplayController:controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 検索バーに入力された文字列をが3文字以上のときに、検索をかける
    if ([searchString length] > 2) {
        [self filterContainsWithSearchText:searchString];
    }
    
    // YESを返すとテーブルビューがリロードされます。
    // リロードすることでdataSourceSearchResultsiPhoneとdataSourceSearchResultsAndroidからテーブルビューを表示します
    return YES;
}

@end

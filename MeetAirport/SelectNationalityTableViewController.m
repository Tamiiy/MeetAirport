//
//  SelectNationalityTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "SelectNationalityTableViewController.h"
#import "AddPostViewController.h"

@interface SelectNationalityTableViewController ()

@property NSArray *countries;

@end

@implementation SelectNationalityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ユーザデフォルトのデータを呼び出す
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // キャッシュがあれば、UserDefaultのデータを入れて終了
    if ([defaults dataForKey:@"countriesName"] != nil) {
        self.countries = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults dataForKey:@"countriesName"]];
        
    // なければ、jsonからデータを取得する
    } else {

        NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/umpirsky/country-list/master/country/cldr/en/country.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:nil];
    
        NSInteger count = 0;
        NSMutableArray *countriesName = [NSMutableArray array];
    
        for (id key in [jsonObject allKeys]) {
            [countriesName addObject:[jsonObject valueForKey:key]];
            count ++;
        }
        self.countries = countriesName;
        
        // userDefaultにキャッシュとして保存
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:countriesName];
        [defaults setObject:classData forKey:@"countriesName"];
        [defaults synchronize];
    }
    
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
    return self.countries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContriesCell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.countries[row];
    
    return cell;
}

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    
    //ユーザデフォルトに国籍を保存
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: self.countries[selectedRow] forKey:@"userNationality"];
    //synchronize: すぐに保存したいときに利用
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

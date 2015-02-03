//
//  AirportTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/09.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "AirportTableViewController.h"
#import "PostTableViewController.h"

@interface AirportTableViewController ()

@property NSDictionary *airportList;

@end



@implementation AirportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ユーザデフォルトのAirportのデータを呼び出す
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // キャッシュがあれば、UserDefaultのデータを入れて終了
    if ([defaults stringForKey:@"airportList"] != nil) {
        self.airportList = [defaults dictionaryForKey:@"airportList"];
    } else {
    // なければ、jsonからデータを取得する
        //Airport一覧のデータを取得して、辞書型airportListに代入
        NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/tdreyno/4278655/raw/755b1cfc5ded72d7b45f97b9c7295d525be18780/airports.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
        NSURLResponse *response = nil;
        NSError *error = nil;
    
        NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        if (json_data != nil) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:nil];

//            NSDictionary *airportLists;
//            
//            for (NSMutableDictionary *jsonObject in jsonObjects) {
//                [self cleanDictionary:jsonObject];
//            }
//
//            
//            NSMutableDictionary *mutableJsonData = [[NSMutableDictionary alloc] init];
//            
            
            
//            for (id key in [jsonObject keyEnumerator]) {
//                NSLog(@"Key:%@ Value:%@", key, [jsonObject valueForKey:key]);
//            }
//            
//            
//            NSLog(@"みゅーたぶる１%@",mutableJsonData);
//            [self cleanDictionary:mutableJsonData];
//            NSLog(@"みゅーたぶる２%@",mutableJsonData);
            

            
            self.airportList = jsonObject;
            
            // ユーザデフォルトに、選択されたAirportのIDを格納
//            [defaults setObject:jsonObjects forKey:@"airportLists"];
            // synchronize: すぐに保存したいときに利用
//            [defaults synchronize];


            // 別の手段でplistに入れてみる
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"airportList" ofType:@"plist"];
//            
//            //Cacheディレクトリ
//            NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"airportList.plist"];
//            
//            NSFileManager *filemanager = [NSFileManager defaultManager];
//            if (![filemanager fileExistsAtPath:cachePath]) {
//                [filemanager copyItemAtPath:path toPath:cachePath error:nil];
//            }
//            
//            //plistファイルの読み込み
//            NSMutableArray* airportList = [NSMutableArray arrayWithContentsOfFile:cachePath];
//            
//            //plistに追記
//            [airportList addObject:@"sample1"];
//            
//            //保存
//            BOOL result = [airportList writeToFile:cachePath atomically:NO];
//            if (!result) {
//                NSLog(@"ファイルの書き込みに失敗");
//            } else {
//                NSLog(@"ファイルの書き込みが完了しました");
//            }
            
            
//            NSArray *array = [NSArray arrayWithObjects:@"tokyo", @"nagoya", @"osaka", nil];
//            [self saveToPlistWithDictionary:self.airportList];
//            
//            [self rwDataToPlist:airportList playerColor: withData:<#(NSArray *)#>]
            
            
            // plistに、最新のjson情報を格納
            // ホームディレクトリを取得
//            NSString *homeDir = NSHomeDirectory();
//            NSLog(@"ほーむでぃれくとり%@",homeDir);
//            // 書き込みたいplistのパスを作成
//            NSString *filePath = [homeDir stringByAppendingPathComponent:@"airportList.plist"];
//            NSLog(@"ふぁいるぱす%@",filePath);
//            // 書き込み
//            BOOL result = [self.airportList writeToFile:filePath atomically:YES];
//            if (!result) {
//                NSLog(@"ファイルの書き込みに失敗");
//            } else {
//                NSLog(@"ファイルの書き込みが完了しました");
//            }
        }
    }
}

- (void)cleanDictionary:(NSMutableDictionary *)dictionary {
    for (id key in [dictionary allKeys]) {
        if ([dictionary valueForKey:key] == [NSNull null]) {
            [dictionary setObject:@"" forKey:key];
        } else if ([[dictionary valueForKey:key] isKindOfClass:[NSDictionary class]]) {
            [self cleanDictionary:[dictionary valueForKey:key]];
        }
    }
}


- (void)saveToPlistWithDictionary:(NSDictionary *)list
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.plist"];
    
    BOOL successful = [list writeToFile:filePath atomically:NO];
    
    if (successful) {
        NSLog(@"%@", @"データの保存に成功");
    }
}

- (void)saveToPlistWithArray:(NSArray *)array
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.plist"];
    
    BOOL successful = [array writeToFile:filePath atomically:NO];
    
    if (successful) {
        NSLog(@"%@", @"データの保存に成功");
    }
}


- (void) rwDataToPlist:(NSString *)fileName playerColor:(NSString *)strPlayer withData:(NSArray *)data

{
    // Step1: Get plist file path
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"Plist File Path: %@", filePath);
    
    // Step2: Define mutable dictionary
    
    NSMutableDictionary *plistDict;
    
    // Step3: Check if file exists at path and read data from the file if exists
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        
    {
        
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
    }
    
    else
        
    {
        
        // Step4: If doesn't exist, start with an empty dictionary
        
        plistDict = [[NSMutableDictionary alloc] init];
        
    }
    
    NSLog(@"plist data: %@", [plistDict description]);
    
    // Step5: Set data in dictionary
    
    [plistDict setValue:data forKey: strPlayer];
    
    // Step6: Write data from the mutable dictionary to the plist file
    
    BOOL didWriteToFile = [plistDict writeToFile:filePath atomically:YES];
    
    if (didWriteToFile)
        
    {
        
        NSLog(@"Write to .plist file is a SUCCESS!");
        
    }
    
    else
        
    {
        
        NSLog(@"Write to .plist file is a FAILURE!");
        
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
    NSInteger airportCount = self.airportList.count;
    return airportCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"airportListCell"];
    NSInteger row = indexPath.row;
    
    // AirPort名と国名だけ取り出して一覧表示する
    NSArray* names = (NSArray*)[self.airportList valueForKey:@"name"];
    NSArray* countries = (NSArray*)[self.airportList valueForKey:@"country"];
    
    NSString *nameData = names[row];
    NSString *countryData = countries[row];
    
    cell.textLabel.text = nameData;
    cell.detailTextLabel.text = countryData;
    
    // 一括でラベルのフォントをAppleSDGothicNeo-Thinのサイズ20.0fに統一する
    cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:20.0f];

    return cell;
}

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    
    NSArray *airportId = (NSArray*)[self.airportList valueForKey:@"code"];
    
    //ユーザデフォルトに、選択されたAirportのIDを格納
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: airportId[selectedRow] forKey:@"airportId"];
    //synchronize: すぐに保存したいときに利用
    [defaults synchronize];
    
    PostTableViewController *postListNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"postTableViewController"];
    [self.navigationController pushViewController:postListNavi animated:YES];
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

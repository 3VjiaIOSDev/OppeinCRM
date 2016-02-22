//
//  SCInfoViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/13.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "SCInfoViewController.h"

@interface SCInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
    NSArray *data1Array;
}
@end

@implementation SCInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    NSLog(@"dicData = %@",self.dicData);
    dataArray = @[@"沟通时间",@"下次沟通时间",@"关键点",@"沟通内容"];
    data1Array = @[self.dicData[@"FollowTime"],self.dicData[@"NextFollowTime"],self.dicData[@"KeyPoints"],self.dicData[@"FollowContext"]];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    [self setExtraCellLineHidden:table];
    [self.view addSubview:table];
}
//tableView 优化
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化导航栏
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"方案交流详情";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [data1Array objectAtIndex:indexPath.row];
    return cell;
}

@end

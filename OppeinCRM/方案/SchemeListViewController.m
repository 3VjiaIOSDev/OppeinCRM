//
//  SchemeListViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/12.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "SchemeListViewController.h"
#import "AddSchemeViewController.h"
#import "SchemeInfoViewController.h"

@interface SchemeListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSMutableArray *dataArr;
}
@end

@implementation SchemeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self initNavigation];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    table.delegate = self;
    table.dataSource = self;
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

-(void)viewDidAppear:(BOOL)animated
{
    [self getSchemeList];
}
//初始化导航栏
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"方案列表";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addScheme)];
    navigationItem.rightBarButtonItem = rightButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"方案名称：%@",[dataArr objectAtIndex:indexPath.row][@"SchemeName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    NSString *detail = [NSString stringWithFormat:@"空间：%@",[dataArr objectAtIndex:indexPath.row][@"SpaceName"]];
    cell.detailTextLabel.text = detail;//SpaceName  Style
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SchemeInfoViewController *vc = [[SchemeInfoViewController alloc]init];
    vc.dicData = [dataArr objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
-(void)addScheme
{
    AddSchemeViewController *vc = [[AddSchemeViewController alloc]init];
    vc.serviceId = self.serviceId;
    vc.serviceNo = self.serviceNo;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)getSchemeList
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,@"ServiceId":self.serviceId};
    [HttpRequset post:dict method:@"Scheme/GetSchemeList" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSArray *JSON = [dic[@"JSON"]objectFromJSONString];
            dataArr = [[NSMutableArray alloc]initWithArray:JSON];
            [table reloadData];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

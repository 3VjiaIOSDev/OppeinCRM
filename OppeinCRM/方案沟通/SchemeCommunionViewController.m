//
//  SchemeCommunionViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/13.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "SchemeCommunionViewController.h"
#import "NewSCViewController.h"
#import "SCInfoViewController.h"

@interface SchemeCommunionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    AFLoadIngView *afloading;
    UITableView *table;
    NSArray *dataArray;
}
@end

@implementation SchemeCommunionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [self GetSchemeFollowUpList];
}

//初始化导航栏
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"方案沟通列表";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(newSC)];
    navigationItem.rightBarButtonItem = rightButton;
    
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
-(void)newSC
{
    NewSCViewController *vc = [[NewSCViewController alloc]init];
    vc.serviceId = self.serviceId;
    vc.serviceNo = self.serviceNo;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GetSchemeFollowUpList
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code,@"ServiceId":self.serviceId};
    [HttpRequset post:dict method:@"scheme/GetSchemeFollowUpList" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            dataArray = [dic[@"JSON"]objectFromJSONString];
            [table reloadData];
        }
       
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idenfier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"沟通时间：%@",[[dataArray objectAtIndex:indexPath.row][@"CreateTime"]substringToIndex:10]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"关键点：%@",[dataArray objectAtIndex:indexPath.row][@"KeyPoints"]];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCInfoViewController *vc = [[SCInfoViewController alloc]init];
    vc.dicData = [dataArray objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
@end

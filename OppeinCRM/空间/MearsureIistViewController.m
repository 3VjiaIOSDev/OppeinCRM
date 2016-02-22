//
//  MearsureIistViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/12.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "MearsureIistViewController.h"
#import "AddSpaceViewController.h"
#import "SpaceInfoViewController.h"

@interface MearsureIistViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MearsureIistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self setExtraCellLineHidden:self.customerTable];
    [self.view addSubview:self.customerTable];
    
    [self initNavigation];
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
    [self getCustomerMeasureInfo];
}
//初始化导航栏
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"量尺列表";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addRoom)];
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
    return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customerAry2.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 15)];
        timeLab.text = [self.customerAry2 objectAtIndex:indexPath.row];
        timeLab.textAlignment = NSTextAlignmentLeft;
        timeLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:timeLab];
        
        UILabel *typeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 200, 20)];
        typeLab.text = [self.customerAry3 objectAtIndex:indexPath.row];
        typeLab.font = [UIFont systemFontOfSize:15.0f];
        typeLab.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:typeLab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(self.view.frame.size.width-80, 15, 50, 30);
        
        if ([[self.isUpdataAry objectAtIndex:indexPath.row]integerValue] == 0) {
            
            [btn setTitle:@"未上传" forState:UIControlStateNormal];
            
            //[btn addTarget:self action:@selector(updataRoomInfo:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btn setTitle:@"已上传" forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:btn];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SpaceInfoViewController *ruleInfoVC = [[SpaceInfoViewController alloc]init];
    ruleInfoVC.MeasureId =[self.customerAry4 objectAtIndex:indexPath.row];
    ruleInfoVC.spaceId = [self.customerAry5 objectAtIndex:indexPath.row];
    ruleInfoVC.ServiceId = self.ServiceId;
    ruleInfoVC.UserId = self.UserId;
    [self presentViewController:ruleInfoVC animated:YES completion:nil];

}
#pragma mark 获取客户的量尺信息

-(void)getCustomerMeasureInfo
{
    self.customerAry2 = [[NSMutableArray alloc]init];
    self.customerAry3 = [[NSMutableArray alloc]init];
    self.customerAry4 = [[NSMutableArray alloc]init];
    self.customerAry5 = [[NSMutableArray alloc]init];
    self.isUpdataAry = [[NSMutableArray alloc]init];
    [infoLab removeFromSuperview];
    [infoBtn removeFromSuperview];
    
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code,@"serviceId":self.ServiceId};
    [HttpRequset post:dict method:@"MeasureSpace/GetMeasureList" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if (([dic[@"Status"]integerValue] == 200)) {
            NSArray *JSON = [dic[@"JSON"]objectFromJSONString];
            for (id relist in JSON) {
                NSString *CreateDate = [relist objectForKey:@"MeasureTime"];
                NSString *HouseType = [relist objectForKey:@"SpaceName"];
                NSString *Style = [relist objectForKey:@"Style"];
                NSString *MeasureId = [relist objectForKey:@"MeasureId"];
                NSString *SpaceId = [relist objectForKey:@"SpaceId"];
                NSNumber *ISUpload = [relist objectForKey:@"ISUpload"];
                //NSLog(@"%d",[ISUpload integerValue]);
                NSString *str = [NSString stringWithFormat:@"%@-%@",HouseType,Style];
                [self.customerAry2 addObject:CreateDate];
                [self.customerAry3 addObject:str];
                [self.customerAry4 addObject:MeasureId];
                [self.customerAry5 addObject:SpaceId];
                [self.isUpdataAry addObject:ISUpload];
            }
            if(self.customerAry2.count <= 0)
            {
                infoLab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 100, 200, 40)];
                infoLab.textAlignment = NSTextAlignmentCenter;
                infoLab.font = [UIFont systemFontOfSize:15.0f];
                infoLab.text = @"暂无量尺信息";
                [self.customerTable addSubview:infoLab];
                
                infoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                infoBtn.frame = CGRectMake((self.view.frame.size.width-60)/2, 130, 60, 40);
                [infoBtn setTitle:@"添加空间" forState:UIControlStateNormal];
                [infoBtn addTarget:self action:@selector(addRoom) forControlEvents:UIControlEventTouchUpInside];
                [self.customerTable addSubview:infoBtn];
                
                return;
            }
            
            [self.customerTable reloadData];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
-(void)addRoom
{
    //{if (![URLApi isPermission:@"302"]) {
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加空间失败" message:@"您当前没有权限添加空间信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
    //    return;
    //}
    AddSpaceViewController *VC = [[AddSpaceViewController alloc]init];
    VC.ServiceId = self.ServiceId;
    VC.UserId = self.UserId;
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

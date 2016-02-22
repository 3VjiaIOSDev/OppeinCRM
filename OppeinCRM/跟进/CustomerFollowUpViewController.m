//
//  CustomerFollowUpViewController.m
//  Crm
//
//  Created by 3Vjia on 15/10/21.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
#define SPACE 10

#import "CustomerFollowUpViewController.h"
#import "NSAlertView.h"
#import "AddFollowUpViewController.h"

@interface CustomerFollowUpViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *followUpTable;
    NSMutableArray *dataArray;
    NSMutableArray *contentArray;
    NSMutableArray *stepArray;
    AFLoadIngView *afLoading;
}
@end

@implementation CustomerFollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    dataArray = [[NSMutableArray alloc]init];
    contentArray = [[NSMutableArray alloc]init];
    stepArray = [[NSMutableArray alloc]init];
    [followUpTable reloadData];
    [self getFollowUPData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"跟进信息"];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加跟进" style:UIBarButtonItemStylePlain target:self action:@selector(addFollowUp)];    //把导航栏集合添加入导航栏中，设置动画关闭
    rightButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addFollowUp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AddFollowUpViewController *addFollowUpVC = [[AddFollowUpViewController alloc]init];
        addFollowUpVC.name = self.name;
        addFollowUpVC.phone = self.phone;
        addFollowUpVC.address = self.address;
        addFollowUpVC.serviceId = self.serviceId;
        addFollowUpVC.serviceNo = self.serviceNO;
        [self presentViewController:addFollowUpVC animated:YES completion:nil];
    });
    
}
-(void)initUI
{
//    UIView * infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
//    infoView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:infoView];
    // 姓名，电话，地址，时间
    
//    [NSAlertView initLabelView:infoView frame:CGRectMake(SPACE, SPACE, self.view.bounds.size.width-2*SPACE, 20) text:self.name font:16.0f alignment:NSTextAlignmentLeft isNumLine:NO textColor:[UIColor blackColor]];
//    
//    [NSAlertView initLabelView:infoView frame:CGRectMake(SPACE, 2*SPACE+20, 200, 20) text:self.phone font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO textColor:[UIColor grayColor]];
//    [NSAlertView initLabelView:infoView frame:CGRectMake(SPACE, 3*SPACE+40, 200, 20) text:self.address font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO textColor:[UIColor grayColor]];
//    [NSAlertView initLabelView:infoView frame:CGRectMake(self.view.bounds.size.width-160, 3*SPACE+40, 150, 20) text:self.createStr font:13.0f alignment:NSTextAlignmentRight isNumLine:NO textColor:[UIColor grayColor]];
//    
//    [NSAlertView initLabelView:infoView frame:CGRectMake(self.view.frame.size.width-70, SPACE, 60, 20) text:self.customerScheduleString font:14.0f alignment:NSTextAlignmentRight isNumLine:NO textColor:[UIColor redColor]];
//    
//    UILabel *followLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6*SPACE+40, self.view.frame.size.width, 40)];
//    followLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    followLabel.text = @"跟进记录";
//    followLabel.textAlignment = NSTextAlignmentCenter;
//    followLabel.textColor = [UIColor grayColor];
//    [infoView addSubview:followLabel];
//    
    followUpTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300) style:UITableViewStylePlain];
    followUpTable.delegate = self;
    followUpTable.dataSource = self;
    followUpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:followUpTable];
}

-(void)labelSubView:(UIView*)view labelFrame:(CGRect)frame labelText:(NSString*)string alignment:(NSTextAlignment)alignment textFont:(float)textFont color:(UIColor*)color isNumLine:(BOOL)numLine
{
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = string;
    lab.textAlignment = alignment;
    lab.font = [UIFont systemFontOfSize:textFont];
    lab.textColor = color;
    if (numLine) {
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 3;
        [lab sizeToFit];
    }
    
    [view addSubview:lab];
}
#pragma mark table delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    for(UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    [self labelSubView:cell.contentView labelFrame:CGRectMake(20, (100-20)/2, 40, 20) labelText:[dataArray objectAtIndex:indexPath.row] alignment:NSTextAlignmentCenter textFont:13.0f color:[UIColor blackColor] isNumLine:NO];
    [self labelSubView:cell.contentView labelFrame:CGRectMake(90, 10, 200, 20) labelText:[stepArray objectAtIndex:indexPath.row] alignment:NSTextAlignmentLeft textFont:13.0f color:[UIColor blackColor] isNumLine:NO];
    [self labelSubView:cell.contentView labelFrame:CGRectMake(90, (100-20)/2, self.view.frame.size.width-100, 20) labelText:[contentArray objectAtIndex:indexPath.row] alignment:NSTextAlignmentLeft textFont:13.0f color:[UIColor blackColor] isNumLine:YES];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(90, 95, self.view.frame.size.width-100, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImageView *followIV = [[UIImageView alloc]initWithFrame:CGRectMake(75, 0, 1, 100)];
    followIV.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:followIV];
    [cell.contentView addSubview:lineView];
    
    UIView * vie = [[UIView alloc]initWithFrame:CGRectMake(followIV.frame.origin.x-12/2, (100-10)/2, 12, 12)];
    vie.backgroundColor = [UIColor grayColor];
    vie.layer.cornerRadius = vie.frame.size.width/2;
    [cell.contentView addSubview:vie];

    return cell;
}

#pragma mark 获取跟进列表
/*
 {
 BuyKeyPoints = "";
 CreateTime = "2015-12-27 10:44:26";
 CustomerSchedule = "\U5df2\U62a5\U5907";
 FollowContext = 1233;
 FollowTime = "2015-12-27 10:44:26";
 FollowUpId = 00000322;
 FollowUpType = 1;
 FollowUpUser = "\U6b27\U6d3e\U7ba1\U7406\U5458";
 KeyPoints = "";
 NextFollowTime = "2015-12-30 00:00:00";
 ServiceId = 00001018;
 ServiceNo = 20151225000013;
 }

 */
-(void)getFollowUPData
{
    [afLoading removeFromSuperview];
    afLoading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afLoading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *linkUpInfo = @{@"authCode":code,@"ServiceId":self.serviceId,@"CustomerId":self.customerId};

    [HttpRequset post:linkUpInfo method:@"FollowUp/GetFollowUpList" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
       NSDictionary  *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
        NSArray *followUpInfoList = [JSON objectForKey:@"ReList"];
        for (id list in followUpInfoList) {
            
            id Content = [list objectForKey:@"FollowContext"];
            NSString * FollowUpTime;
            NSString * time = list[@"CreateTime"];
            if ([time isEqual:[NSNull null]]) {
                FollowUpTime = @"";
            }else{
                FollowUpTime = [time substringWithRange:NSMakeRange(5, 5)];
            }
            
            id FollowUpStep = [list objectForKey:@"KeyPoints"];
            
            [contentArray addObject:[NSString stringWithFormat:@"沟通内容：%@",Content]];
            [dataArray addObject:[NSString stringWithFormat:@"%@",FollowUpTime]];
            [stepArray addObject:[NSString stringWithFormat:@"关键点：%@",FollowUpStep]];
            
        }
        [afLoading removeFromSuperview];
        [followUpTable reloadData];

    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

@end

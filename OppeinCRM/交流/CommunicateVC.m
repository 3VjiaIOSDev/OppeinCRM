//
//  CommunicateVC.m
//  Crm
//
//  Created by svj on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//
#define SPACE 10
#import "CommunicateVC.h"
#import "NSAlertView.h"
#import "AddCommunicateVC.h"
#import "CommunicateTableViewCell.h"

@interface CommunicateVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataArray;
    NSMutableArray * cellArray;
    UITableView * table;
    UITextField * replyContent;
    NSString * parentId;
    NSMutableArray * parentArray;
    NSMutableArray * childArray;
}
@end

@implementation CommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

//    [self analyseRequestData];
    [self initNavigation];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dataArray = [NSMutableArray arrayWithCapacity:0];
    cellArray = [NSMutableArray arrayWithCapacity:0];
    parentArray = [NSMutableArray arrayWithCapacity:0];
    childArray = [NSMutableArray arrayWithCapacity:0];
    [self analyseRequestData];
}
- (void)initUI
{
//    UIView * infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200)];
//    infoView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:infoView];
//    // 姓名，电话，地址，时间
//    
//    [NSAlertView initLabelView:infoView frame:CGRectMake(SPACE, SPACE, self.view.bounds.size.width-2*SPACE, 20) text:self.name font:16.0f alignment:NSTextAlignmentLeft isNumLine:NO textColor:[UIColor blackColor]];
//    
//    [NSAlertView initLabelView:infoView frame:CGRectMake(SPACE, 2*SPACE+20, 200, 20) text:self.phone font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO textColor:[UIColor grayColor]];
//    [NSAlertView initLabelView:infoView frame:CGRectMake(SPACE, 3*SPACE+40, 200, 20) text:self.address font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO textColor:[UIColor grayColor]];
//    [NSAlertView initLabelView:infoView frame:CGRectMake(self.view.bounds.size.width-160, 3*SPACE+40, 150, 20) text:self.createStr font:13.0f alignment:NSTextAlignmentRight isNumLine:NO textColor:[UIColor grayColor]];
//    
//    [NSAlertView initLabelView:infoView frame:CGRectMake(self.view.frame.size.width-70, SPACE, 60, 20) text:self.customerScheduleString font:14.0f alignment:NSTextAlignmentRight isNumLine:NO textColor:[UIColor redColor]];
//    
//    infoView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 3*SPACE+60);
//    
//    //交流信息
//    
//    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame)+10, self.view.frame.size.width, 40)];
//    baseView.backgroundColor =[UIColor groupTableViewBackgroundColor];
//    [self.view addSubview:baseView];
//    
//    UILabel * baseLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, 0, self.view.frame.size.width-2*SPACE, 40)];
//    baseLab.text = @"交流信息";
//    baseLab.backgroundColor = [UIColor clearColor];
//    baseLab.textAlignment = NSTextAlignmentCenter;
//    baseLab.textColor = [UIColor grayColor];
//    [baseView addSubview:baseLab];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}


#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    CommunicateTableViewCell * cell = (CommunicateTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell = [[CommunicateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.communicateObj = [dataArray objectAtIndex:indexPath.row];
    [cell.replyBtn addTarget:self action:@selector(replyView:) forControlEvents:UIControlEventTouchUpInside];
    cell.replyBtn.tag = 100+indexPath.row;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunicateTableViewCell * cell = cellArray[indexPath.row];
    cell.communicateObj = dataArray[indexPath.row];
    return cell.cellHeight;
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
    [navigationItem setTitle:@"客户交流"];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加交流" style:UIBarButtonItemStylePlain target:self action:@selector(addFollowUp)];    //把导航栏集合添加入导航栏中，设置动画关闭
    rightButton.tintColor = [UIColor blackColor];
    [rightButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}
- (void)replyView:(UIButton *)sender
{
    communicateModel * model = [dataArray objectAtIndex:sender.tag-100];
    parentId = model.ACId;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"回复内容" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = 999;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField * txt = [[UITextField alloc] init];
    txt.backgroundColor = [UIColor whiteColor];
    txt.keyboardType = UIKeyboardTypePhonePad;
    txt.frame = CGRectMake(alert.center.x+65,alert.center.y, 150,23);
    [alert addSubview:txt];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        replyContent = [alertView textFieldAtIndex:0];
        [self replyRequestData];
    }
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addFollowUp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AddCommunicateVC * addCom = [[AddCommunicateVC alloc]init];
        addCom.serviceId = self.serviceId;
        [self presentViewController:addCom animated:YES completion:nil];
    });
    
}

-(void)replyRequestData
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *linkUpInfo = @{@"ServiceId":self.serviceId,@"ParentId":parentId,@"Content":replyContent.text};
    NSData *linkUpInfoData = [NSJSONSerialization dataWithJSONObject:linkUpInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *dict = @{@"authCode":code,@"LinkUpInfo":[[NSString alloc]initWithData:linkUpInfoData encoding:NSUTF8StringEncoding]};
    [HttpRequset post:dict method:@"LinkUpInfo/AddLinkUpInfo" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        NSString *ErrorMessage = [dic objectForKey:@"ErrorMessage"];
        if ([ErrorMessage isEqualToString:@""]) {
            [dataArray removeAllObjects];
            [cellArray removeAllObjects];
            [self analyseRequestData];
        }else{
            [NSAlertView alert:ErrorMessage];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
-(void)analyseRequestData
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *linkUpInfo = @{@"ServiceId":self.serviceId,@"PageIndex":@"1",@"PageSize":@"100"};
    NSData *linkUpInfoData = [NSJSONSerialization dataWithJSONObject:linkUpInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *dict = @{@"authCode":code,@"LinkUpInfoCondition":[[NSString alloc]initWithData:linkUpInfoData encoding:NSUTF8StringEncoding]};
    [HttpRequset post:dict method:@"LinkUpInfo/GetLinkUpInfoList" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        NSString *ErrorMessage = [dic objectForKey:@"ErrorMessage"];
        
        if ([ErrorMessage isEqualToString:@""]) {
            NSDictionary * dictionary = [dic[@"JSON"]objectFromJSONString];
            NSMutableArray * array =  [self anwserDicWithArray:dictionary[@"rows"]];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [dataArray addObject:[communicateModel communicateWithDictionary:obj]];
                CommunicateTableViewCell * cell = [[CommunicateTableViewCell alloc]init];
                [cellArray addObject:cell];
            }];
            [table reloadData];
            
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

-(NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO)
            {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}

-(NSMutableArray *)anwserDicWithArray:(NSArray*)linkUpInfoList
{
    NSMutableArray *anwserCountArray =[[NSMutableArray alloc]init];
    
    NSMutableArray *acidArray = [[NSMutableArray alloc]init];
    NSMutableArray *parentIdArray = [[NSMutableArray alloc]init];
    NSMutableArray *parentIdArray1 = [[NSMutableArray alloc]init];
    NSMutableArray *ContentArray = [[NSMutableArray alloc]init];
    NSMutableArray *anwerArray = [[NSMutableArray alloc]init];
    NSMutableArray *timeArray = [[NSMutableArray alloc]init];
    NSMutableArray *userNameArray = [[NSMutableArray alloc]init];
    
    for (id list in linkUpInfoList) {
        NSString *ACId = [list objectForKey:@"ACId"];
        NSString *ParentId = [list objectForKey:@"ParentId"];
        NSString *Content = [list objectForKey:@"Content"];
        NSString *CreateTime = [list objectForKey:@"CreateTime"];
        NSString *userName = [list objectForKey:@"UserName"];
        
        if ([ParentId isEqualToString:@""]||[ParentId isEqualToString:@"0"]) {
            [acidArray addObject:ACId];
            [ContentArray addObject:Content];
            [timeArray addObject:CreateTime];
            [parentIdArray1 addObject:ParentId];
            [userNameArray addObject:userName];
        }
        else{
            [parentIdArray addObject:ParentId];
            [anwerArray addObject:Content];
            
        }
    }
    
    for (int i = 0; i < acidArray.count; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSMutableDictionary *anDic = [[NSMutableDictionary alloc]init];
        [anDic setValue:[acidArray objectAtIndex:i] forKey:@"ACID"];
        [anDic setValue:[ContentArray objectAtIndex:i] forKey:@"Content"];
        [anDic setValue:[timeArray objectAtIndex:i] forKey:@"CreateTime"];
        [anDic setValue:[parentIdArray1 objectAtIndex:i] forKey:@"ParentId"];
        [anDic setValue:[userNameArray objectAtIndex:i] forKey:@"UserName"];
        for (int j = 0; j < parentIdArray.count; j++) {
            if ([[acidArray objectAtIndex:i]isEqualToString:[parentIdArray objectAtIndex:j]]) {
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                [dictionary setValue:[anwerArray objectAtIndex:j] forKey:@"ac"];
                [array addObject:dictionary];
            }
        }
        [anDic setValue:array  forKey:@"anwser"];
        [anwserCountArray addObject:anDic];
    }
    
    return anwserCountArray;
}

@end

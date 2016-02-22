//
//  NewSCViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/13.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "NewSCViewController.h"
#import "TimePicker.h"
#import "keyPoint.h"
#import "QRadioButton.h"

@interface NewSCViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,TimePickerDelegate,keyPointDelegate,QRadioButtonDelegate>
{
    AFLoadIngView *afloading;
    UITableView *table;
    NSArray *dataArr;
    
    UITextView *communionTextView;
    UILabel *placeholderLab;
    
     TimePicker *timerPicker;
    keyPoint *keyView;
    
    NSString *creatTime;
    NSString *nextTime;
    NSString *keyPointStr;
    NSString *keyPointCode;
    
    NSArray *keyPointArray;
    NSString *isAwoke;
}
@end

@implementation NewSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigation];
    isAwoke = @"false";
    dataArr = @[@"沟通时间",@"下次沟通时间",@"是否触发智能提醒",@"沟通内容",@"关键点"];
    table  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    
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
    navigationItem.title = @"添加方案交流";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(saveSC)];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 120;
    }
    else
        return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ((indexPath.row == 0)||(indexPath.row == 1)) {
            cell.imageView.image = [UIImage imageNamed:@"xinghao"];
        }
        if (indexPath.row == 3)
        {
            cell.textLabel.text = @"";
            UILabel *communionLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 20)];
            communionLab.text = @"沟通内容";
            communionLab.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:communionLab];
            
            communionTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(communionLab.frame), 5, self.view.frame.size.width-communionLab.frame.size.width-20, 110)];
            communionTextView.layer.borderWidth = 1.0f;
            communionTextView.delegate = self;
            communionTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            [cell.contentView addSubview:communionTextView];
            
            placeholderLab = [[UILabel alloc]init];
            placeholderLab.frame =CGRectMake(CGRectGetMaxX(communionLab.frame)+3, 10, 150, 20);
            placeholderLab.text = @"请输入方案沟通内容";
            placeholderLab.font = [UIFont systemFontOfSize:14.0f];
            placeholderLab.enabled = NO;//lable必须设置为不可用
            placeholderLab.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:placeholderLab];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.row];
    if (indexPath.row != 3) {
        cell.detailTextLabel.text = @"点击选择";
        if ((indexPath.row == 0)&&creatTime) {
            cell.detailTextLabel.text = creatTime;
        }
        if ((indexPath.row == 1)&&nextTime) {
            cell.detailTextLabel.text = nextTime;
        }
        if (indexPath.row == 2)
        {
            for (QRadioButton *radio in [cell.contentView subviews]) {
                [radio removeFromSuperview];
            }
            cell.detailTextLabel.text = @"";
            for (int i = 0; i < 2; i++) {
                QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                radio.frame =CGRectMake(self.view.frame.size.width-60*(i+1), 5, 50, 30);
                [radio setTitle:i == 0 ?@"否":@"是" forState:UIControlStateNormal];
                [radio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [radio.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [cell.contentView addSubview:radio];
                if (i == 0) {
                    [radio setChecked:YES];
                }
            }
            
        }
        if ((indexPath.row == 4)&&(keyPointStr.length>0)) {
            cell.detailTextLabel.text = keyPointStr;
        }
    }
    else
    {
        cell.textLabel.text = @"";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timerPicker dissPicker];
    [keyView dismiss];
    [communionTextView resignFirstResponder];
    switch (indexPath.row) {
        case 0:
        {
            timerPicker = [[TimePicker alloc]initWithDataArray];
            timerPicker.delegate = self;
            [timerPicker show];
            timerPicker.tag = 1000;
            [self.view addSubview:timerPicker];
        }
            break;
        case 1:
        {
            timerPicker = [[TimePicker alloc]initWithDataArray];
            timerPicker.delegate = self;
            [timerPicker show];
            timerPicker.tag = 1001;
            [self.view addSubview:timerPicker];
        }
            break;
        case 4:
        {
            if (!keyPointArray) {
                [self GetSchemeFollowUpKeyPoints];
                return;
            }
            NSArray *arr = [keyPointStr componentsSeparatedByString:@" "];
            NSArray *arr1 = [keyPointCode componentsSeparatedByString:@" "];
            keyView = [[keyPoint alloc]initWithArray:keyPointArray selectArr:arr codeArr:arr1];
            keyView.delegate =self;
            [self.view addSubview:keyView];
            [keyView show];
        }
            break;
        default:
            break;
    }
}


/*
 获取关键节点
 */
-(void)GetSchemeFollowUpKeyPoints
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    [HttpRequset post:dict method:@"scheme/GetSchemeFollowUpKeyPoints" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            keyPointArray = [dic[@"JSON"]objectFromJSONString];
            NSArray *arr = [keyPointStr componentsSeparatedByString:@" "];
            NSArray *arr1 = [keyPointCode componentsSeparatedByString:@" "];
            keyView = [[keyPoint alloc]initWithArray:keyPointArray selectArr:arr codeArr:arr1];
            keyView.delegate =self;
            [self.view addSubview:keyView];
            [keyView show];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

/*
 保存沟通方案信息
 */
-(void)saveSC
{
    
    if (!creatTime) {
        [SVProgressHUD showErrorWithStatus:@"请选择沟通时间"];
        return;
    }
    if (!nextTime) {
        [SVProgressHUD showErrorWithStatus:@"请选择下次沟通时间"];
        return;
    }
    NSString *communionStr = communionTextView.text;
    if (communionStr.length<=0) {
        communionStr = @"";
    }
    
    if (keyPointCode.length<=0) {
        keyPointCode = @"";
    }
    
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,
                           @"ServiceId":self.serviceId,
                           @"ServiceNo":self.serviceNo,
                           @"BeginFollowTime":creatTime,
                           @"NextFollowTime":nextTime,
                           @"FollowContext":communionStr,
                           @"KeyPoints":keyPointCode,
                           @"IsTrigger":isAwoke};
    [HttpRequset post:dict method:@"scheme/SaveSchemeFollowUp" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            [self back];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];

}

#pragma mark TextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//textView提示文字

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        placeholderLab.text = @"请输入方案沟通内容";
    }else{
        placeholderLab.text = @"";
    }
}

#pragma mark TimeDelegate
-(void)clickTimeWith:(TimePicker*)timePicker timer:(NSString*)timer
{
    if (timePicker.tag == 1000) {
        creatTime = timer;
    }
    else if (timePicker.tag == 1001)
    {
        nextTime = timer;
    }
    [table reloadData];
}

-(void)keyPointView:(keyPoint *)keyView keyArr:(NSMutableArray *)keyArray keyCode:(NSMutableArray *)codeArray
{
    keyPointStr = [keyArray componentsJoinedByString:@" "];
    keyPointCode = [codeArray componentsJoinedByString:@" "];
    [table reloadData];
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"是"]) {
        isAwoke = @"true";
    }
    else
    {
        isAwoke = @"false";
    }
}
@end

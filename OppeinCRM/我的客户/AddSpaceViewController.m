//
//  AddSpaceViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/27.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "AddSpaceViewController.h"
#import "QRadioButton.h"
#import "NSAlertView.h"
#import "QCheckBox.h"
#import "NSAlertView.h"
#import "AFLoadIngView.h"
#import "TimePicker.h"


@interface AddSpaceViewController ()<UITableViewDataSource,UITableViewDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,
QRadioButtonDelegate,QCheckBoxDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TimePickerDelegate>
{
    TimePicker *timerPicker;
    AFLoadIngView *afloading;
    int typeOfTime;//判断是测量时间还是结束时间
    BOOL isReflash;
    NSString *measure;//量尺时间
    NSString *finish;//结束时间
    NSString *upDatasSring;
    NSString *MeasureId;
    
    //图片查看器
    UIScrollView *scrView;
    NSMutableArray *_images;//图片数组
    
    int MeasureType;//量尺类型
    NSString *modelType;
    NSString *uptadaData;
    NSString *SpaceId;
    
    //addingSpaceTable
    UITableView *addingSpaceTable;//新增空间table
    
    UITableView *spaceModelTable;//空间模型table
    
    
    NSMutableArray *spaceModelAllData;//新增空间模型所有数据
    NSMutableArray *spaceModelAllDataCount;//新增空间模型每个列表的数据总数
    
    NSMutableArray *spaceModelFormats;//新增空间模型所有类型数据
    NSMutableArray *spaceModelFormat;//新增空间模型列表类型数据
    
    NSMutableArray *spaceModelDatas;//需要上传的空间模型table所有数据
    NSMutableArray *spaceModelData;//需要上传的空间模型table当前数据
    
    NSMutableArray *spaceModelIDs;//新增模型中的所有ID数据
    NSMutableArray *spaceModelID;//空间模型table中的id数据
    
    NSMutableDictionary *modelDic;//记录空间类型与modelId对应的字典
    
    NSMutableArray *modelUpdataAry;
    
    UIView *spaceView;
    
    UIView *spaceRadioView;
    
    NSMutableArray *spaceMutableAry;
    NSInteger spaceIndex;
    UIBarButtonItem *rightButton;
}
@property NSArray *addSpaceAry1;
@property NSArray *addSpaceAry2;
@property NSMutableArray *spaceModel;
@property UIPickerView *picker;
@property UIView *dateView;

@property UILabel *measureLab;//测量时间
@property UILabel *finishLab;//完成时间
@property UILabel *spaceLab;
@property UILabel *styleLab;
@property UILabel *areaLab;
@property UILabel *materialLab;
@property UILabel *layoutLab;
@property UILabel *procutLab;
@property UILabel *houseLab;
@property UILabel *budgetLab;
@end

@implementation AddSpaceViewController



- (void)viewDidLoad {
    _images = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addingSpaceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:UITableViewStyleGrouped];
    addingSpaceTable.delegate = self;
    addingSpaceTable.dataSource = self;
    [self.view addSubview:addingSpaceTable];
    
    
    [self initNavigation];
    
    self.addSpaceAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间", nil];
    self.addSpaceAry2 = [[NSArray alloc]initWithObjects:@"空间",@"户型",@"预算",@"风格",@"面积(m2)",@"材料",@"布局",@"预购产品线", nil];
    
    
    spaceMutableAry = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 导航条操作

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"新增空间"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    rightButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [self.view addSubview:navigationBar];
}

#pragma mark 返回上一层

-(void)back
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃添加" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 2001;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2001) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            self.budgetLab.text = tf.text;
        }
    }
}
#pragma mark 保存数据

-(void)save:(UIButton*)sender
{
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:nil];
    if ((spaceMutableAry.count<=0)||(finish.length<=0)
        ||(self.spaceLab.text.length <= 0)||(measure.length<=0)
        ||(self.areaLab.text.length<=0)||(self.styleLab.text.length<=0)
        ||(self.materialLab.text.length<=0)||(self.layoutLab.text.length<=0)) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您提交的信息不完整，请完善后再上传空间信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(save) object:sender];
    
    [self performSelector:@selector(save) withObject:sender afterDelay:0.5f];
}
-(void)save
{
    
    
    NSString *string = @"";
    for (int i = 0; i < spaceMutableAry.count; i++) {
        string = [NSString stringWithFormat:@"%@%@,",string,[spaceMutableAry objectAtIndex:i]];
    }
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSString *str = [NSString stringWithFormat:@"Params={\"authCode\": \"%@\",\"MeasureInfo\":{\"MeasureType\":%d,\"ContrlContentList\":{%@},\"RoomType\":\"%@\",\"FinishTime\":\"%@\",\"SpaceName\":\"%@\",\"MeasureTime\": \"%@\",\"BuyWill\": \"%@\",\"Area\": \"%@\",\"Style\":\"%@\",\"ServiceId\":\"%@\",\"UserId\": \"%@\",\"SpaceId\":\"%@\",\"Budget\":%d,\"Material\":\"%@\",\"Layout\":\"%@\"}}&Command=MeasureSpace/AddMeasureInfo",code,MeasureType,string,self.houseLab.text,finish,self.spaceLab.text,measure,self.procutLab.text,self.areaLab.text,self.styleLab.text,self.ServiceId,self.UserId,SpaceId,self.budgetLab.text.intValue,self.materialLab.text,self.layoutLab.text];
    str = [str stringByReplacingOccurrencesOfString:@"{," withString:@"{"];
    uptadaData = str;
    
    [self analyseUpdataCustomer];//updataCustomer
}
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
-(void)sureSpaceInfo1:(id)sender
{
    [spaceView removeFromSuperview];
    spaceModelTable.delegate = nil;
    spaceModelTable.dataSource = nil;
}
-(void)sureSpaceInfo:(id)sender
{
    upDatasSring = @"";
    for (int i = 0; i < spaceModelFormat.count; i++) {
        if ([[spaceModelDatas objectAtIndex:i]isEqualToString:@"text;"]) {
            if ([upDatasSring isEqualToString:@""]) {
                upDatasSring = [NSString stringWithFormat:@"\"txt_%@\":\"%@\"",[spaceModelID objectAtIndex:i],[spaceModelData objectAtIndex:i]];
            }
            else
            {
                upDatasSring = [NSString stringWithFormat:@"%@,\"txt_%@\":\"%@\"",upDatasSring,[spaceModelID objectAtIndex:i],[spaceModelData objectAtIndex:i]];
                
            }
        }
        else
        {
            if ([upDatasSring isEqualToString:@""]) {
                upDatasSring = [NSString stringWithFormat:@"\"rdo_%@\":\"%@\"",[spaceModelID objectAtIndex:i],[spaceModelData objectAtIndex:i]];
            }
            else
            {
                upDatasSring = [NSString stringWithFormat:@"%@,\"rdo_%@\":\"%@\"",upDatasSring,[spaceModelID objectAtIndex:i],[spaceModelData objectAtIndex:i]];
                
            }
        }
    }
    [spaceMutableAry replaceObjectAtIndex:spaceIndex withObject:upDatasSring];
    
    [spaceView removeFromSuperview];
    spaceModelTable.delegate = nil;
    spaceModelTable.dataSource = nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [spaceModelData replaceObjectAtIndex:textField.tag withObject:textField.text];
    
    if (spaceIndex == 0) {
        [modelUpdataAry replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    else
    {
        int count=0;
        for (int i = 0; i < spaceIndex; i++) {
            NSString *countStr = [spaceModelAllDataCount objectAtIndex:i];
            count += countStr.intValue;
        }
        [modelUpdataAry replaceObjectAtIndex:textField.tag+count withObject:textField.text];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if([groupId isEqualToString:@"CustomName"])
    {
        if ([modelType isEqualToString:radio.titleLabel.text])
        {
            isReflash = NO;
        }
        else
            isReflash = YES;
        modelType = radio.titleLabel.text;
        self.spaceLab.text = modelType;
        return;
    }
    //@"Style"
    else if ([groupId isEqualToString:@"Style"])
    {
        self.styleLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"HouseType"])
    {
        self.houseLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"array"])
    {
        self.areaLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"Materials"])
    {
        self.materialLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"Layouts"])
    {
        self.layoutLab.text = radio.titleLabel.text;
        return;
    }
    else if (radio.tag == 1001) {
        if ([radio.titleLabel.text isEqualToString:@"初尺"]) {
            MeasureType = 1;
        }
        else
        {
            MeasureType = 2;
        }
        return;
    }
    
    else if (radio.tag == 1002) {
        
        return;
    }
    
    [spaceModelData replaceObjectAtIndex:radio.tag withObject:radio.titleLabel.text];
    
    if (spaceIndex == 0) {
        [modelUpdataAry replaceObjectAtIndex:radio.tag withObject:radio.titleLabel.text];
    }
    else
    {
        int count=0;
        for (int i = 0; i < spaceIndex; i++) {
            NSString *countStr = [spaceModelAllDataCount objectAtIndex:i];
            count += countStr.intValue;
        }
        [modelUpdataAry replaceObjectAtIndex:radio.tag+count withObject:radio.titleLabel.text];
    }
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checkbox.tag == 2000) {
        if (self.procutLab.text==nil) {
            self.procutLab.text = @"";
        }
        NSString *str = self.procutLab.text;
        if (checked) {
            if (![str isEqualToString:@""]) {
                str = [NSString stringWithFormat:@"%@;%@",str,checkbox.titleLabel.text];
            }
            else
                str = [NSString stringWithFormat:@"%@",checkbox.titleLabel.text];
        }
        else
        {
            str = [str stringByReplacingOccurrencesOfString:checkbox.titleLabel.text withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@";;" withString:@""];
            if (str.length>=1) {
                if ([[str substringToIndex:1]isEqualToString:@";"]) {
                    str = [str substringFromIndex:1];
                }
            }
        }
        self.procutLab.text = str;
        return;
    }
    else
    {
        if(checked == YES)
        {
            NSString *str = [spaceModelData objectAtIndex:checkbox.tag];
            if ([str isEqualToString:@""]) {
                str = [NSString stringWithFormat:@"%@",checkbox.titleLabel.text];
            }
            else{
                str = [NSString stringWithFormat:@"%@;%@",str,checkbox.titleLabel.text];
            }
            [spaceModelData replaceObjectAtIndex:checkbox.tag withObject:str];
            if (spaceIndex == 0) {
                [modelUpdataAry replaceObjectAtIndex:checkbox.tag withObject:str];
            }
            else
            {
                int count=0;
                for (int i = 0; i < spaceIndex; i++) {
                    NSString *countStr = [spaceModelAllDataCount objectAtIndex:i];
                    count += countStr.intValue;
                }
                [modelUpdataAry replaceObjectAtIndex:checkbox.tag+count withObject:str];
            }
        }
        else
        {
            NSString *str = [spaceModelData objectAtIndex:checkbox.tag];
            str = [str stringByReplacingOccurrencesOfString:checkbox.titleLabel.text withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@";;" withString:@";"];
            if ((str.length > 0)&&[[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@";"]) {
                str = [str substringFromIndex:1];
            }
            if ((str.length > 0)&&[[str substringWithRange:NSMakeRange(str.length-1, 1)] isEqualToString:@";"]) {
                str = [str substringToIndex:str.length-1];
            }
            [spaceModelData replaceObjectAtIndex:checkbox.tag withObject:str];
            
            if (spaceIndex == 0) {
                [modelUpdataAry replaceObjectAtIndex:checkbox.tag withObject:str];
            }
            else
            {
                int count=0;
                for (int i = 0; i < spaceIndex; i++) {
                    NSString *countStr = [spaceModelAllDataCount objectAtIndex:i];
                    count += countStr.intValue;
                }
                [modelUpdataAry replaceObjectAtIndex:checkbox.tag+count withObject:str];
            }
        }
    }
}

-(void)radioView:(NSArray *)radioAry groupID:(NSString*)groupID title:(NSString*)title select:(NSString*)select
{
    [spaceRadioView removeFromSuperview];
    spaceRadioView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    spaceRadioView.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceRadioView];
    
    UIScrollView *radioView;
    
    
    radioView = [[UIScrollView alloc]initWithFrame:CGRectMake(45, (spaceRadioView.frame.size.height-(radioAry.count+2)*15)/2, spaceRadioView.frame.size.width-90, (radioAry.count+5)*15)];
    
    radioView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    
    
    radioView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [spaceRadioView addSubview:radioView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:radioView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = radioView.bounds;
    maskLayer.path = maskPath.CGPath;
    radioView.layer.mask = maskLayer;
    
    float fristH = 1/2*(spaceRadioView.frame.size.height)-1/2*(radioAry.count)*30+25;
    
    for (int i = 0; i < radioAry.count; i++) {
        int row = i/2;
        int col = i%2;
        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:groupID];
        _radio1.frame =CGRectMake(100*col+15, fristH+30*row, 100, 30);
        _radio1.tag = 1002;
        [_radio1 setTitle:[radioAry objectAtIndex:i] forState:UIControlStateNormal];
        [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_radio1.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [radioView addSubview:_radio1];
        if ([select isEqualToString:_radio1.titleLabel.text]) {
            _radio1.checked = YES;
        }
    }
    float buttonH = fristH+15*(radioAry.count)-10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, buttonH+25, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(radioViewCancel1:) forControlEvents:UIControlEventTouchUpInside];
    [radioView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(radioView.frame.size.width-80, buttonH+25, 60, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [radioView addSubview:button1];
    
}

-(void)checkView:(NSArray *)checkAry tag:(int)tag
{
    [spaceRadioView removeFromSuperview];
    NSArray *array = [self StringToArray:self.procutLab.text];
    spaceRadioView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    spaceRadioView.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceRadioView];
    
    UIView *checkView = [[UIView alloc]initWithFrame:CGRectMake(45, (spaceRadioView.frame.size.height-(checkAry.count+2)*30)/2, spaceRadioView.frame.size.width-90, (checkAry.count+2)*30)];
    
    checkView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [spaceRadioView addSubview:checkView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:checkView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = checkView.bounds;
    maskLayer.path = maskPath.CGPath;
    checkView.layer.mask = maskLayer;
    
    float fristH = 1/2*(spaceRadioView.frame.size.height)-1/2*(checkAry.count)*30+25;
    
    for (int i = 0; i < checkAry.count; i++) {
        
        QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
        _check1.tag = tag;
        _check1.frame = CGRectMake(35, fristH+30*i, 200, 30);
        [_check1 setTitle:[checkAry objectAtIndex:i] forState:UIControlStateNormal];
        [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_check1.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [checkView addSubview:_check1];
        
        for (int i = 0; i < array.count; i++) {
            if ([_check1.titleLabel.text isEqualToString:[array objectAtIndex:i]]) {
                _check1.selected = YES;
            }
        }
    }
    float buttonH = fristH+30*(checkAry.count)-10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, buttonH+10, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(radioViewCancel1:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(checkView.frame.size.width-80, buttonH+10, 60, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:button1];
}

-(void)radioViewCancel1:(id)sender
{
    [spaceRadioView removeFromSuperview];
}
-(void)radioViewCancel:(id)sender
{
    if (isReflash == NO) {
        [spaceRadioView removeFromSuperview];
        return;
    }
    NSInteger count = [modelDic allKeys].count;
    id key;
    id value;
    self.spaceLab.text = modelType;
    for (int i = 0; i < count; i++) {
        key = [[modelDic allKeys]objectAtIndex:i];
        if ([key isEqualToString:modelType]) {
            value = [modelDic objectForKey:key];
            SpaceId = value;
            [self analyseModelData:value];
        }
    }
    [spaceRadioView removeFromSuperview];
    isReflash = NO;
}
#pragma mark 空间模板绘制

-(void)drawModel:(NSInteger)row
{
    spaceView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                        65,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height-65)];
    
    spaceView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceView];
    
    spaceModelFormat = [[NSMutableArray alloc]init];
    spaceModelDatas = [[NSMutableArray alloc]init];
    spaceModelID = [[NSMutableArray alloc]init];
    
    int count = 0;
    int index = 0;
    
    for (int i = 0; i <= row-1; i++) {
        NSString *countStr= [spaceModelAllDataCount objectAtIndex:i];
        index = count;
        count += countStr.intValue;
    }
    
    for (int i = index; i <  count; i++) {
        [spaceModelFormat addObject:[spaceModelFormats objectAtIndex:i]];
        [spaceModelDatas addObject:[spaceModelAllData objectAtIndex:i]];
        [spaceModelID addObject:[spaceModelIDs objectAtIndex:i]];
    }
    
    if (spaceMutableAry.count <= 0) {
        for (int i = 0; i <  self.spaceModel.count; i++) {
            [spaceMutableAry addObject:@""];
        }
    }
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(20,
                                                        (self.view.frame.size.height-65-40*(spaceModelDatas.count+1))/2,
                                                        spaceView.frame.size.width-40,
                                                        40*(spaceModelDatas.count+1))];
    [spaceView addSubview:v];
    
    spaceModelTable = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   v.frame.size.width,
                                                                   v.frame.size.height)];
    spaceModelTable.delegate = self;
    spaceModelTable.dataSource = self;
    spaceModelTable.scrollEnabled = NO;
    spaceModelTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    spaceModelTable.backgroundColor = [UIColor clearColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:v.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = v.bounds;
    maskLayer.path = maskPath.CGPath;
    v.layer.mask = maskLayer;
    
    [self setExtraCellLineHidden:spaceModelTable];
    [v addSubview:spaceModelTable];
}
#pragma mark tableViewDeledate

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addingSpaceTable) {
        if ((indexPath.section == 2)&&(indexPath.row == 0)) {
            return 100;
        }
        else if(indexPath.section == 3)
        {
            return 60;
        }
        else
            return 40;
    }
    else if (tableView == spaceModelTable)
    {
        return 40;
    }
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == addingSpaceTable) {
        return 3;
    }
    else
        return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == addingSpaceTable) {
        if (section == 0) {
            return self.addSpaceAry1.count;
        }
        if (section == 1) {
            return self.addSpaceAry2.count;
        }
        if (section == 2) {
            return self.spaceModel.count+1;
        }
        else
            return 1;
    }
    else
        return spaceModelFormat.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addingSpaceTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            if (indexPath.section == 0) {
                cell.textLabel.text = [self.addSpaceAry1 objectAtIndex:indexPath.row];
                cell.imageView.image = [UIImage imageNamed:@"xinghao"];
                if(indexPath.row == 0)
                {
                    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                    _radio1.frame =CGRectMake(self.view.frame.size.width-60, 5, 50, 30);
                    _radio1.tag = 1001;
                    [_radio1 setTitle:@"复尺" forState:UIControlStateNormal];
                    [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                    [cell.contentView addSubview:_radio1];
                    
                    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                    _radio2.frame = CGRectMake(self.view.frame.size.width-120, 5, 50, 30);
                    _radio2.tag = 1001;
                    [_radio2 setTitle:@"初尺" forState:UIControlStateNormal];
                    [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                    [cell.contentView addSubview:_radio2];
                    NSLog(@"%d",MeasureType);
                    if (MeasureType == 1) {
                        _radio2.checked = YES;
                    }
                    else
                    {
                        _radio1.checked = YES;
                    }
                    
                }
                else if(indexPath.row == 1)
                {
                    self.measureLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                    if (measure == nil) {
                        self.measureLab.text = @"未设置";
                    }
                    else
                    {
                        self.measureLab.text = measure;
                    }
                    self.measureLab.font = [UIFont systemFontOfSize:14.0f];
                    self.measureLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.measureLab];
                }
                else if (indexPath.row == 2)
                {
                    self.finishLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                    if(finish == nil)
                    {
                        self.finishLab.text = @"未设置";
                    }
                    else
                    {
                        self.finishLab.text = finish;
                    }
                    self.finishLab.font = [UIFont systemFontOfSize:14.0f];
                    self.finishLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.finishLab];
                }
            }
            else if (indexPath.section == 1) {
                cell.imageView.image = [UIImage imageNamed:@"xinghao"];
                cell.textLabel.text = [self.addSpaceAry2 objectAtIndex:indexPath.row];
                
                if (indexPath.row == 0) {
                    self.spaceLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.spaceLab.textAlignment = NSTextAlignmentRight;
                    self.spaceLab.font = [UIFont systemFontOfSize:14.0f];
                    self.spaceLab.text = modelType;
                    [cell.contentView addSubview:self.spaceLab];
                }
                else if (indexPath.row == 1)
                {
                    self.houseLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.houseLab.textAlignment = NSTextAlignmentRight;
                    self.houseLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.houseLab];
                }
                else if (indexPath.row ==2)
                {
                    self.budgetLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.budgetLab.textAlignment = NSTextAlignmentRight;
                    self.budgetLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.budgetLab];
                }
                else if (indexPath.row == 3)
                {
                    self.styleLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.styleLab.textAlignment = NSTextAlignmentRight;
                    self.styleLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.styleLab];
                }
                else if (indexPath.row == 4)
                {
                    self.areaLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.areaLab.textAlignment = NSTextAlignmentRight;
                    self.areaLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.areaLab];
                }
                else if (indexPath.row == 5)
                {
                    self.materialLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.materialLab.textAlignment = NSTextAlignmentRight;
                    self.materialLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.materialLab];
                }
                else if (indexPath.row == 6)
                {
                    self.layoutLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.layoutLab.textAlignment = NSTextAlignmentRight;
                    self.layoutLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.layoutLab];
                }
                else if (indexPath.row == 7)
                {
                    self.procutLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.procutLab.textAlignment = NSTextAlignmentRight;
                    self.procutLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.procutLab];
                }
            }
            else if(indexPath.section == 2)
            {
                if (indexPath.row == 0) {
                    [NSAlertView initLabelView:cell.contentView
                                         frame:CGRectMake(15, 5, 60, 15)
                                          text:@"附件"
                                          font:14
                                     alignment:NSTextAlignmentLeft
                                     isNumLine:NO];
                    
                    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 2*self.view.frame.size.width, 80)];
                    
                    [self imageShow:_images inView:scrView];
                    [cell.contentView addSubview:scrView];
                }
                else
                {
                    cell.imageView.image = [UIImage imageNamed:@"xinghao"];
                    cell.textLabel.text = [self.spaceModel objectAtIndex:indexPath.row-1];
                }
            }
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            
            for (int i = 0; i < spaceModelFormat.count; i++) {
                if (i == indexPath.row) {
                    [NSAlertView initLabelView:cell.contentView frame:CGRectMake(15, 5, 100, 30) text:[spaceModelFormat objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
                }
                
                if (indexPath.row == i) {
                    
                    int count = 0;
                    int index = 0;
                    
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    
                    for (int i = 0; i <= spaceIndex; i++) {
                        NSString *countStr= [spaceModelAllDataCount objectAtIndex:i];
                        index = count;
                        count += countStr.intValue;
                    }
                    
                    for (int i = index; i <  count; i++) {
                        [arr addObject:[modelUpdataAry objectAtIndex:i]];
                    }
                    
                    if ([[[spaceModelDatas objectAtIndex:indexPath.row]substringToIndex:4] isEqualToString:@"text"]) {
                        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-210, 7.5, 145, 25)];
                        field.tag = indexPath.row;
                        field.delegate = self;
                        field.font = [UIFont systemFontOfSize:12.0f];
                        field.text = [arr objectAtIndex:indexPath.row];
                        field.borderStyle = UITextBorderStyleRoundedRect;
                        [cell.contentView addSubview:field];
                    }
                    else if ([[[spaceModelDatas objectAtIndex:indexPath.row]substringToIndex:8] isEqualToString:@"checkbox"])
                    {
                        NSString *string = [[spaceModelDatas objectAtIndex:indexPath.row]substringFromIndex:9];
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        NSInteger length = string.length;
                        int j = 0;
                        for (int i = 0; i < length; i++) {
                            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
                            if ([str isEqualToString:@";"]) {
                                [ary addObject:[string substringWithRange:NSMakeRange(j, i-j)]];
                                j = i+1;
                            }
                        }
                        [ary addObject:[string substringFromIndex:j]];
                        NSInteger count = ary.count;
                        
                        if (count >= 5) {
                            count = 4;
                        }
                        for (int i = 0; i < count; i++) {
                            QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
                            _check1.tag = indexPath.row;
                            _check1.frame = CGRectMake(self.view.frame.size.width-80-55*i, 5, 50, 30);
                            [_check1 setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
                            [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                            [cell.contentView addSubview:_check1];
                            NSArray *arrayCheck = [self StringToArray:[arr objectAtIndex:indexPath.row]];
                            for (int i = 0; i < arrayCheck.count; i++) {
                                if ([_check1.titleLabel.text isEqualToString:[arrayCheck objectAtIndex:i]]) {
                                    _check1.selected = YES;
                                }
                            }
                        }
                    }
                    else
                    {
                        NSString *string = [[spaceModelDatas objectAtIndex:indexPath.row]substringFromIndex:6];
                        
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        NSInteger length = string.length;
                        int j = 0;
                        for (int i = 0; i < length; i++) {
                            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
                            if ([str isEqualToString:@";"]) {
                                [ary addObject:[string substringWithRange:NSMakeRange(j, i-j)]];
                                j = i+1;
                            }
                        }
                        
                        [ary addObject:[string substringFromIndex:j]];
                        NSString *group = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                        for (int i = 0; i < ary.count; i++) {
                            
                            QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:group];
                            _radio1.tag = indexPath.row;
                            _radio1.frame =CGRectMake(self.view.frame.size.width-80-65*i, 5, 60, 30);
                            [_radio1 setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
                            [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                            [cell.contentView addSubview:_radio1];
                            if (i == 0) {
                                [_radio1 setChecked:YES];
                            }
                        }
                    }
                }
            }
            if (indexPath.row == spaceModelFormat.count)
            {
                UIButton *button =[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(15, 5, 40, 30);
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(sureSpaceInfo1:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UIButton *button1 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button1.frame = CGRectMake(self.view.frame.size.width-95, 5, 40, 30);
                [button1 setTitle:@"确定" forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(sureSpaceInfo:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button1];
            }
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addingSpaceTable) {
         [timerPicker dissPicker];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
            }
            else  if (indexPath.row == 1) {
                typeOfTime = 1;
                timerPicker = [[TimePicker alloc]initWithDataArray];
                timerPicker.delegate = self;
                [timerPicker show];
                
                [self.view addSubview:timerPicker];

            }
            else if (indexPath.row == 2)
            {
                typeOfTime = 2;
                timerPicker = [[TimePicker alloc]initWithDataArray];
                timerPicker.delegate = self;
                [timerPicker show];
                [self.view addSubview:timerPicker];
            }
            
        }
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0) {
                //空间
                //isReflash = YES;
                [self analyseModelListData];
            }
            else if (indexPath.row == 1)
            {
                //户型
                [self analyseHouseData];
            }
            else if (indexPath.row == 2)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"客户预算" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alert.tag = 999;
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                UITextField * txt = [[UITextField alloc] init];
                txt.backgroundColor = [UIColor whiteColor];
                txt.keyboardType = UIKeyboardTypePhonePad;
                txt.frame = CGRectMake(alert.center.x+65,alert.center.y+48, 150,23);
                [alert addSubview:txt];
                [alert show];
            }
            else if (indexPath.row == 3)
            {
                //风格
                [self analyseRoomStyleData];
            }
            else if (indexPath.row == 4)
            {
                //面积
                [self analyseRoomAreasData];
            }
            else if (indexPath.row == 5)
            {
                //材料
                [self analyseRoomMaterialsData];
            }
            else if (indexPath.row == 6)
            {
                //布局
                [self analyseRoomLayoutsData];
            }
            else if (indexPath.row == 7)
            {
                //预购产品线
                [self analyseProductLineData];
            }
        }
        if(indexPath.section == 2)
        {
            if (indexPath.row != 0) {
                spaceIndex = indexPath.row - 1;
                [self drawModel:indexPath.row];
                spaceModelData =[[NSMutableArray alloc]init];
                for (int i = 0 ; i < spaceModelFormat.count; i++) {
                    [spaceModelData addObject:@""];
                }
            }
        }
    }
    else
    {
        
    }
}



-(NSMutableArray*)StringToArray:(NSString*)string
{
    if (string == nil) {
        return nil;
    }
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    NSInteger length = string.length;
    int j = 0;
    for (int i = 0; i < length; i++) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@";"]) {
            [ary addObject:[string substringWithRange:NSMakeRange(j, i-j)]];
            j = i+1;
        }
    }
    [ary addObject:[string substringFromIndex:j]];
    return ary;
}
#pragma mark 网络请求以及数据解析

#pragma mark 获取空间模板列表
/*
 方法描述：获取空间模板列表 空间名称，空间编号
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 
 */
//网络请求

-(void)analyseModelListData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];

    NSDictionary *dict = @{@"authCode":code};
    [HttpRequset post:dict method:@"MeasureSpace/GetCustomModelList" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSArray *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSMutableArray *radioAry = [[NSMutableArray alloc]init];
            modelDic = [[NSMutableDictionary alloc]init];
            
            for (id relist in JSON) {
                NSString *CustomName = [relist objectForKey:@"CustomName"];
                NSString *ModelId = [relist objectForKey:@"ModelId"];
                if(![CustomName isEqualToString:@"主卧"])
                {
                    [radioAry addObject:CustomName];
                    [modelDic setObject:ModelId forKey:CustomName];
                }
                
            }
            [self radioView:radioAry groupID:@"CustomName" title:@"空间模板" select:self.spaceLab.text];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 预购产品线
/*
 方法描述：预购产品线
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；
 */
//网络请求

-(void)analyseProductLineData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    [HttpRequset post:dict method:@"MeasureSpace/GetProductLine" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSArray *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSMutableArray *itemAry = [[NSMutableArray alloc]init];
            
            for (id relist in JSON) {
                NSString *ItemName = [relist objectForKey:@"ItemName"];
                [itemAry addObject:ItemName];
            }
            [self checkView:itemAry tag:2000];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 获取空间模板
/*
 方法描述：获取空间模板
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；@ModelId:空间模板编号
 */
//网络请求
-(void)analyseModelData:(NSString*)model
{
    self.spaceModel = [[NSMutableArray alloc]init];
    spaceModelAllData = [[NSMutableArray alloc]init];
    spaceModelAllDataCount = [[NSMutableArray alloc]init];
    spaceModelIDs = [[NSMutableArray alloc]init];
    spaceModelFormats = [[NSMutableArray alloc]init];
    modelUpdataAry = [[NSMutableArray alloc]init];
    
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code,@"ModelId":model};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetCustomModel" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            
            NSArray *ContrlInfos = [JSON objectForKey:@"ContrlInfos"];
            
            int count;
            for (id ContrlInfo in ContrlInfos) {
                count = 0;
                NSString *GroupName = [ContrlInfo objectForKey:@"GroupName"];
                [self.spaceModel addObject:GroupName];
                NSArray *ContrlContainers = [ContrlInfo objectForKey:@"ContrlContainer"];
                for (id ContrlContainer in ContrlContainers) {
                    NSString *Text = [ContrlContainer objectForKey:@"Text"];
                    NSString *ControlType = [ContrlContainer objectForKey:@"ControlType"];
                    NSString *DefaultValue = [ContrlContainer objectForKey:@"DefaultValue"];
                    NSString *Id = [ContrlContainer objectForKey:@"Id"];
                    [spaceModelFormats addObject:Text];
                    [spaceModelIDs addObject:Id];
                    [spaceModelAllData addObject:[NSString stringWithFormat:@"%@;%@",ControlType,DefaultValue]];
                    [modelUpdataAry addObject:@""];
                    count++;
                }
                [spaceModelAllDataCount addObject:[NSString stringWithFormat:@"%d",count]];
            }
            [addingSpaceTable reloadData];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 获取空间风格
/*
 方法描述：获取空间模板
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；@ModelId:空间模板编号
 */
//网络请求
-(void)analyseRoomStyleData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSArray *Style = [JSON objectForKey:@"Style"];
            [self radioView:Style groupID:@"Style" title:@"风格" select:self.styleLab.text];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 户型

-(void)analyseHouseData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSArray *Style = [JSON objectForKey:@"HouseType"];
            [self radioView:Style groupID:@"HouseType" title:@"户型" select:self.styleLab.text];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 获取空间面积
/*
 方法描述：获取空间面积
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 */
//网络请求

-(void)analyseRoomAreasData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};

    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSArray *RoomType = [JSON objectForKey:@"RoomType"];
            for (id type in RoomType)
            {
                if ([[type objectForKey:@"RoomName"]isEqualToString:modelType]) {
                    NSArray *array = [type objectForKey:@"Areas"];
                    [self radioView:array groupID:@"array" title:@"面积" select:self.areaLab.text];
                }
            }

        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];

}

#pragma mark 获取空间材料
/*
 方法描述：获取空间材料
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 */
//网络请求

-(void)analyseRoomMaterialsData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSArray *RoomType = [JSON objectForKey:@"RoomType"];
            for (id type in RoomType)
            {
                if ([[type objectForKey:@"RoomName"]isEqualToString:modelType]) {
                    NSArray *array = [type objectForKey:@"Materials"];
                    [self radioView:array groupID:@"Materials" title:@"材料" select:self.materialLab.text];
                }
            }
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 获取空间布局
/*
 方法描述：获取空间布局
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 */
//网络请求

-(void)analyseRoomLayoutsData
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSArray *RoomType = [JSON objectForKey:@"RoomType"];
            for (id type in RoomType)
            {
                if ([[type objectForKey:@"RoomName"]isEqualToString:modelType]) {
                    NSArray *array = [type objectForKey:@"Layouts"];
                    [self radioView:array groupID:@"Layouts" title:@"布局" select:self.layoutLab.text];
                }
            }
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 上传数据
/*
 方法描述：上传数据
 
 请求方式：GET和POST
 
 入参描述：
 
 */
//网络请求

-(NSMutableURLRequest*)updataCustomer
{
    
    NSURL *url = [NSURL URLWithString:OppeinURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSData *loginData = [uptadaData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseUpdataCustomer
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self updataCustomer];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             [afloading dismiss];
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSDictionary *dic = [str objectFromJSONString];
             
             NSString *JSON = [dic objectForKey:@"JSON"];
             if (JSON != nil) {
                 if (_images.count<=0) {
   
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     return;
                 }
                 MeasureId = JSON;
                 UIImage *img = [_images objectAtIndex:0];
                 [self updataImage:[self encodeToPercentEscapeString:[self image2DataURL:img]]];
             }
         }];
    });
}
#pragma mark 上传图片
/*
 方法描述：上传数据
 
 请求方式：GET和POST
 
 入参描述：
 
 */
//网络请求

- (BOOL) imageHasAlpha: (UIImage *) img
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(img.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *) image2DataURL: (UIImage *) img
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: img]) {
        imageData = UIImagePNGRepresentation(img);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(img, 0.5f);
        mimeType = @"image/jpeg";
    }
    //return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
    //[imageData base64EncodedStringWithOptions: 0]];
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
    
}
//-(NSMutableURLRequest*)initializtionRequest:(NSString*)imgstr
//{
//    
//    NSURL *url = [NSURL URLWithString:OppeinURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    request.HTTPMethod = @"POST";
//    
//    NSString *code = [HttpRequset initCode];
//    code = [HttpRequset encodeToPercentEscapeString:code];
//    
//    NSString *loginStr = [NSString stringWithFormat:@"Params={\"authCode\":\"%@\",\"MeasureId\":\"%@\",\"FileString\":\"%@\",\"FileName\":\"pic_100.png\"}&Command=UploadFile/PostMeasureFileByString",code,MeasureId,imgstr];
//    
//    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:loginData];
//    return request;
//}

-(void)updataImage:(NSString*)imgstr
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    NSDictionary *dict = @{@"authCode":code,@"MeasureId":MeasureId,@"FileString":imgstr,@"FileName":@"pic_100"};
    [HttpRequset post:dict method:@"UploadFile/PostMeasureFileByString" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        [NSURLConnection sendAsynchronousRequest:[self initializtionRequest:imgstr]
//                                           queue:[NSOperationQueue mainQueue]
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//         {
//             //将得到的NSData数据转换成NSString
//             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//             NSDictionary *dic = [str objectFromJSONString];
//             
//             NSString *ErrorMessage = [dic objectForKey:@"ErrorMessage"];
//             if ([ErrorMessage isEqualToString:@""]) {
//                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"空间信息添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                 [alert show];
//                 [self dismissViewControllerAnimated:YES completion:nil];
//             }
//         }];
//    });
}

#pragma mark 图片查看器

//图片数组绘制
-(void)imageShow:(NSMutableArray*)imageAry inView:(UIScrollView*)scrolView
{
    int contentSize = 300;
    for (int i = 0; i < imageAry.count+1; i++) {
        contentSize += 95;
        [scrolView setContentSize:CGSizeMake(contentSize, -200)];
        if (i == imageAry.count) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15+80*i, 15, 70, 50)];
            img.tag = 1000;
            img.image = [UIImage imageNamed:@"Camera"];
            img.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
            [img addGestureRecognizer:singleTap];
            [scrolView addSubview:img];
            return;
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15+80*i, 5, 70, 70)];
        [scrolView addSubview:view];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        img.tag = 1001+i;
        img.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [img addGestureRecognizer:singleTap];
        img.image = [imageAry objectAtIndex:i];
        [view addSubview:img];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(50, 0, 20, 20);
        button.tag = i;
        [button setImage:[[UIImage imageNamed:@"delete_img.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(delectImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
}

// 图片删除按钮响应

-(void)delectImageAction:(id)sender
{
    for (UIView *subviews in [scrView subviews]) {
        [subviews removeFromSuperview];
    }
    UIButton *btn = (UIButton*)sender;
    [_images removeObjectAtIndex:btn.tag];
    [self imageShow:_images inView:scrView];
}

//添加图片响应

-(void)onClickImage:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *img=(UIImageView*)recognizer.view;
    if (img.tag == 1000) {
        UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"取消", nil];
        [sheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else if (buttonIndex==1){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info  objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
    [self plist];
    
}
-(void)dicPaths
{
    NSMutableArray *specialArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    
    [dic setObject:filePath forKey:@"img"];
    [specialArr addObject:dic];
}
-(void)plist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    ;
    NSLog(@"%@",filePath);
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    NSLog(@"%@",img);
    [_images addObject:[UIImage imageWithContentsOfFile:filePath]];
    NSLog(@"%@",_images);
    [self imageShow:_images inView:scrView];
}

#pragma mark 时间选择器
-(void)clickTimeWith:(TimePicker*)timePicker timer:(NSString*)timer
{
    if (typeOfTime == 1) {
        self.measureLab.text = timer;
        measure = timer;
    }
    else
    {
        self.finishLab.text = timer;
        finish = timer;
    }
}
@end

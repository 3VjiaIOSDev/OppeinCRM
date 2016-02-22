//
//  SpaceInfoViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/15.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "SpaceInfoViewController.h"

@interface SpaceInfoViewController ()
{
    int point_h;
    NSMutableArray *_images;
    UIScrollView *scrView;
    UIScrollView *scrollView;
    NSString *noteString;
    AFLoadIngView *afloading;
    int Measure;
}
@property NSMutableArray *tagAry1;
@property NSMutableArray *tagAry2;
@property NSMutableArray *tagAry3;
@property NSMutableArray *tagAry4;
@end

@implementation SpaceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _images = [[NSMutableArray alloc]init];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+100);
    [self.view addSubview:scrollView];
    [self spaceInfo];
    // Do any additional setup after loading the view.
    
    [self initNavigation];

}
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"量尺详情"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}
-(void)initView
{
    self.tagAry1 = [[NSMutableArray alloc]initWithObjects:@"量尺类型 :",@"量尺时间:",@"预计完成时间:",@"空间:",@"风格:",@"面积(m²):",@"预购产品线:", nil];
    
    for (int i = 0 ; i < 7; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 35+40*i, 300, 30)];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.text = [NSString stringWithFormat:@"%@ %@",[self.tagAry1 objectAtIndex:i],[self.tagAry3 objectAtIndex:i]];//[tagAry1 objectAtIndex:i];
        [scrollView addSubview:lab];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 315, self.view.frame.size.width-30, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [scrollView addSubview:lineView];
    
    UILabel *imageLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 320, 60, 30)];
    imageLab.text = @"附件:";
    imageLab.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:imageLab];
    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 340, 2*self.view.frame.size.width, 80)];
    if (_images.count <= 0) {
        imageLab.text = @"附件:无";
        for(int i = 0;i < self.tagAry2.count; i++)
        {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 360+i*40, 305, 40)];
            lab.text = [NSString stringWithFormat:@"%@",[self.tagAry2 objectAtIndex:i]];//[tagAry2 objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:14.0f];
            lab.lineBreakMode = NSLineBreakByWordWrapping;
            lab.numberOfLines = 0;
            [scrollView addSubview:lab];
        }
        return;
    }
    
    [self imageShow:_images inView:scrView];
    [scrollView addSubview:scrView];
    for(int i = 0;i < self.tagAry2.count; i++)
    {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 420+i*40, 305, 40)];
        lab.text = [NSString stringWithFormat:@"%@",[self.tagAry2 objectAtIndex:i]];//[tagAry2 objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
        [scrollView addSubview:lab];
    }
}
-(void)imageShow:(NSMutableArray*)imageAry inView:(UIScrollView*)scrolView
{
    int contentSize = 300;
    for (int i = 0; i < imageAry.count; i++) {
        contentSize += 95;
        [scrolView setContentSize:CGSizeMake(contentSize, -200)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15+80*i, 5, 70, 70)];
        [scrolView addSubview:view];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        img.tag = 1001+i;
        img.userInteractionEnabled=YES;
        
        img.image = [imageAry objectAtIndex:i];
        [view addSubview:img];
    }
}


-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)spaceInfo
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code,@"MeasureId":self.MeasureId};
    [HttpRequset post:dict method:@"MeasureSpace/GetMeasureInfo" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        [afloading dismiss];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [dic[@"JSON"]objectFromJSONString];
            [self ReloadView:JSON];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

-(void)ReloadView:(NSDictionary*)JSON
{
    NSNumber *MeasureType = [JSON objectForKey:@"MeasureType"];
    NSInteger type = [MeasureType integerValue];
    self.tagAry3 = [[NSMutableArray alloc]init];
    self.tagAry2 = [[NSMutableArray alloc]init];
    if (type == 0) {
        [self.tagAry3 addObject:@"初尺"];
        Measure = 0;
    }
    else
    {
        Measure = 1;
        [self.tagAry3 addObject:@"复尺"];
    }
    NSString *MeasureTime = [JSON objectForKey:@"MeasureTime"];
    [self.tagAry3 addObject:MeasureTime];
    NSString *FinishTime = [JSON objectForKey:@"FinishTime"];
    [self.tagAry3 addObject:FinishTime];
    NSString *SpaceName = [JSON objectForKey:@"SpaceName"];
    [self.tagAry3 addObject:SpaceName];
    NSString *Style = [JSON objectForKey:@"Style"];
    [self.tagAry3 addObject:Style];
    NSString *Area = [JSON objectForKey:@"Area"];
    [self.tagAry3 addObject:Area];
    NSString *RoomType = [JSON objectForKey:@"RoomType"];
    //预购产品线
    NSArray *BuyWillView = [JSON objectForKey:@"BuyWillView"];
    
    NSString *buyString =@"";
    for (id buywill in BuyWillView) {
        NSString *ItemName = [buywill objectForKey:@"ItemName"];
        buyString = [NSString stringWithFormat:@"%@\%@",buyString,ItemName];
    }
    if ([buyString isEqualToString:@""]) {
        buyString = @"无";
    }
    NSString *BuyWill = [JSON objectForKey:@"BuyWill"];
    [self.tagAry3 addObject:BuyWill];
    NSArray *FileList = [JSON objectForKey:@"FileList"];
    for (id filelist in FileList) {
        NSString *FileFullPath = [filelist objectForKey:@"FileFullPath"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mtds.oppein.com%@",FileFullPath]];
        NSData *resultData = [NSData dataWithContentsOfURL:url];
        
        UIImage *img = [UIImage imageWithData:resultData];
        if (img) {
            [_images addObject:img];
        }
    }
    
    //购买意向
    
    NSDictionary *AppCustomModel = [JSON objectForKey:@"AppCustomModel"];
    if ([AppCustomModel isEqual:[NSNull null]]) {
        [self.tagAry2 addObject:@""];
    }
    else
    {
        
        NSArray *ContrlInfos = [AppCustomModel objectForKey:@"ContrlInfos"];
        if (![ContrlInfos isEqual:[NSNull null]]) {
            for (id ContrlInfo in ContrlInfos) {
                NSString *GroupName = [ContrlInfo objectForKey:@"GroupName"];
                NSLog(@"%@",GroupName);
                [self.tagAry2 addObject:GroupName];
            }
        }
        else
        {
            [self.tagAry2 addObject:@""];
        }
    }
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

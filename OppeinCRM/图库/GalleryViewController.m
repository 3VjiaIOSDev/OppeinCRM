//
//  GalleryViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "GalleryViewController.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "StoreCollectionCell.h"

@interface GalleryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
{
    NSMutableArray *_images;
    NSMutableArray *name;
    NSMutableArray *schemeArray;
}

@property (nonatomic, strong)UICollectionView *collection;
@property (nonatomic,strong)NSMutableArray * mwphotoArray;

@end

@implementation GalleryViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _images = [NSMutableArray array];
    name = [NSMutableArray array];
    schemeArray = [NSMutableArray array];
    self.pageIndex = 1;
    
    [self initUI];
    [self getSchemeList:self.pageIndex];
}

-(void)initUI
{
    
    CGFloat cellW = (self.view.frame.size.width-30)/2;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(cellW,cellW);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)collectionViewLayout:flowLayout];
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection setCollectionViewLayout:flowLayout];
    [self.collection registerClass:[StoreCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collection];
    
    //   [self addHeader];
    [self addFooter];
    //    nullView = [[ShowNullView alloc]initWithMsg:@"没有数据" heigth:Screen_Height-154];
}

-(void)viewDidAppear:(BOOL)animated
{
    [examineView removeFromSuperview];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collection addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.pageIndex++;
        [vc getSchemeList:vc.pageIndex];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collection reloadData];
            // 结束刷新
            [vc.collection footerEndRefreshing];
        });
    }];
}

-(void)getSchemeList:(int)index
{
    
    AFLoadIngView *afLoading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afLoading];
    NSNumber *number = [NSNumber numberWithInt:index];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
   // NSString * deptId = [userDefaultes stringForKey:@"DeptId"];
    
    NSDictionary *dict = @{@"authCode":code,@"deptId":@"",@"pageSize":@"8",@"pageIndex":number,@"isHasQJ":@0};
    [HttpRequset post1:dict method:@"Designscheme/GetSchemeList" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        [afLoading removeFromSuperview];
        if ([dic[@"Status"]integerValue] == 200)
        {
            NSDictionary *JSONDic = [dic[@"JSON"] objectFromJSONString];
            NSArray *ReturnList = JSONDic[@"ReturnList"];
            for (id list in ReturnList) {
                [name addObject:list[@"SchemeName"]];
                NSString *imagePath = list[@"ImagePath"];
                [_images addObject:[NSString stringWithFormat:@"http://passport.admin.mnmnh.com%@",imagePath]];
                [schemeArray addObject:list[@"SchemeId"]];
            }
            [self.collection reloadData];
        }else{
            
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StoreCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (schemeArray.count != 0) {
        // NSDictionary *dic = [schemeArray objectAtIndex:indexPath.row];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[_images objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"少女情怀.jpg"]];

        //cell.imageView.image = [UIImage imageNamed:@"少女情怀.jpg"];
        cell.textLab.text = [name objectAtIndex:indexPath.row];
        // cell.subLab.text = [NSString stringWithFormat:@"%@个人收藏",dic[@"TotalFavorite"]];
    }
    return cell;
}

-(void)getSchemeDetail:(NSString*)schemeId
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,@"schemeId":schemeId,@"isContainSchemes":@"0"};
    [HttpRequset post1:dict method:@"DesignScheme/GetSchemeDetail" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [dic[@"JSON"] objectFromJSONString];
            NSDictionary *SchemeImgs = [JSON[@"SchemeImgs"]objectFromJSONString];
            
            NSArray * array = SchemeImgs[@"ReturnList"];
            if (array.count ==0) {
                return ;
            }
            [self photoBrowser:array];
            
        }else
        {
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
- (void)photoBrowser:(NSArray *)arr
{
    NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary * dic = [arr objectAtIndex:i];
        NSString * imageUrl = [NSString stringWithFormat:@"http://passport.admin.mnmnh.com%@",dic[@"FileFullPath"]];
        MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]];
        photo.caption = dic[@"SchemeName"];
        [mutableArray addObject:photo];
    }
    _mwphotoArray = mutableArray;
    MWPhotoBrowser * browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
    
}
#pragma mark  MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _mwphotoArray.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _mwphotoArray.count) {
        return [_mwphotoArray objectAtIndex:index];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *schemeId =[schemeArray objectAtIndex:indexPath.row];
    [self getSchemeDetail:schemeId];
    
}

-(void)close:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         examineView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [examineView removeFromSuperview];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

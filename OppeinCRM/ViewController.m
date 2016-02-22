//
//  ViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "ViewController.h"
#import "CustomerViewController.h"
#import "GalleryViewController.h"
#import "UserinfoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CustomerViewController *customerVC = [[CustomerViewController alloc]init];
    GalleryViewController *galleryVC = [[GalleryViewController alloc]init];
    UserinfoViewController *userinfoVC = [[UserinfoViewController alloc]init];
    
    customerVC.title = @"我的客户";
    galleryVC.title = @"图库";
    userinfoVC.title = @"我";
    
    UINavigationController *customerNav = [[UINavigationController alloc]initWithRootViewController:customerVC];
    UINavigationController *galleryNav = [[UINavigationController alloc]initWithRootViewController:galleryVC];
    UINavigationController *userinfoNav = [[UINavigationController alloc]initWithRootViewController:userinfoVC];
    
    customerNav.tabBarItem.image = [[UIImage imageNamed:@"first_normal"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    customerNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"first_selected"]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    galleryNav.tabBarItem.image = [[UIImage imageNamed:@"second_normal"]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    galleryNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"second_selected"]
                                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    userinfoNav.tabBarItem.image = [[UIImage imageNamed:@"third_normal"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userinfoNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"third_selected"]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = [NSArray arrayWithObjects:customerNav,galleryNav,userinfoNav,nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

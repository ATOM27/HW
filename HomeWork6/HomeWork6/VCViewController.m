//
//  VCViewController.m
//  HomeWork6
//
//  Created by Eugene Mekhedov on 24.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "VCViewController.h"
#import "UIColor+ChangeColor.h"

@interface VCViewController ()

@end

@implementation VCViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* addBar = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(actionRightBar:)];
    
    UIBarButtonItem* dropBar = [[UIBarButtonItem alloc] initWithTitle:@"Drop" style:UIBarButtonItemStylePlain target:self action:@selector(actionDropBar:)];
    
    self.navigationItem.rightBarButtonItems = @[addBar, dropBar];
    
    UIBarButtonItem* changeColorBar = [[UIBarButtonItem alloc] initWithTitle:@"Change color" style:UIBarButtonItemStylePlain target:self action:@selector(actionChangeColor:)];
    
    [self setToolbarItems:@[changeColorBar] animated:YES];

    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Actions

-(void)actionRightBar:(UIBarButtonItem*) sender{
    VCViewController* vc = [[VCViewController alloc] init];
    int index = [self.navigationController.viewControllers count];
    vc.title = [NSString stringWithFormat:@"ViewController%d", index];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)actionChangeColor:(UIBarButtonItem*) sender{
    VCViewController* currentViewController = [self.navigationController.viewControllers lastObject];
    currentViewController.view.backgroundColor = [UIColor randomColor];
}

-(void)actionDropBar:(UIBarButtonItem*) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

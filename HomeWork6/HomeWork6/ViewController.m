//
//  ViewController.m
//  HomeWork6
//
//  Created by Eugene Mekhedov on 24.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "ViewController.h"
#import "VCViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UINavigationController* nav;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    VCViewController* first = [[VCViewController alloc] init];
    first.view.backgroundColor = [UIColor greenColor];
    first.title = @"ViewController0";
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:first];
    [self.nav setToolbarHidden:NO animated:YES];
    
    [self presentViewController:self.nav animated:YES completion:nil];
}


@end

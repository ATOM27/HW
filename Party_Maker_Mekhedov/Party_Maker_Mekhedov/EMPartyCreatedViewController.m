//
//  EMPartyCreatedViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 01.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyCreatedViewController.h"
#import "EMPartyListViewController.h"
@interface EMPartyCreatedViewController ()

@end

@implementation EMPartyCreatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionOkTouched:(UIButton *)sender {
    [self.navCont popToRootViewControllerAnimated:NO];
    [[(EMPartyListViewController*)[self.navCont.viewControllers firstObject] tableView] reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
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

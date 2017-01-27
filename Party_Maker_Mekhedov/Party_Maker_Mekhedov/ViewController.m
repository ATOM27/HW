//
//  ViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 25.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "ViewController.h"
#import "EMPartyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem* addPartyBar = [[UIBarButtonItem alloc] initWithTitle:@"Add party"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(actionAddParty:)];
    self.navigationItem.rightBarButtonItem = addPartyBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void) actionAddParty:(UIBarButtonItem*) sender{
    
    EMPartyViewController* partyVC = [[EMPartyViewController alloc] init];
    
    [self.navigationController pushViewController:partyVC animated:YES];
}


@end

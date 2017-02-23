//
//  EMSettingsViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/16/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMSettingsViewController.h"

@interface EMSettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *developerLabel;
@end

@implementation EMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.infoView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [NSString stringWithFormat:@"Party Maker %@ (c)\nVersion:%@ (%@)",
                              yearString,
                              [infoDict objectForKey:@"CFBundleShortVersionString"],
                              [infoDict objectForKey:(NSString*)kCFBundleVersionKey]];
    
    self.developerLabel.text = [NSString stringWithFormat:@"Developed for\nSoftheme iOS Internship\n%@",yearString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionSignOut:(UIButton *)sender {
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}


@end

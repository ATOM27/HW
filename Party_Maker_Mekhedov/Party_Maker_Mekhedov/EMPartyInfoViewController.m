//
//  EMPartyInfoViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 19.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyInfoViewController.h"
#import "EMMapViewController.h"
#import "UIViewController+Alert.h"
#import "EMAddPartyViewController.h"
#import "EMHTTPManager.h"
#import "PMRCoreDataManager+Party.h"
#import "EMPartyListViewController.h"
#import "UIViewController+Alert.h"


@interface EMPartyInfoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *partyLogo;
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *partyDescription;
@property (strong, nonatomic) IBOutlet UILabel *partyDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyEndLabel;
@property (strong, nonatomic) IBOutlet UIView *imageSuperView;


@end

@implementation EMPartyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageSuperView.layer.borderWidth = 3.f;
    self.imageSuperView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    
    self.partyLogo.image = [UIImage imageNamed:self.currentParty.logoImageName];
    self.partyLogo.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    self.partyName.text = self.currentParty.name;
    self.partyDescription.text = self.currentParty.descriptionText;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];

    self.partyDateLabel.text = [dateFormatter stringFromDate:self.currentParty.startDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    self.partyStartLabel.text = [dateFormatter stringFromDate:self.currentParty.startDate];
    self.partyEndLabel.text = [dateFormatter stringFromDate:self.currentParty.endDate];
    
}

-(void)viewDidLayoutSubviews{
    self.imageSuperView.layer.cornerRadius = CGRectGetHeight(self.imageSuperView.bounds)/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionLocationTouched:(UIButton *)sender {
    if(![self.currentParty.longtitude isEqualToString:@""] && ![self.currentParty.latitude isEqualToString:@""]){
        [self performSegueWithIdentifier:@"showPartyLocationIdentifier" sender:self];
    }else{
        [self alertWithTitle:@"There is no location" message:@"This party have not location information"];
    }
}

- (IBAction)actionEditTouched:(UIButton *)sender {
    [self performSegueWithIdentifier:@"editPartyIdentifier" sender:self];
}

- (IBAction)actionDeleteTouched:(UIButton *)sender {
    [[EMHTTPManager sharedManager] deletePartyWithID:self.currentParty.partyID
                                           creatorID:self.creatorID
                                          completion:^(NSDictionary *response, NSError *error) {
                                              if(error){
                                                  NSLog(@"%@", [error localizedDescription]);
                                              }else{
                                                  if([[response valueForKey:@"status"] isEqualToString:@"Success"]){
                                                      [[PMRCoreDataManager sharedStore] deletePartyWithName:self.currentParty.name completion:^(BOOL success) {
                                                          
                                                          [[(EMPartyListViewController*)[self.navigationController.viewControllers firstObject] tableView] reloadData];
                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                      }];
                                                  }else{
                                                      [self alertWithTitle:@"Ops!" message:@"There is something wrong with the party's data. Try to change paramethers and save it!"];
                                                  }
                                              }
                                          }];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showPartyLocationIdentifier"]){
        EMMapViewController* mapVC = segue.destinationViewController;
        mapVC.existingLatitude = [self.currentParty.latitude floatValue];
        mapVC.existingLongitude = [self.currentParty.longtitude floatValue];
    }
    
    if([segue.identifier isEqualToString:@"editPartyIdentifier"]){
        EMAddPartyViewController* editVC = segue.destinationViewController;
        editVC.creatorID = self.creatorID;
        editVC.currentParty = self.currentParty;
    }
}

@end

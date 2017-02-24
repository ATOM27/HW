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
#import "ImagesManager.h"


@interface EMPartyInfoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *partyLogo;
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *partyDescription;
@property (strong, nonatomic) IBOutlet UILabel *partyDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyEndLabel;
@property (strong, nonatomic) IBOutlet UIView *imageSuperView;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property(strong, nonatomic) NSString* creatorID;

@end

@implementation EMPartyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.creatorID = [[NSUserDefaults standardUserDefaults] objectForKey:@"creatorID"];
    
    self.imageSuperView.layer.borderWidth = 3.f;
    self.imageSuperView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.partyLogo.image = [UIImage imageNamed:[[ImagesManager sharedManager].arrayWithImages objectAtIndex:self.currentParty.logoID.integerValue]];
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

-(void)viewWillAppear:(BOOL)animated{
    
    //From annotation
    if(!self.showOnlyInfo == NO){
        self.locationButton.hidden = YES;
        self.editButton.hidden = YES;
        self.deleteButton.hidden = YES;
    }
}

-(void)viewDidLayoutSubviews{
    self.imageSuperView.layer.cornerRadius = CGRectGetHeight(self.imageSuperView.bounds)/2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    //self.showOnlyInfo = YES;
}

#pragma mark - Actions


- (IBAction)actionLocationTouched:(UIButton *)sender {
    if(![self.currentParty.longtitude isEqualToString:@""] && ![self.currentParty.latitude isEqualToString:@""]){
        [self performSegueWithIdentifier:@"showPartyLocationIdentifier" sender:self];
    }else{
        [self alertWithTitle:@"There is no location" message:@"This party have no location information"];
    }
}

- (IBAction)actionEditTouched:(UIButton *)sender {
    [self performSegueWithIdentifier:@"editPartyIdentifier" sender:self];
}

- (IBAction)actionDeleteTouched:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[EMHTTPManager sharedManager] deletePartyWithID:self.currentParty.partyID
                                          completion:^(NSDictionary *response, NSError *error) {
                                              if(error){
                                                  NSLog(@"%@", [error localizedDescription]);
                                              }else{
                                                  if(![response valueForKey:@"error"]){
                                                      [[PMRCoreDataManager sharedStore] deletePartyWithName:self.currentParty.name completion:^(BOOL success) {
                                                          
                                                        //  [(EMPartyListViewController*)[self.navigationController.viewControllers firstObject] updateTableViewWithParties];
                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                      }];
                                                  }else{
                                                      [self alertWithTitle:@"Ops!" message:@"There is something wrong with the party's data. Try to change paramethers and save it!"];
                                                  }
                                              }
                                              self.navigationItem.rightBarButtonItem.enabled = YES;
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
        editVC.currentParty = self.currentParty;
    }
}

@end

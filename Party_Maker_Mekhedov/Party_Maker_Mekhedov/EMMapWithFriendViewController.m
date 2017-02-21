//
//  EMMapWithFriendViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMMapWithFriendViewController.h"
#import "EMSelectFriendsViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "EMHTTPManager.h"
#import "PMRParty+initWithDictionary.h"
#import "EMMapFriendInfoAnnotation.h"
#import "EMHTTPManager.h"
#import "UIView+superAnnotationView.h"
#import "EMPartyInfoViewController.h"
#import "PMRParty.h"

@interface EMMapWithFriendViewController ()

@property(strong, nonatomic) PMRParty* partyFromAnnotation;

@end

@implementation EMMapWithFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.checkedFriends = [[NSArray alloc] init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)makeAnnotations{
    [self.mapView removeAnnotations:[self.mapView annotations]];
    for(NSDictionary* currentFriend in self.checkedFriends){
            [[EMHTTPManager sharedManager] partyWithCreatorID:[currentFriend objectForKey:@"id"]
                                                   completion:^(NSDictionary *response, NSError *error) {
                                                           NSArray* parties = [response objectForKey:@"response"];
                                                           for (NSDictionary* partyDict in parties){
                                                               PMRParty* party = [[PMRParty alloc] initWithDictionary:partyDict];
                                                               
                                                               if([party.latitude isEqualToString:@""] || [party.longtitude isEqualToString:@""]){
                                                                   continue;
                                                               }
                                                               
                                                               CLLocation* location = [[CLLocation alloc] initWithLatitude:[party.latitude floatValue] longitude:[party.longtitude floatValue]];
                                                               [self makeAnotationWithLocation:location andParty:party];
                                                           }
                                                   }];
    }
                       
}

#pragma mark - Actions

- (IBAction)actionSelectFriends:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"selectFriendsIdentifier" sender:self];
}

- (IBAction)actionReset:(UIBarButtonItem *)sender {
    NSDictionary* creatorID = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"creatorID"]};
    self.checkedFriends = @[creatorID];
    [self makeAnnotations];
}

-(void)actionPartyInfo:(UIButton*)sender{
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if(!annotationView){
        return;
    }
    
    EMMapFriendInfoAnnotation* annotation = (EMMapFriendInfoAnnotation*)annotationView.annotation;
    self.partyFromAnnotation = annotation.party;
    [self performSegueWithIdentifier:@"partyInfoIdentifier" sender:self];
}

- (IBAction)actionShowAll:(UIBarButtonItem *)sender {
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations){
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        MKMapRect rect = MKMapRectMake( center.x, center.y, 1, 1);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];

}

#pragma mark - Annotation

-(void) makeAnotationWithLocation:(CLLocation*) location andParty:(PMRParty*)party{
    EMMapFriendInfoAnnotation* annotation = [[EMMapFriendInfoAnnotation alloc] init];

    [self getTitleAndSubtitleForAnnotation:annotation inLocation:location];
    
    annotation.party = party;
    annotation.coordinate = location.coordinate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotation:annotation];
    });
}

-(void)getTitleAndSubtitleForAnnotation:(EMMapFriendInfoAnnotation*) annotation inLocation:(CLLocation*)location{
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                            
                            NSString* name = nil;
                            NSString* address = nil;
                            
                            if (error){
                                NSLog(@"%@", [error localizedDescription]);
                            }else{
                                
                                if ([placemarks count] > 0){
                                    
                                    CLPlacemark* placeMark = [placemarks firstObject];
                                    
                                    name = placeMark.name;
                                    address = ABCreateStringWithAddressDictionary(placeMark.addressDictionary, NO);
                                }
                                
                                annotation.title = name;
                                annotation.subtitle = address;
                                
                            }
    }];
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    static NSString* identifier = @"Annotation";
    
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin){
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.pinTintColor = [UIColor orangeColor];
        
        UIButton* infoPartyButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [infoPartyButton addTarget:self action:@selector(actionPartyInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView = infoPartyButton;

    }else{
        pin.annotation = annotation;
    }
    
    return pin;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"partyInfoIdentifier"]){
        EMPartyInfoViewController* vc = segue.destinationViewController;
        vc.currentParty = self.partyFromAnnotation;
        vc.showOnlyInfo = YES;
    }
    if([segue.identifier isEqualToString:@"selectFriendsIdentifier"]){
        EMSelectFriendsViewController* vc = segue.destinationViewController;
        if(self.checkedFriends.count == 1 && [[self.checkedFriends firstObject] valueForKey:@"id"]){
            self.checkedFriends = @[];
        }
        vc.checkedFriends = [NSMutableArray arrayWithArray:self.checkedFriends];
    }
}





@end

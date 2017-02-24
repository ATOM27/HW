//
//  EMMapInfoViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 19.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMMapInfoViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "NSObject+ActivityIndicator.h"

@interface EMMapInfoViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation EMMapInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CLLocation* location = [[CLLocation alloc] initWithLatitude:self.existingLatitude longitude:self.existingLongitude];
    [self makeAnotationWithLocation:location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Annotation

-(void) makeAnotationWithLocation:(CLLocation*) location{
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    
    [self getTitleAndSubtitleForAnnotation:annotation inLocation:location];
    
    annotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
}

-(void)getTitleAndSubtitleForAnnotation:(MKPointAnnotation*) annotation inLocation:(CLLocation*)location{
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
        
        }else{
        pin.annotation = annotation;
    }
    
    return pin;
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView{
    [self activityIndicatorIsVisible:YES];
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    [self activityIndicatorIsVisible:NO];
}

@end

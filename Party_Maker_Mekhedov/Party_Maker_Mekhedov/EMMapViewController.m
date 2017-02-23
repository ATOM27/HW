//
//  EMMapViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/16/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMMapViewController.h"
#import "UIViewController+Alert.h"
#import <AddressBookUI/AddressBookUI.h>
#import "EMAddPartyViewController.h"
#import "NSObject+ActivityIndicator.h"

@interface EMMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) MKPinAnnotationView*  pin;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@end

@implementation EMMapViewController 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.existingLongitude){
        CLLocation* location = [[CLLocation alloc] initWithLatitude:self.existingLatitude longitude:self.existingLongitude];
        [self makeAnotationWithLocation:location];
    }else{
        [self locationAuthorization];
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
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

#pragma mark - Gesture

-(void)handleTap:(UITapGestureRecognizer*) tapGesture{
    
    CGPoint tapPoint = [tapGesture locationInView:self.view];
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:tapPoint toCoordinateFromView:self.view];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];

    if(self.mapView.annotations.count > 1){
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    if(!self.pin.annotation){
        [self makeAnotationWithLocation:location];
    }else{
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.pin.annotation.coordinate = newCoordinate;
                         self.coordinate = newCoordinate;
                         [self getTitleAndSubtitleForAnnotation:self.pin.annotation inLocation:location];

                     } completion:nil];
     }
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
        pin.draggable = YES;
        pin.pinTintColor = [UIColor orangeColor];
        
        UIButton* addLocationPartyButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addLocationPartyButton addTarget:self action:@selector(actionAddLocation:) forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView = addLocationPartyButton;
    }else{
        pin.annotation = annotation;
    }
    self.pin = pin;
    return pin;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    
    if (newState == MKAnnotationViewDragStateEnding){
        
        CLLocation* location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude] ;
        [self getTitleAndSubtitleForAnnotation:view.annotation inLocation:location];
    }

}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView{
    [self activityIndicatorIsVisible:YES];
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    [self activityIndicatorIsVisible:NO];
}


#pragma mark - Action

-(void)actionAddLocation:(UIButton*)sender{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    EMAddPartyViewController* vc = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
    [vc.locationButton setTitle:self.pin.annotation.subtitle forState:UIControlStateNormal];
    vc.longitude = [NSString stringWithFormat:@"%f", self.coordinate.longitude];
    vc.latitude = [NSString stringWithFormat:@"%f", self.coordinate.latitude];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Location

-(void)locationAuthorization{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
        default:
            [self alertForLocationWithTitle:@"You need to allow app access to your lcoation in settings" message:@"The app uses your location to make the party place"];
            break;
    }
    
    if ([CLLocationManager locationServicesEnabled]){
        [self.locationManager requestLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    CLLocation* location = [locations lastObject];
    [self makeAnotationWithLocation:location];
    
    }

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

@end

//
//  EMMapViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/16/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMMapViewController.h"
#import "UIViewController+Alert.h"

@interface EMMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation EMMapViewController 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self locationAuthorization];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) makeAnotationWithCoordinate:(CLLocationCoordinate2D) coordinate{
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"Title";
    annotation.subtitle = @"Subtitle";
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
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
        
//        UIButton* descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [descriptionButton addTarget:self action:@selector(actionDescription:) forControlEvents:UIControlEventTouchUpInside];
//        
//        pin.rightCalloutAccessoryView = descriptionButton;
    }else{
        pin.annotation = annotation;
    }
    
    return pin;

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
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    
    [self makeAnotationWithCoordinate:location.coordinate];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

@end

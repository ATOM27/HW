//
//  EMMapInfoViewController.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 19.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EMMapInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (assign, nonatomic) CGFloat existingLatitude;
@property (assign, nonatomic) CGFloat existingLongitude;


@end

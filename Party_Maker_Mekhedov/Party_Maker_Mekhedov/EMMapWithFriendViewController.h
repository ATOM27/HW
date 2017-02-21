//
//  EMMapWithFriendViewController.h
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EMMapWithFriendViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray* checkedFriends;

-(void)makeAnnotations;
@end

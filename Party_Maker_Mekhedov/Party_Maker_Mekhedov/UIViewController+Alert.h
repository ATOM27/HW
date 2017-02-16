//
//  UIViewController+Alert.h
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

-(void) alertWithTitle:(NSString*) title message:(NSString*)message;
-(void) alertForLocationWithTitle:(NSString*) title message:(NSString*)message;

@end

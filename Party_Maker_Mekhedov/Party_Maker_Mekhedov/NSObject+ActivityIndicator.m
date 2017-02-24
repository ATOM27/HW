//
//  NSObject+ActivityIndicator.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/23/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "NSObject+ActivityIndicator.h"
#import <UIKit/UIApplication.h> 

@implementation NSObject (ActivityIndicator)

-(void) activityIndicatorIsVisible:(BOOL) visability{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = visability;
    
}

@end

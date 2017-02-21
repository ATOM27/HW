//
//  UIView+superAnnotationView.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 21.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "UIView+superAnnotationView.h"

@implementation UIView (superAnnotationView)

-(MKAnnotationView*) superAnnotationView{
    
    if ([self isKindOfClass: [MKAnnotationView class]]){
        
        return (MKAnnotationView*)self;
    }
    
    if (!self.superview){
        return nil;
    }
    
    return [self.superview superAnnotationView];
}

@end

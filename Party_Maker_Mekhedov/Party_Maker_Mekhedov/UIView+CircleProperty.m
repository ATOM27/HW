//
//  UIView+CircleProperty.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "UIView+CircleProperty.h"
#import <objc/runtime.h>

@implementation UIView (CircleProperty)

#pragma mark - Circle

-(void) showCircle{
    if(![EMSelectedObject sharedManager].lastObject){
        self.circle.hidden = NO;
        [EMSelectedObject sharedManager].lastObject = self;
    }else{
        if([[EMSelectedObject sharedManager].lastObject isEqual:self]){
            return;
        }
        self.circle.hidden = NO;
        [EMSelectedObject sharedManager].lastObject.circle.hidden = YES;
        [EMSelectedObject sharedManager].lastObject = self;
    }
}


-(void)setCircle:(UIView *)circle{
    
    objc_setAssociatedObject(self, @selector(circle), circle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView*)circle{
    return objc_getAssociatedObject(self, @selector(circle));
}

@end

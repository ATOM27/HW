//
//  EMButton.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMButton.h"
#import "UIView+CircleProperty.h"

@implementation EMButton

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color text:(NSString*)text
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitle:text forState:UIControlStateNormal];
        self.layer.cornerRadius = 5.f;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = color;
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        
        [self addTarget:self action:@selector(actionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) alertWithTitle:(NSString*) title message:(NSString*)message andViewConctroller:(UIViewController*) vc{
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [vc presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

-(void)actionButtonTouchUpInside:(UIButton*) sender{
    
    if(self.action){
        [self showCircle];
        self.action();
    }
    
}
@end

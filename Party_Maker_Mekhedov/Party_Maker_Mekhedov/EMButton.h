//
//  EMButton.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMButton : UIButton

@property (copy, nonatomic) void (^action)(void);

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color text:(NSString*)text;
-(void) alertWithTitle:(NSString*) title message:(NSString*)message andViewConctroller:(UIViewController*)vc;

-(void)actionButtonTouchUpInside:(UIButton*) sender;
@end

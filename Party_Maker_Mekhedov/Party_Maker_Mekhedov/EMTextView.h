//
//  EMTextView.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMTextView : UITextView <UITextViewDelegate>

@property (strong, nonatomic) UIView* mainView;

- (instancetype)initWithFrame:(CGRect)frame andMainView:(UIView*)view;
-(void)makeNotifications;

@end

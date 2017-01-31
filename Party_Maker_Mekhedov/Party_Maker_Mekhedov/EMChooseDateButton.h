//
//  EMChooseDateButton.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 26.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMChooseDateButton : UIButton

@property (strong, nonatomic) UIView* mainView;
@property (strong, nonatomic) UIDatePicker* datePicker;
@property (strong, nonatomic) UIToolbar* toolForDate;


- (instancetype)initWithObjectView:(UIView*)objectsView mainView:(UIView*)mainView;
-(void)actionChooseDate:(UIButton*) sender;

@end

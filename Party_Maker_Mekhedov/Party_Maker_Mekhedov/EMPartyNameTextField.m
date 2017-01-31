//
//  EMPartyNameTextField.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 26.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyNameTextField.h"
#import "UIView+CircleProperty.h"

@implementation EMPartyNameTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self) {
            
            self.backgroundColor = [UIColor colorWithRed:35.f/255.f green:37.f/255.f blue:43.f/255.f alpha:1.f];
            
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your party name"
                                                                         attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                      }
                                          ];
            self.textColor = [UIColor whiteColor];
            self.textAlignment = NSTextAlignmentCenter;
            self.layer.cornerRadius = 5.f;
            self.returnKeyType = UIReturnKeyDone;
            self.delegate = self;
        }
        return self;
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showCircle];
    return YES;
}

@end

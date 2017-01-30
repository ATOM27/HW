//
//  EMTextView.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMTextView.h"
#import "UIView+CircleProperty.h"

@interface EMTextView()

@property(strong, nonatomic) UIToolbar* toolBar;

@end

@implementation EMTextView

- (instancetype)initWithFrame:(CGRect)frame andMainView:(UIView*)view
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* blueStrip = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     CGRectGetWidth(frame),
                                                                     5)];
        blueStrip.backgroundColor = [UIColor colorWithRed:40.f/255.f green:132.f/255.f blue:175.f/255.f alpha:1.f];
        [self addSubview:blueStrip];
        self.mainView = view;
        self.backgroundColor = [UIColor colorWithRed:35.f/255.f green:37.f/255.f blue:43.f/255.f alpha:1.f];
        self.layer.cornerRadius = 5.f;
        self.textColor = [UIColor whiteColor];
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}

-(void) makeNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) createToolBarWithKeyboardRect:(CGRect)keyboardRect{
    
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(keyboardRect) - 40, CGRectGetWidth(keyboardRect), 40)];
    toolBar.barTintColor = [UIColor colorWithRed:68.f/255.f green:73.f/255.f blue:83.f/255.f alpha:1.f];
    toolBar.tintColor = [UIColor whiteColor];
    self.toolBar = toolBar;
    UIBarButtonItem* cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actionClose:)];
    
    UIBarButtonItem* flexSpaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem* doneBar = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionDone:)];
    
    [doneBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]
                                      } forState:UIControlStateNormal];
    
    toolBar.items = @[cancelBar,flexSpaceBar, doneBar];
    [self.mainView addSubview:toolBar];
}

#pragma mark - Notifications

-(void)keyboardWillShow:(NSNotification*)notification{
    if([self isFirstResponder]){

    
    CGRect keyboardRect =
    [[[notification userInfo]
      objectForKey:UIKeyboardFrameBeginUserInfoKey]
     CGRectValue];
    
    float duration =
    [[[notification userInfo]
      objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     floatValue];
        
        
        [self createToolBarWithKeyboardRect:keyboardRect];
    
    __block __weak UIView *mainView = self.mainView;
    [UIView animateWithDuration:duration animations:^{
        CGRect viewFrame = mainView.frame;
        viewFrame.origin.y -= keyboardRect.size.height; //+ CGRectGetHeight(self.frame);
        mainView.frame = viewFrame;
    }];
    }
}

-(void)keyboardWillHide:(NSNotification*)notification {
    if([self isFirstResponder]){
        
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block __weak UIView *mainView = self.mainView;
    [UIView animateWithDuration:duration animations:^{
        CGRect viewFrame = mainView.frame;
        viewFrame.origin.y = 0;
        mainView.frame = viewFrame;
    }];
    }
}

#pragma mark - Actions

-(void)actionClose:(UIBarButtonItem*) sender{
    [self.toolBar removeFromSuperview];
    self.toolBar = nil;
    [self resignFirstResponder];
}

-(void)actionDone:(UIBarButtonItem*) sender{
    [self.toolBar removeFromSuperview];
    self.toolBar = nil;
    [self resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self showCircle];
    return YES;
}
@end

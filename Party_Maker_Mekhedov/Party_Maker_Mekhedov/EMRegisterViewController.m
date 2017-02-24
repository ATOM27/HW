//
//  EMRegisterViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMRegisterViewController.h"
#import "EMHTTPManager.h"
#import "UIViewController+Alert.h"

@interface EMRegisterViewController ()

@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;


@end

NS_ENUM(NSInteger, EMTextFieldType){
    EMTextFieldTypeEmail,
    EMTextFieldTypeName,
    EMTextFieldTypePassword
};

@implementation EMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingsForTextFields];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Help methods

-(void)settingsForTextFields{
    self.registerView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIView* paddingEmailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.emailTextField.leftView = paddingEmailView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView* paddingNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    
    self.nameTextField.leftView = paddingNameView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView* paddingPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    
    self.passwordTextField.leftView = paddingPasswordView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                             }
                                                 ];
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                            }
                                                ];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password"
                                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                                }
                                                    ];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag != EMTextFieldTypePassword){
        [[self.textFieldCollection objectAtIndex:textField.tag+1] becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)actionRegisterTouched:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    if(([self.nameTextField.text isEqualToString:@""]) || ([self.emailTextField.text isEqualToString:@""])){
        [self alertWithTitle:@"All fields are required!" message:@""];
    }else if(self.passwordTextField.text.length < 6){
        [self alertWithTitle:@"Try another password!" message:@"Your password must be at least 6 characters."];
    }else{
        [[EMHTTPManager sharedManager] registerWithEmail:self.emailTextField.text
                                                password:self.passwordTextField.text
                                                    name:self.nameTextField.text
                                              completion:^(NSDictionary *response, NSError *error) {
                                                  if(error){
                                                      NSLog(@"%@",[error localizedDescription]);
                                                  }else{
                                                      if(![response valueForKey:@"error"]){
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          });
                                                      }else{
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self alertWithTitle:@"Ops!" message:@"Try another data."];
                                                          });
                                                      }
                                                  }
                                              }];
    }
    sender.userInteractionEnabled = YES;
}

- (IBAction)actionBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

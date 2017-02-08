//
//  EMLoginViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/6/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMLoginViewController.h"
#import "EMHTTPManager.h";

@interface EMLoginViewController ()

@end

NS_ENUM(NSInteger, EMTextField){
    EMTextFieldLogin,
    EMTextFieldPassword
};

@implementation EMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView* paddingLogginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.loginTextField.leftView = paddingLogginView;
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView* paddingPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];

    self.passwordTextField.leftView = paddingPasswordView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login"
                                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                                  }
                                                      ];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                             }
                                                 ];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == EMTextFieldLogin){
        [self.passwordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Actions

- (IBAction)actionSignInTouched:(UIButton *)sender {
    
    [[EMHTTPManager sharedManager] loginWithName:self.loginTextField.text password:self.passwordTextField.text completion:^(NSDictionary *response, NSError *error) {
        if(error){
            NSLog(@"%@",[error localizedDescription]);
        }else{
            if(![[response valueForKey:@"status"] isEqualToString:@"Failed"]){
                [self performSegueWithIdentifier:@"TabBarIdentifier" sender:self];
            }
        }
    }];
}
@end

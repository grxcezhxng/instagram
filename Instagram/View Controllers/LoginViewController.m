//
//  LoginViewController.m
//  Instagram
//
//  Created by gracezhg on 7/6/21.
//

#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    UIColor const *leftColor = [UIColor colorWithRed:178.0/255.0 green:30.0/255.0 blue:175.0/255.0 alpha:1.0];
    UIColor const *middleColor = [UIColor colorWithRed:193.0/255.0 green:42.0/255.0 blue:111.0/255.0 alpha:1.0];
    UIColor const *rightColor = [UIColor colorWithRed:210.0/255.0 green:61.0/255.0 blue:95.0/255.0 alpha:1.0];
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)leftColor.CGColor, (id)middleColor.CGColor,(id)rightColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

- (IBAction)handleSignup:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self showErrorAlert];
    }
    [self registerUser];
}

- (IBAction)handleLogin:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self showErrorAlert];
    }
    [self loginUser];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // go to TabBarController
            SceneDelegate *delegate = (SceneDelegate *) self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            SceneDelegate *delegate = (SceneDelegate *) self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
        }
    }];
}

- (void) showErrorAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username or password field can not be empty" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    return YES;
}

@end

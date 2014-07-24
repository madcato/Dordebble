//
//  ConfigurationViewController.m
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "TasksTableViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.doneButton setEnabled:NO];

    // Load data from UserInfo
    if ([OSSystem existObjectInConfiguration:@"RedmineConfig"]) {
        NSDictionary* config = (NSDictionary*)[OSSystem loadFromConfig:@"RedmineConfig"];

        self.serverURL.text = config[@"ServerURL"];
        self.userLogin.text = config[@"UserLogin"];
        self.apiKey.text = config[@"APIKey"];
    }

    [self checkDone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self checkDone];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self checkDone];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    [self checkDone];
    return YES;
}

- (void)checkDone {
    if ((![self.serverURL.text isEqualToString:@""])
        && (![self.userLogin.text isEqualToString:@""])
        && (![self.apiKey.text isEqualToString:@""]))
    {
        [self.doneButton setEnabled:YES];
    } else {
        [self.doneButton setEnabled:NO];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Save data in UserInfo
    NSDictionary* config = @{@"ServerURL": self.serverURL.text,
                            @"UserLogin": self.userLogin.text,
                            @"APIKey": self.apiKey.text};

    [OSSystem createObjectInConfiguration:config forKey:@"RedmineConfig"];
    TasksTableViewController* controller = (TasksTableViewController*)segue.destinationViewController;
    controller.config = config;
}

@end

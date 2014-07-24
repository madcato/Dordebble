//
//  ConfigurationViewController.h
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serverURL;
@property (weak, nonatomic) IBOutlet UITextField *userLogin;
@property (weak, nonatomic) IBOutlet UITextField *apiKey;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

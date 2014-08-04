//
//  ConfigTableViewController.h
//  Dordebble
//
//  Created by Daniel Vela on 04/08/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *serverURL;
@property (weak, nonatomic) IBOutlet UITextField *userLogin;
@property (weak, nonatomic) IBOutlet UITextField *apiKey;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

//
//  TimeViewController.h
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeEntry;

@interface TimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *watch;
- (IBAction)cancelPressed:(id)sender;

@property (nonatomic, strong) NSDictionary* issue;

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) NSDate* initialTime;

@property (nonatomic, strong) TimeEntry *managedObject;

@property (nonatomic, strong) UIAlertView *theAlert;

@end

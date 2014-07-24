//
//  TasksTableViewController.h
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary* config;
@property (nonatomic, strong) OSWebRequest* request;

@property (nonatomic,strong) NSArray* issues;

- (IBAction)refresh:(id)sender;
@end

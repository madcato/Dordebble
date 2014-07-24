//
//  TimeViewController.m
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "TimeViewController.h"
#import "AppDelegate.h"
#import "TimeEntry.h"

@interface TimeViewController ()

@end

@implementation TimeViewController

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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    self.initialTime = [NSDate date];

    [self createTimeEntry];
}

- (void)tick {
    NSTimeInterval seconds = [self.initialTime timeIntervalSinceNow];
    seconds = -seconds;
    unsigned int sec = floor(seconds);
    NSString* formatedTime = [NSString stringWithFormat:@"%02u:%02u", sec/60,sec%60];
    self.watch.text = formatedTime;

    if ((seconds / 60) > 25) {
        [self finishTimer];
        [self showAlert];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showAlert {
    self.theAlert = [[UIAlertView alloc] initWithTitle:@"Dordebble"
                                                       message:@"Pomodoro finished."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [self.theAlert show];
}

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)cancelPressed:(id)sender {
    [self finishTimer];
    [self removeTimeEntry];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createTimeEntry {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.managedObject = (TimeEntry*)[NSEntityDescription insertNewObjectForEntityForName:@"TimeEntry" inManagedObjectContext:appDelegate.managedObjectContext];
    assert(self.managedObject != nil);

    self.managedObject.created_at = [NSDate date];
    self.managedObject.issue_id = self.issue[@"id"];

    NSError *error = nil;
    if (![appDelegate.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)removeTimeEntry {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext deleteObject:self.managedObject];
}

@end

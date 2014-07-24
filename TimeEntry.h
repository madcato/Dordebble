//
//  TimeEntry.h
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * issue_id;
@property (nonatomic, retain) NSDate * created_at;

@end

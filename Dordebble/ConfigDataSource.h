//
//  ConfigDataSource.h
//  Dordebble
//
//  Created by Daniel Vela on 04/08/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSStaticTableDataSource.h"

@interface ConfigDataSource : NSObject<OSStaticTableDataSource>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *values;
@end

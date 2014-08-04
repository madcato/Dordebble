//
//  OSStaticTableDataSource.h
//  Dordebble
//
//  Created by Daniel Vela on 04/08/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OSStaticTableDataSource <NSObject>

@required
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)valueForIndexPath:(NSIndexPath *)indexPath;
- (void)setValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;

@optional
- (NSString *)placeholderForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForSection:(NSInteger)section;


@end

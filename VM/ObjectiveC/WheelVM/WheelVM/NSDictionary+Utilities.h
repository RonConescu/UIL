//
//  NSDictionary+Utilities.h
//  WheelVM
//
//  Created by Ron Conescu on 11/4/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utilities)

/**
 Returns YES if the specified dictionary is a
 subclass of NSMutableDictionary.
 */
@property (nonatomic, readonly) BOOL isMutable;

@end

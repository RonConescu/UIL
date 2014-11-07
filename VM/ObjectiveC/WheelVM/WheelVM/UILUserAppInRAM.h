//
//  UILUserAppInRAM.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILFunction.h"

@interface UILUserAppInRAM : NSObject

/**
 These are immutable because I'm going to read
 from them while executing the user program, and
 overwriting them would be basically catastrophic.
 */
@property (nonatomic, strong) NSArray *identifiers;
@property (nonatomic, strong) NSArray *integers;
@property (nonatomic, readonly) NSDictionary *functions;

- (void) setListOfDetectedIdentifiers: (NSArray *) list;
- (void) setListOfDetectedIntegers: (NSArray *) list;
- (void) addDetectedFunction: (UILFunction *) function;
- (void) recomputePubliclyVisibleFunctions;

@end

//
//  UILCodeExecutor.h
//  WheelVM
//
//  Created by Ron Conescu on 11/3/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILUserAppInRAM.h"

@interface UILCodeExecutor : NSObject

- (void) runApp: (UILUserAppInRAM *) app;

@end

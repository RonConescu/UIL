//
//  UILCompiledFileLoader.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILUserAppInRAM.h"


@interface UILCompiledFileLoader : NSObject

+ (UILUserAppInRAM *) loadFromDisk;

@end

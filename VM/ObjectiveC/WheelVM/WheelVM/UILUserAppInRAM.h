//
//  UILUserAppInRAM.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILUserAppInRAM : NSObject

@property (nonatomic, strong) NSMutableArray *identifiers;
@property (nonatomic, strong) NSMutableArray *integers;
@property (nonatomic, strong) NSMutableDictionary *functions;

@end

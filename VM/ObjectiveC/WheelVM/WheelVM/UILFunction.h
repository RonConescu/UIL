//
//  UILFunction.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILFunctionZZZ : NSObject

@property (nonatomic, strong) NSString *Zname;
@property (nonatomic, strong) NSMutableDictionary *ZinboundParameters;
@property (nonatomic, strong) NSMutableDictionary *ZdeclaredParameters;
@property (nonatomic, strong) NSObject *ZreturnValue;
@property (nonatomic, strong) NSMutableArray *Zcode;
@property (nonatomic, strong) NSString *ZassemblyLanguage;
@property (nonatomic, strong) NSData *ZmachineLanguage;

- (id) init;

- (void) generatePackedAssemblyAndMachineLanguage;

@end

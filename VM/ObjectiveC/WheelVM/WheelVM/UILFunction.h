//
//  UILFunction.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILFunction : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *declaredParameterNames;
@property (nonatomic, strong) NSMutableArray *code;
@property (nonatomic, strong) NSString *assemblyLanguage;
@property (nonatomic, strong) NSData *machineLanguage;

- (id) init;

- (void) generatePackedAssemblyAndMachineLanguage;

@end

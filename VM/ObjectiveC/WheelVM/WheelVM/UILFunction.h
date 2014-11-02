//
//  UILFunction.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILFunction : NSObject

@property (nonatomic, strong) NSMutableDictionary *inboundParameters;
@property (nonatomic, strong) NSMutableDictionary *declaredParameters;
@property (nonatomic, strong) NSObject *returnValue;
@property (nonatomic, strong) NSString *assemblyLanguage;
@property (nonatomic, strong) NSMutableData *machineLanguage;

- (id) initWithAssemblyLanguageSectionFromDisk: (NSString *) assemblerCode;

@end

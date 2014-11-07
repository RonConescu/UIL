//
//  UILMethodFrame.h
//  WheelVM
//
//  Created by Ron Conescu on 11/3/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILMethodFrame : NSObject

@property (nonatomic, strong) NSMutableArray *operationStack;
@property (nonatomic, strong) NSMutableDictionary *localVariables;
@property (nonatomic, strong) NSMutableDictionary *declaredParametersAndValues;
@property (nonatomic, strong) NSMutableArray *passedInParameters;

@end

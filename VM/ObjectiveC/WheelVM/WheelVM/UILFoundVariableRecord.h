//
//  UILFoundVariableRecord.h
//  WheelVM
//
//  Created by Ron Conescu on 11/3/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILFoundVariableRecord : NSObject

@property (nonatomic, strong) NSMutableDictionary *mutableDictionaryContainingVariable;
@property (nonatomic, strong) NSDictionary *immutableDictionaryContainingVariable;
@property (nonatomic, strong) NSString *name;	/// variable name.
@property (nonatomic, assign) BOOL isNull;		/// special flag
@property (nonatomic, assign) id value;			/// the thing we're pointing to.  Setting may fail if it's in an immutable dictionary.
@property (nonatomic, readonly) BOOL isSettable;		/// YES if we're using a mutable dictionary.

- (id) init;
- (id) initWithName: (NSString *) variableName;

/**
 Looks through the specified dictionaries in sequence,
 and memorizes the first one containing a value with self.name
 as its key.  If not found, sets isNull to YES.
 */
- (void) setDictionaryBySearchingDictionaries: (NSArray *) dictionaries;

@end

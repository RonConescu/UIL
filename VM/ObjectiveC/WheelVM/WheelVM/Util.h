//
//  Util.h
//  LightMeUp
//
//  Created by Ron Conescu on 10/2/14.
//  Copyright (c) 2014 TheBlackTank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Util : NSObject

/** Clamps value to min and max. */
+ (CGFloat) clampFloat: (CGFloat) value toMin: (CGFloat) min andMax: (CGFloat) max;

/** Clamps value to min and max. */
+ (NSInteger) clampInt: (NSInteger) value toMin: (NSInteger) min andMax: (NSInteger) max;

/** Clamps value to (0, 100). */
+ (NSInteger) clampIntPercent: (NSInteger) value;

/** Clamps value to (0, 1). */
+ (CGFloat) clampFloatPercent: (CGFloat) value;

+ (NSURL *) urlForDocumentsDirectory;

@end

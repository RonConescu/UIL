//
//  UIView+Utilities.h
//  LightMeUp
//
//  Created by Ron Conescu on 9/28/14.
//  Copyright (c) 2014 TheBlackTank. All rights reserved.
//

#import <UIKit/UIKit.h>

/** If you use frameRightChangingWidth or frameBottomChangingHeight
 to accidentally make this view smaller than 0, it'll become this
 width or height. */
#define UIVIEW_UTILITIES_MIN_WIDTH_AND_HEIGHT 10

@interface UIView (Utilities)

@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat frameRight;
@property (nonatomic, assign) CGFloat frameBottom;
@property (nonatomic, assign) CGFloat frameRightChangingWidth;
@property (nonatomic, assign) CGFloat frameBottomChangingHeight;

@end

//
//  UIView+Utilities.m
//  LightMeUp
//
//  Created by Ron Conescu on 9/28/14.
//  Copyright (c) 2014 TheBlackTank. All rights reserved.
//

#import "UIView+Utilities.h"

@implementation UIView (Utilities)

- (CGFloat) frameX { return self.frame.origin.x; }
- (CGFloat) frameY { return self.frame.origin.y; }
- (CGFloat) frameWidth { return self.frame.size.width; }
- (CGFloat) frameHeight { return self.frame.size.height; }
- (CGFloat) frameRight { return self.frameX + self.frameWidth; }
- (CGFloat) frameBottom { return self.frameY + self.frameHeight; }
- (CGFloat) frameRightChangingWidth { return self.frameRight; }
- (CGFloat) frameBottomChangingHeight { return self.frameBottom; }

- (void) setFrameX: (CGFloat) frameX
{
	CGRect frame = self.frame;
	frame.origin.x = frameX;
	self.frame = frame;
}

- (void) setFrameY: (CGFloat) frameY
{
	CGRect frame = self.frame;
	frame.origin.y = frameY;
	self.frame = frame;
}

- (void) setFrameWidth: (CGFloat) frameWidth
{
	CGRect frame = self.frame;
	frame.size.width = frameWidth;
	self.frame = frame;
}

- (void) setFrameHeight: (CGFloat) frameHeight
{
	CGRect frame = self.frame;
	frame.size.height = frameHeight;
	self.frame = frame;
}

- (void) setFrameRight: (CGFloat) frameRight
{
	CGFloat diff = frameRight - self.frameRight;
	self.frameX += diff;
}

- (void) setFrameBottom: (CGFloat) frameBottom
{
	CGFloat diff = frameBottom - self.frameBottom;
	self.frameY += diff;
}

- (void) setFrameRightChangingWidth: (CGFloat) frameRightChangingWidth
{
	CGFloat diff = frameRightChangingWidth - self.frameRight;
	CGRect frame = self.frame;
	frame.origin.x += diff;
	frame.size.width -= diff;
	if (frame.size.width < 0) frame.size.width = UIVIEW_UTILITIES_MIN_WIDTH_AND_HEIGHT;
	self.frame = frame;
}

- (void) setFrameBottomChangingHeight: (CGFloat) frameBottomChangingHeight
{
	CGFloat diff = frameBottomChangingHeight - self.frameBottom;
	CGRect frame = self.frame;
	frame.origin.y += diff;
	frame.size.height -= diff;
	if (frame.size.height < 0) frame.size.height = UIVIEW_UTILITIES_MIN_WIDTH_AND_HEIGHT;
	self.frame = frame;
}

@end

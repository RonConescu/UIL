//
//  ViewController.m
//  WheelVM
//
//  Created by Ron Conescu on 11/1/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "ViewController.h"
#import "UILUserAppInRAM.h"
#import "UILCompiledFileLoader.h"
#import "UILCodeExecutor.h"

@implementation ViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	NSLog (@"ViewController: trying to load app...");
	UILUserAppInRAM *app = [[UILCompiledFileLoader new] loadFromDisk];
	NSLog (@"ViewController: ...done.  What happened?  App = %@", app);

	NSLog (@"ViewController: Let's run the app!");
	UILCodeExecutor *executor = [UILCodeExecutor new];
	[executor runApp: app];
	NSLog (@"ViewController: ...what happened?");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

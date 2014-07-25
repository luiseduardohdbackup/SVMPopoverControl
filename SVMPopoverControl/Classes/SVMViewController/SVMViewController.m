//
//  SVMViewController.m
//  SVMPopoverControl
//
//  Created by staticVoidMan on 26/07/14.
//  Copyright (c) 2014 svmLogics. All rights reserved.
//

#import "SVMViewController.h"
#import "SVMPopoverControl.h"

@interface SVMViewController ()

@end

@implementation SVMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)btnTestAct:(UIButton *)sender
{
    SVMPopoverControl *popOver = [[SVMPopoverControl alloc] initWithNibName:@"SVMPopoverControl" bundle:nil];
    [self addChildViewController:popOver];
    [popOver didMoveToParentViewController:self];
    [popOver.view setFrame:self.view.bounds];
    [self.view addSubview:popOver.view];

    [popOver showPopoverFromRect:sender.frame];
}

@end

//
//  SVMViewController.m
//  SVMPopoverControl
//
//  Created by staticVoidMan on 26/07/14.
//  Copyright (c) 2014 svmLogics. All rights reserved.
//

#import "SVMViewController.h"
#import "SVMPopoverControl.h"

@interface SVMViewController () <SVMPopoverDelegate>

@end

@implementation SVMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)btnTestAct:(UIButton *)sender
{
    SVMPopoverControl *popOver = [[SVMPopoverControl alloc] initWithDelegate:self
                                                                cancelButton:@"Cancel"
                                                             andActionButton:@"Action"];
    [popOver setTag:0];

    [self addChildViewController:popOver];
    [popOver didMoveToParentViewController:self];
    [popOver.view setFrame:self.view.bounds];
    [self.view addSubview:popOver.view];

    [popOver showPopoverFromRect:sender.frame];
}

#pragma mark - SVMPopover Delegate
-(void)svmPopover:(SVMPopoverControl *)svmPopover clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (svmPopover.tag == 0) {
        switch (buttonIndex) {
            case 0: {   //cancel
                NSLog(@"Cancel");

                break;
            }
            case 1: {   //ok
                NSLog(@"Action");

                break;
            }
        }
    }
}

@end

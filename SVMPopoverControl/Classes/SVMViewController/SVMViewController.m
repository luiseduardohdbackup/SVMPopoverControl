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
    SVMPopoverControl *popOver = [[SVMPopoverControl alloc] initInView:self
                                                              delegate:self
                                                          cancelButton:@"Cancel"
                                                           otherButton:@"Action"];
    [popOver setTag:100];
    [popOver showPopoverFromView:sender];
}

#pragma mark - SVMPopover Delegate
-(void)svmPopover:(SVMPopoverControl *)svmPopover clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (svmPopover.tag == 100) {
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

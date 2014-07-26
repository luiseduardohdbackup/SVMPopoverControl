//
//  SVMPopoverControl.h
//  SVMPopoverControl
//
//  Created by staticVoidMan on 26/07/14.
//  Copyright (c) 2014 svmLogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVMPopoverControl;
@protocol SVMPopoverDelegate <NSObject>
@optional
-(void)svmPopover:(SVMPopoverControl *)svmPopover clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface SVMPopoverControl : UIViewController

@property (nonatomic, weak) id <SVMPopoverDelegate> svmDelegate;
@property (assign) NSInteger tag;

-(id)initInView:(UIViewController *)mainView delegate:(id)delegate cancelButton:(NSString *)cancel otherButton:(NSString *)action;
-(void)showPopoverFromView:(UIView *)view;
-(void)hide;
@end

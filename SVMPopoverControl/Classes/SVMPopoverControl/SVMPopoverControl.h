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

-(id)initWithDelegate:(id)delegate cancelButton:(NSString *)cancel andActionButton:(NSString *)action;
-(void)showPopoverFromRect:(CGRect)rect;
-(void)hide;
@end

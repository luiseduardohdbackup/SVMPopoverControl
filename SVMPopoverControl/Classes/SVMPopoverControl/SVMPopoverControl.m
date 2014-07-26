//
//  SVMPopoverControl.m
//  SVMPopoverControl
//
//  Created by staticVoidMan on 26/07/14.
//  Copyright (c) 2014 svmLogics. All rights reserved.
//

#import "SVMPopoverControl.h"
#define k_ANIMATION_DURATION    0.26
#define k_POPOVER_HEIGHT_FINAL  180
#define k_POPOVER_HEIGHT_START  83

@interface SVMPopoverControl ()
{
    IBOutlet UIButton *btnDismiss;

    IBOutlet UIView *vwPopover;
    IBOutlet UIView *popoverView;

    IBOutlet UIView *vwBarTop;
    IBOutlet UIView *vwBarBottom;
    IBOutlet UIView *vwButtonContainer;

    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnAction;

    IBOutlet NSLayoutConstraint *constraintPopover_Top;
    IBOutlet NSLayoutConstraint *constraintPopover_Height;

    IBOutlet NSLayoutConstraint *constraintButtonContainer_Height;
    IBOutlet NSLayoutConstraint *constraintButtonCancel_Width;
    IBOutlet NSLayoutConstraint *constraintButtonAction_Width;

    NSMutableArray *arr2Button;
}
@end

@implementation SVMPopoverControl
@synthesize svmDelegate;
@synthesize tag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initInView:(UIViewController *)mainView delegate:(id)delegate cancelButton:(NSString *)cancel otherButton:(NSString *)action
{
    self = [self initWithNibName:@"SVMPopoverControl" bundle:nil];
    if (self) {
        if (mainView) {
            [mainView addChildViewController:self];
            [mainView.view addSubview:self.view];
            [self didMoveToParentViewController:mainView];
            [self.view setFrame:[UIScreen mainScreen].bounds];
        }
        else {
            return nil;
        }
        
        if (delegate) {
            svmDelegate = delegate;
        }

        arr2Button = [[NSMutableArray alloc] init];
        if (cancel) {
            [arr2Button addObject:@{@"title":cancel,
                                    @"isCancel":@(YES)}];
        }
        
        if (action) {
            [arr2Button addObject:@{@"title":action,
                                    @"isCancel":@(NO)}];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)modifyUI
{
    [vwBarTop.layer setMasksToBounds:YES];
    [vwBarBottom.layer setMasksToBounds:YES];
}

#pragma mark - Popover methods
-(void)showPopoverFromView:(UIView *)view
{
    //get view's main screen relative rect
    CGRect rect = [[[UIApplication sharedApplication] keyWindow] convertRect:view.bounds
                                                                    fromView:view];
    [self drawPopoverFromRect:rect withCornerRadius:12.0f];
}

-(void)hide
{
    [self btnDismissAct:btnDismiss];
}

#pragma mark - Button Methods
-(IBAction)btnDismissAct:(UIButton *)sender
{
    [UIView animateWithDuration:k_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

-(IBAction)btnAct:(UIButton *)sender
{
    if ([svmDelegate respondsToSelector:@selector(svmPopover:clickedButtonAtIndex:)]) {
        NSLog(@"delegated %d",sender.tag);
        [svmDelegate svmPopover:self clickedButtonAtIndex:sender.tag];

        [self btnDismissAct:btnDismiss];
    }
}

#pragma mark - Draw Methods
-(void)handleButtons
{
    if (arr2Button.count == 0) {
        constraintButtonContainer_Height.constant = 0;
        [vwPopover layoutIfNeeded];
        [vwButtonContainer setHidden:YES];
        return;
    }

    if (arr2Button.count == 1) {
        if ([arr2Button[0][@"isCancel"] boolValue]) {
            [btnCancel setTitle:arr2Button[0][@"title"] forState:UIControlStateNormal];
            constraintButtonAction_Width.constant = 0;
            constraintButtonCancel_Width.constant = constraintButtonCancel_Width.constant*2;
            [vwButtonContainer layoutIfNeeded];
        }
        else {
            [btnAction setTitle:arr2Button[0][@"title"] forState:UIControlStateNormal];
            constraintButtonCancel_Width.constant = 0;
            constraintButtonAction_Width.constant = constraintButtonAction_Width.constant*2;
            [vwButtonContainer layoutIfNeeded];
        }
    }
    else {
        [btnCancel setTitle:arr2Button[0][@"title"] forState:UIControlStateNormal];
        [btnAction setTitle:arr2Button[1][@"title"] forState:UIControlStateNormal];
    }
}

-(void)drawPopoverFromRect:(CGRect)rect withCornerRadius:(CGFloat)r
{
    //initial height
    constraintPopover_Height.constant = k_POPOVER_HEIGHT_START;

    //modify popover depending on buttons
    [self handleButtons];

    //draw appropriate popover
    if (rect.origin.y + rect.size.height + vwPopover.frame.origin.y + k_POPOVER_HEIGHT_FINAL < self.view.frame.size.height) {
        //rect fits above popover
        CGFloat startY = rect.origin.y + rect.size.height;

        //draw popover
        [vwBarTop.layer setMask:[self getLayerForTopBarWithCornerRadius:r
                                                              startingX:(rect.origin.x + (rect.size.width/2))-vwPopover.frame.origin.x
                                                              startingY:startY]];
        [vwBarBottom.layer setMask:[self getLayerForBottomBarWithCornerRadius:r]];
        
        //initial popover frame
        constraintPopover_Top.constant = startY + 2;
        [self.view layoutIfNeeded];
    }
    else {
        //rect fits below popover
        CGFloat startY = rect.origin.y;

        //draw popover
        [vwBarTop.layer setMask:[self getLayerForTopBarWithCornerRadius:r]];
        [vwBarBottom.layer setMask:[self getLayerForBottomBarWithCornerRadius:r
                                                                    startingX:(rect.origin.x + (rect.size.width/2))-vwPopover.frame.origin.x
                                                                    startingY:startY]];
        
        //initial popover frame
        constraintPopover_Top.constant = startY - k_POPOVER_HEIGHT_START - 2;
        [self.view layoutIfNeeded];
        constraintPopover_Top.constant = rect.origin.y - k_POPOVER_HEIGHT_FINAL - 2;
    }

    [self.view setAlpha:0.0f];
    //animate popover
    constraintPopover_Height.constant = k_POPOVER_HEIGHT_FINAL;
    [UIView animateWithDuration:k_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view setAlpha:1.0f];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

-(CAShapeLayer *)getLayerForTopBarWithCornerRadius:(CGFloat)r startingX:(NSInteger)startX startingY:(NSInteger)startY
{
    CGRect      rect = vwBarTop.bounds;

    CGFloat     w = rect.size.width;
    CGFloat     h = rect.size.height;
    NSInteger   x = startX;
    NSInteger   y = 0;

    CGPoint point_1_Start   = CGPointMake(x, y);
    CGPoint point_2_Line    = CGPointMake(x-r, r);
    CGPoint point_3_Line    = CGPointMake(r, r);
    CGPoint point_4_Arc     = CGPointMake(r, h);
    CGPoint point_5_Line    = CGPointMake(w, h);
    CGPoint point_6_Arc     = CGPointMake(w-r, h);
    CGPoint point_7_Line    = CGPointMake(x+r, r);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:point_1_Start];
    [path addLineToPoint:point_2_Line];
    [path addLineToPoint:point_3_Line];
    [path addArcWithCenter:point_4_Arc
                    radius:r
                startAngle:3 * M_PI_2
                  endAngle:M_PI
                 clockwise:NO];
    [path addLineToPoint:point_5_Line];
    [path addArcWithCenter:point_6_Arc
                    radius:r
                startAngle:2 * M_PI
                  endAngle:3 * M_PI_2
                 clockwise:NO];
    [path addLineToPoint:point_7_Line];
    [path closePath];
    
    return [self getLayerWithPath:path andRect:rect];
}

-(CAShapeLayer *)getLayerForBottomBarWithCornerRadius:(CGFloat)r startingX:(NSInteger)startX startingY:(NSInteger)startY
{
    CGRect      rect = vwBarBottom.bounds;

    CGFloat     w = rect.size.width;
    CGFloat     h = rect.size.height;
    NSInteger   x = startX;
    NSInteger   y = h;

    CGPoint point_1_Start   = CGPointMake(x, y);
    CGPoint point_2_Line    = CGPointMake(x+r, r);
    CGPoint point_3_Line    = CGPointMake(w-r, r);
    CGPoint point_4_Arc     = CGPointMake(w-r, 0);
    CGPoint point_5_Line    = CGPointMake(r, 0);
    CGPoint point_6_Arc     = point_5_Line;
    CGPoint point_7_Line    = CGPointMake(x-r, r);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:point_1_Start];
    [path addLineToPoint:point_2_Line];
    [path addLineToPoint:point_3_Line];
    [path addArcWithCenter:point_4_Arc
                    radius:r
                startAngle:M_PI_2
                  endAngle:2 * M_PI
                 clockwise:NO];
    [path addLineToPoint:point_5_Line];
    [path addArcWithCenter:point_6_Arc
                    radius:r
                startAngle:M_PI
                  endAngle:M_PI_2
                 clockwise:NO];
    [path addLineToPoint:point_7_Line];
    [path closePath];

    return [self getLayerWithPath:path andRect:rect];
}

-(CAShapeLayer *)getLayerForTopBarWithCornerRadius:(CGFloat)r
{
    CGRect rect = vwBarTop.bounds;

    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;

    CGPoint point_1_Arc     = CGPointMake(r, h);
    CGPoint point_2_Line    = CGPointMake(w, h);
    CGPoint point_3_Arc     = CGPointMake(w-r, h);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:point_1_Arc
                    radius:r
                startAngle:3 * M_PI_2
                  endAngle:M_PI
                 clockwise:NO];
    [path addLineToPoint:point_2_Line];
    [path addArcWithCenter:point_3_Arc
                    radius:r
                startAngle:2 * M_PI
                  endAngle:3 * M_PI_2
                 clockwise:NO];
    [path closePath];

    return [self getLayerWithPath:path andRect:rect];
}

-(CAShapeLayer *)getLayerForBottomBarWithCornerRadius:(CGFloat)r
{
    CGRect rect = vwBarBottom.bounds;

    CGFloat w = rect.size.width;

    CGPoint point_1_Arc     = CGPointMake(r, 0);
    CGPoint point_2_Line    = CGPointMake(w-r, r);
    CGPoint point_3_Arc     = CGPointMake(w-r, 0);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:point_1_Arc
                    radius:r
                startAngle:M_PI
                  endAngle:M_PI_2
                 clockwise:NO];
    [path addLineToPoint:point_2_Line];
    [path addArcWithCenter:point_3_Arc
                    radius:r
                startAngle:M_PI_2
                  endAngle:2 * M_PI
                 clockwise:NO];
    [path closePath];

    return [self getLayerWithPath:path andRect:rect];
}

-(CAShapeLayer *)getLayerWithPath:(UIBezierPath *)path andRect:(CGRect)rect
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:rect];
    [layer setPath:path.CGPath];

    return layer;
}
@end

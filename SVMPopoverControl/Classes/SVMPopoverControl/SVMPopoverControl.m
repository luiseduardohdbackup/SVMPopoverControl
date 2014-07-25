//
//  SVMPopoverControl.m
//  SVMPopoverControl
//
//  Created by staticVoidMan on 26/07/14.
//  Copyright (c) 2014 svmLogics. All rights reserved.
//

#import "SVMPopoverControl.h"
#define k_POPOVER_HEIGHT_FINAL  180
#define k_POPOVER_HEIGHT_START  48

@interface SVMPopoverControl ()
{
    IBOutlet UIView *vwPopOver;
    IBOutlet UIButton *btnDismiss;

    IBOutlet NSLayoutConstraint *constraintTop;
    IBOutlet NSLayoutConstraint *constraintHeight;

    IBOutlet UIView *vwBarTop;
    IBOutlet UIView *vwBarBottom;
}
@end

@implementation SVMPopoverControl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Popover methods
-(void)showPopoverFromRect:(CGRect)rect
{
    constraintHeight.constant = k_POPOVER_HEIGHT_START;
    [self.view layoutIfNeeded];

    [self drawPopoverFromRect:rect withCornerRadius:12.0f];
}

#pragma mark - Button Methods
-(IBAction)btnDismissAct:(UIButton *)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - Popover Delegate Methods

#pragma mark - Draw Methods
-(void)drawPopoverFromRect:(CGRect)rect withCornerRadius:(CGFloat)r
{
    if (rect.origin.y + rect.size.height + vwPopOver.frame.origin.y + k_POPOVER_HEIGHT_FINAL < self.view.frame.size.height) {
        //rect fits above popover
        CGFloat startY = rect.origin.y + rect.size.height;

        //draw popover
        [vwBarTop.layer setMask:[self drawTopBarWithCornerRadius:r
                                                       startingX:(rect.origin.x + (rect.size.width/2))-vwPopOver.frame.origin.x
                                                       startingY:startY]];
        [vwBarBottom.layer setMask:[self drawBottomBarWithCornerRadius:r]];

        //initial popover frame
        constraintTop.constant = startY + 2;
        [self.view layoutIfNeeded];
    }
    else {
        //rect fits below popover
        CGFloat startY = rect.origin.y;

        //draw popover
        [vwBarTop.layer setMask:[self drawTopBarWithCornerRadius:r]];
        [vwBarBottom.layer setMask:[self drawBottomBarWithCornerRadius:r
                                                             startingX:(rect.origin.x + (rect.size.width/2))-vwPopOver.frame.origin.x
                                                             startingY:startY]];

        //initial popover frame
        constraintTop.constant = startY - k_POPOVER_HEIGHT_START - 2;
        [self.view layoutIfNeeded];
        constraintTop.constant = rect.origin.y - k_POPOVER_HEIGHT_FINAL - 2;
    }

    //animate popover
    constraintHeight.constant = k_POPOVER_HEIGHT_FINAL;
    [UIView animateWithDuration:0.26
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

-(CAShapeLayer *)drawTopBarWithCornerRadius:(CGFloat)r startingX:(NSInteger)startX startingY:(NSInteger)startY
{
    CGRect      rect = vwBarTop.bounds;

    CGFloat     w = rect.size.width;
    CGFloat     h = rect.size.height;
    NSInteger   x = startX;
    NSInteger   y = 0;

    CGPoint point_1_Start   = CGPointMake(x, y);
    CGPoint point_2_Line    = CGPointMake(x - r, r);
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

    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:rect];
    [layer setPath:path.CGPath];

    [vwBarTop.layer setMasksToBounds:YES];
    
    return layer;
}

-(CAShapeLayer *)drawBottomBarWithCornerRadius:(CGFloat)r startingX:(NSInteger)startX startingY:(NSInteger)startY
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

    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:rect];
    [layer setPath:path.CGPath];

    [vwBarTop.layer setMasksToBounds:YES];
    
    return layer;
}

-(CAShapeLayer *)drawTopBarWithCornerRadius:(CGFloat)r
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

    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:rect];
    [layer setPath:path.CGPath];

    [vwBarTop.layer setMasksToBounds:YES];

    return layer;
}

-(CAShapeLayer *)drawBottomBarWithCornerRadius:(CGFloat)r
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

    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:rect];
    [layer setPath:path.CGPath];

    [vwBarBottom.layer setMasksToBounds:YES];
    
    return layer;
}

@end

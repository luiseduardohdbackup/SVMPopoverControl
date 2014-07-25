//
//  SVMPopoverControl.m
//  SVMPopoverControl
//
//  Created by staticVoidMan on 26/07/14.
//  Copyright (c) 2014 svmLogics. All rights reserved.
//

#import "SVMPopoverControl.h"

@interface SVMPopoverControl ()
{
    IBOutlet UIView *vwPopOver;
    IBOutlet UIButton *btnDismiss;

    IBOutlet NSLayoutConstraint *constraintTop;
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

-(void)showPopoverFrom:(CGRect)rect
{
    [vwPopOver.layer setMask:[self createPopOverLayerOn:vwPopOver
                                       withCornerRadius:12.0f
                                              startingX:(rect.origin.x + (rect.size.width/2))-vwPopOver.frame.origin.x
                                              startingY:rect.origin.y + rect.size.height]];
}

-(IBAction)btnDismissAct:(UIButton *)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(CAShapeLayer *)createPopOverLayerOn:(UIView *)view withCornerRadius:(CGFloat)r startingX:(NSInteger)startX startingY:(NSInteger)startY
{
    constraintTop.constant = startY + 2;
    [self.view layoutIfNeeded];

    CGRect rect = view.bounds;

    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;

    NSInteger x = startX;
    NSInteger y = 0;

    CGPoint point_1_Line    = CGPointMake(x, y);
    CGPoint point_2_Line    = CGPointMake(x - (r/2), r/2);
    CGPoint point_3_Line    = CGPointMake(r, r/2);
    CGPoint point_4_Arc     = CGPointMake(r, 3*(r/2));
    CGPoint point_5_Line    = CGPointMake(0, h-r);
    CGPoint point_6_Arc     = CGPointMake(r, h-r);
    CGPoint point_7_Line    = CGPointMake(w-r, h);
    CGPoint point_8_Arc     = CGPointMake(w-r, h-r);
    CGPoint point_9_Line    = CGPointMake(w, 3*(r/2));
    CGPoint point_10_Arc    = CGPointMake(w-r, 3*(r/2));
    CGPoint point_11_Line   = CGPointMake(x+(r/2), r/2);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:point_1_Line];
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
                startAngle:M_PI
                  endAngle:M_PI_2
                 clockwise:NO];
    [path addLineToPoint:point_7_Line];
    [path addArcWithCenter:point_8_Arc
                    radius:r
                startAngle:M_PI_2
                  endAngle:2 * M_PI
                 clockwise:NO];
    [path addLineToPoint:point_9_Line];
    [path addArcWithCenter:point_10_Arc
                    radius:r
                startAngle:2 * M_PI
                  endAngle:3 * M_PI_2
                 clockwise:NO];
    [path addLineToPoint:point_11_Line];

    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:rect];
    [layer setPath:path.CGPath];

    [vwPopOver.layer setMasksToBounds:YES];

    return layer;
}

@end

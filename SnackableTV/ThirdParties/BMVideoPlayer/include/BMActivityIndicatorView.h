//
//  BMActivityIndicatorView.h
//  BMCustomSpinner
//
//  Created by Jorge Valbuena on 2016-01-25.
//  Copyright © 2016 BellMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMActivityIndicatorType.h"


@interface BMActivityIndicatorView : UIView

/**
 The spinner main brand color.
 */
@property (nonatomic, strong) UIColor *color;


/**
 The type of activity indicator.
 */
@property (nonatomic, assign) BMActivityIndicatorType indicatorType;


/**
 Creates a instance of @a BMActivityIndicatorView with specified frame, color and type.
 
 @param frame
    The frame where the indicator will be drawn.
 @param color
    The color of the indicator.
 @param type
    The type of activity indicator.
 
 @return
    An instancetype of @a BMActivityIndicatorView.
 */
+ (BMActivityIndicatorView *)activityIndicatorWithFrame:(CGRect)frame color:(UIColor *)color type:(BMActivityIndicatorType)type;


/**
 Tells if the spinner is animating or not. The subclass should implement this method.
 
 @return
    A BOOL if the spinner is animating or not.
 */
- (BOOL)isAnimating;


/**
 Triggers the spinner to start animating. The subclass should implement this method.
 */
- (void)startAnimating;


/**
 Triggers the spinner to stop animating. The subclass should implement this method.
 */
- (void)stopAnimating;

@end

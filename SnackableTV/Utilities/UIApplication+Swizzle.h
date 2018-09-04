//
//  UIApplication+Swizzle.h
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-20.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Swizzle)

// swizzle so when framework try to hide status bar, it does not nothing
-(void)swizzleStatusBar;
@end

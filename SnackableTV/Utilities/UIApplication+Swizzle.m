//
//  UIApplication+Swizzle.m
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-20.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

#import "UIApplication+Swizzle.h"
#import <objc/runtime.h>

@implementation UIApplication (Swizzle)

-(void)swizzleStatusBar {
    Class class = [self class];
    
    SEL originalSelector = @selector(setStatusBarHidden:);
    SEL swizzledSelector = @selector(newSetStatusBarHidden:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

-(void) newSetStatusBarHidden:(BOOL)hidden {
    NSLog(@"reach ac");
}
@end

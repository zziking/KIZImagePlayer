//
//  KIZImageScrollViewWeakTarget.m
//  KIZImagePlayer
//
//  Created by kingizz on 15/10/22.
//  Copyright © 2015年 kingizz. All rights reserved.
//

#import "KIZTimerWeakTarget.h"

@implementation KIZTimerWeakTarget{
    __weak id _target;
    SEL _selector;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)sel{
    self = [super init];
    if (self) {
        _target = target;
        _selector = sel;
    }
    return self;
}

- (void)timerDidFire:(NSTimer *)timer
{
    if(_target)
    {
        [_target performSelector:_selector withObject:timer];
    }
    else
    {
        [timer invalidate];
    }
}

@end

//
//  KIZImageScrollViewWeakTarget.h
//  KIZImagePlayer
//
//  Created by kingizz on 15/10/22.
//  Copyright © 2015年 kingizz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KIZTimerWeakTarget : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)sel;

- (void)timerDidFire:(NSTimer *)timer;

@end

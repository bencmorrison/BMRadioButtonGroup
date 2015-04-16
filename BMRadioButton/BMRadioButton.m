//
//  BMRadioButton.m
//  BMRadioButtonGroup
//
//  Created by Ben Morrison on 4/8/15.
//  Copyright (c) 2015 Benjamin Morrison. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#import "BMRadioButton.h"

static const CGFloat filledStartSize = 2.0f;

@interface BMRadioButton()
/// The view that is being used to fill in the button when pressed
@property (nonatomic, strong) UIView *filledView;

- (void)prepareRadioButton;
- (void)buttonWasPressed:(BMRadioButton *)sender;

- (void)fillInRadioButton;
- (void)unFillInRadioButton;

@end


@implementation BMRadioButton

#pragma mark - Initalizers
- (instancetype)init {
    self = [super init];

    if (self != nil) {
        [self prepareRadioButton];
    }

    return self;
}



- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    if (self != nil) {
        [self prepareRadioButton];
    }

    return self;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self != nil) {
        [self prepareRadioButton];
    }

    return self;
}


/**
* `prepareRadioButton` prepares the radio button for display.
*
* @warning ONLY CALL IN INIT FUNCTIONS
*/
- (void)prepareRadioButton {
    self.layer.cornerRadius = self.frame.size.height / 2.0f;
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderWidth = 2.0f;

    self.filledView = [[UIView alloc] init];

    self.filledView.frame = CGRectMake(0.0f, 0.0f, filledStartSize, filledStartSize);
    self.filledView.layer.cornerRadius = filledStartSize / 2.0f;
    self.filledView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    self.filledView.hidden = YES;
    self.filledView.userInteractionEnabled = NO;
    self.filledView.backgroundColor = self.tintColor;
    [self addSubview:self.filledView];

    self.pressedAnimationDuration = 0.25f;
    
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateDisabled];
    [self setTitle:@"" forState:UIControlStateHighlighted];
    [self setTitle:@"" forState:UIControlStateSelected];

    [self addTarget:self
             action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
}


/**
* `buttonWasPressed:` is triggered when the radio button receives a UIControlEventTouchUpInside trigger.
*
* @param sender The button that is receiving the touch event.
*/
- (void)buttonWasPressed:(BMRadioButton *)sender {
    self.pressed = !self.pressed;
}



#pragma mark - Drawing

/**
* `fillInRadioButton` fills in the radio button when it is transitioning to the pressed state.
*/
- (void)fillInRadioButton {
    if (!self.filledView.hidden) {
        return;
    }

    CGFloat scale = (self.frame.size.height - 8.0f) / self.filledView.frame.size.height;

    self.filledView.hidden = NO;

    [UIView animateWithDuration:self.pressedAnimationDuration
                     animations:^{
                         self.filledView.transform = CGAffineTransformMakeScale(scale, scale);
                     }
                     completion:^(BOOL finished) {

                     }];
}


/**
* `unFillInRadioButton` unfills in the radio button when it is transitioning to the unpressed state.
*/
- (void)unFillInRadioButton {
    if (self.filledView.hidden) {
        return;
    }

    [UIView animateWithDuration:self.pressedAnimationDuration
                     animations:^{
                         self.filledView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         if (!finished) {
                             self.transform = CGAffineTransformIdentity;
                         }

                         self.filledView.hidden = YES;
                     }];
}



#pragma mark - Overrides
- (void)setPressed:(BOOL)pressed {
    BOOL shouldChangeState = YES;

    if ([self.delegate respondsToSelector:@selector(shouldChangeStateForButton:)]) {
        shouldChangeState = [self.delegate shouldChangeStateForButton:self];
    }

    if (shouldChangeState) {
        _pressed = pressed;

        if (pressed) {
            // Fill In Center
            [self fillInRadioButton];

        } else {
            // Unfill In Center
            [self unFillInRadioButton];
        }

    }
}



- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];

    if (self.filledView != nil) {
        self.filledView.backgroundColor = tintColor;
        self.layer.borderColor = tintColor.CGColor;
    }
}



- (void)setFrame:(CGRect)frame {
    if (frame.size.height != frame.size.width) {
        frame.size.width = frame.size.height;
    }

    [super setFrame:frame];
}


@end

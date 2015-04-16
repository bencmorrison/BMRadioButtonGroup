//
//  BMRadioButton.h
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

#import <UIKit/UIKit.h>

@class BMRadioButton;

@protocol BMRadioButtonDelegate <NSObject>
@optional
/**
* Optional Protocol Method that allows the prevention of state change for a button.
*   State change is defined as going from pressed to unpressed or vis a versa.
*   If the method is not implemented the button will change state.
*
* @param button The button that is asking if it should change state.
*
* @return YES if the button should change state, and NO if the button should not change state.
*/
- (BOOL)shouldChangeStateForButton:(BMRadioButton *)button;
@end



/**
* `BMRadioButton` is a subclass of UIButton. BMRadioButton creates a radio button from a UIButton, that is Label-less.
* BMRadioButton can be used by itself or with BMRadioButtonGroup.
*
* When the delegate is set and conforms to the BMRadioButtonDelegate protocol, the state change of the button can be
* managed outside of the radio button class.
*
* ##Terminology
* * State - Generic term for if the button is pressed or unpressed, used when pressed or unpressed does not matter in discussion.
* * Pressed - This is the 'selected' state. Also called filled in state.
* * Unpressed - This is the 'deselected' state. Also called unfilled in state.
*
* @warning Frames that are not squares will have the width changed to the height dimension, making it square.
*/

@interface BMRadioButton : UIButton

/// Optional, when the delegate responds to shouldChangeStateForButton: it can prevent the button from being pressed or unpressed
@property (nonatomic, weak) id<BMRadioButtonDelegate> delegate;
/// The state of press (selection) for the Radio Button. YES is pressed, NO is not pressed
@property (nonatomic, assign, setter=setPressed:) BOOL pressed;
/// The default fill and unfill animation duration is 0.25f, set this to override the animation durations.
@property (nonatomic, assign) CGFloat pressedAnimationDuration;

- (instancetype)init;
- (instancetype)initWithCoder:(NSCoder *)coder;
- (instancetype)initWithFrame:(CGRect)frame;

@end

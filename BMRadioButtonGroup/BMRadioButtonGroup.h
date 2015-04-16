//
//  BMRadioButtonGroup.h
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

#import <Foundation/Foundation.h>

NS_ENUM(NSUInteger , BMRadioButtonGroupSelectionType) {
    BMRadioButtonGroupSelectionSingle = 0, // Default
    BMRadioButtonGroupSelectionMultiple
};


@class BMRadioButton;
@class BMRadioButtonGroup;

@protocol BMRadioButtonGroupDelegate <NSObject>
@optional
/**
* `didPressRadioButtonAtIndex:forRadioGroup:` is called with the button has moved to the pressed state.
*
* @param index The index of the button that was moved to the pressed state.
* @param radioButtonGroup The BMRadioButtonGroup that received the event.
*/
- (void)didPressRadioButtonAtIndex:(NSUInteger)index forRadioGroup:(BMRadioButtonGroup *)radioButtonGroup;
/**
* `didUnpressRadioButtonAtIndex:forRadioGroup:` is called with the button has moved to the unpressed state.
*
* @param index The index of the button that was moved to the unpressed state.
* @param radioButtonGroup The BMRadioButtonGroup that received the event.
*/
- (void)didUnpressRadioButtonAtIndex:(NSUInteger)index forRadioGroup:(BMRadioButtonGroup *)radioButtonGroup;

@end


/**
* `BMRadioButtonGroup` is an object dedicated to managing a group of BMRadioButtons.
*
* When the delegate has been set and conforms to the BMRadioButtonGroupDelegate protocol, further action can be taken
* when a radio button is changed from pressed or unpressed states.
*
* ##Terminology
* * State - Generic term for if the button is pressed or unpressed, used when pressed or unpressed does not matter in discussion.
* * Pressed - This is the 'selected' state. Also called filled in state.
* * Unpressed - This is the 'deselected' state. Also called unfilled in state.
*
* @see BMRadioButton class definition for more details.
*/

@interface BMRadioButtonGroup : NSObject

/// The delegate that will respond to the protocol : BMRadioButtonGroupDelegate
@property (nonatomic, weak) id<BMRadioButtonGroupDelegate> delegate;
/// The selection type for the group. Single or Multiple selections allowed in the group.
@property (nonatomic, assign) enum BMRadioButtonGroupSelectionType selectionType;
/// Keep one button pressed. YES will not allow all to be unpressed and NO will allow all to be unpressed
@property (nonatomic, assign) BOOL keepOnePressed;

- (instancetype)initWithSelectionType:(enum BMRadioButtonGroupSelectionType)selectionType;

- (void)addRadioButtonToGroup:(BMRadioButton *)radioButton;
- (void)addRadioButtonsToGroupInArray:(NSArray *)radioButtonArray;

- (void)removeRadioButtonFromGroup:(BMRadioButton *)radioButton;
- (void)removeRadioButtonsFromGroupInArray:(NSArray *)radioButtonArray;

- (void)setDefaultPressedButtons:(NSArray *)pressedButtonsArray;

- (NSArray *)groupButtons;
- (NSArray *)pressedButtonsIndexes;
@end

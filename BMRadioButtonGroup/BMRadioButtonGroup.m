//
//  BMRadioButtonGroup.m
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

#import "BMRadioButtonGroup.h"
#import "BMRadioButton.h"

@interface BMRadioButtonGroup () <BMRadioButtonDelegate>

/// All the buttons being managed by the group.
@property (nonatomic, strong) NSMutableArray *groupButtonsArray;
/// Indexes (as NSNumbers) of all Pressed BMRadioButtons in the group.
@property (nonatomic, strong) NSMutableArray *pressedButtonsIndexArray;

- (void)pressButton:(BMRadioButton *)button;
- (void)unpressButton:(BMRadioButton *)button;

@end


@implementation BMRadioButtonGroup

#pragma mark - Initalizers

/**
* `initWithSelectionType:` initalizes the BMRadioButtonGroup with that selection type.
* Setting the selection type will define the Group's behavior in allowing only one button to be pressed at a time or multiple.
*
* @param selectionType Accepts the enums BMRadioButtonGroupSelectionSingle or BMRadioButtonGroupSelectionMultiple
*/
- (instancetype)initWithSelectionType:(enum BMRadioButtonGroupSelectionType)selectionType {
    self = [self init];

    if (self != nil) {
        _selectionType = selectionType;
    }

    return self;
}



- (instancetype)init {
    self = [super init];

    if (self != nil) {
        _selectionType = BMRadioButtonGroupSelectionSingle;
        _groupButtonsArray = @[].mutableCopy;
        _pressedButtonsIndexArray = @[].mutableCopy;
        _keepOnePressed = NO;
    }

    return self;
}



#pragma mark - Adding To Group
/**
* `addRadioButtonToGroup:` add a single BMRadioButton to the group to be monitored.
*
* @param radioButton the BMRadioButton to be added to the group
*/
- (void)addRadioButtonToGroup:(BMRadioButton *)radioButton {
    NSUInteger indexOfObject = NSNotFound;

    if (self.groupButtonsArray.count > 0) {
        indexOfObject = [self.groupButtonsArray indexOfObject:radioButton];
    }

    if (indexOfObject == NSNotFound) {
        [self.groupButtonsArray addObject:radioButton];
        radioButton.delegate = self;
    }
}



/**
* `addRadioButtonsToGroupInArray:` add an array of BMRadioButtons to the group to be monitored.
*
* @param radioButtonArray the array of BMRadioButtons to be added to the group
*/
- (void)addRadioButtonsToGroupInArray:(NSArray *)radioButtonArray {
    for (id button in radioButtonArray) {
        if ([button isKindOfClass:[BMRadioButton class]]) {
            [self addRadioButtonToGroup:button];
        }
    }
}



#pragma mark - Removing From Group

/**
* `removeRadioButtonFromGroup:` removes an already monitored button from the group.
*
* @param radioButton The button to be removed from the group.
*/
- (void)removeRadioButtonFromGroup:(BMRadioButton *)radioButton {
    if (self.groupButtonsArray.count == 0) {
        return;
    }

    NSUInteger indexOfObject = [self.groupButtonsArray indexOfObject:radioButton];

    if (indexOfObject != NSNotFound) {
        if (radioButton.pressed) {
            [self unpressButton:radioButton];
        }

        [self.groupButtonsArray removeObject:radioButton];
        radioButton.delegate = nil;
    }

}



/**
* `removeRadioButtonFromGroup:` removes all BMRadioButtons in the array passed in.
*
* @param radioButtonArray The array of BMRadioButtons to remove form the group.
*/
- (void)removeRadioButtonsFromGroupInArray:(NSArray *)radioButtonArray {
    for (id button in radioButtonArray) {
        if ([button isKindOfClass:[BMRadioButton class]]) {
            [self addRadioButtonToGroup:button];
        }
    }
}


#pragma mark - Pre-Selecting Buttons

/**
* `setDefaultPressedButtons:` using an array of BMRadioButtons, you can set those to the pressed state.
*   It should be noted that if you have Single selection enabled, the last one in the list will be selected.
*
* @param pressedButtonsArray the array of buttons to select.
*/
- (void)setDefaultPressedButtons:(NSArray *)pressedButtonsArray {
    for (BMRadioButton *b in pressedButtonsArray) {
        b.pressed = YES;
    }
}




#pragma mark - Button Selection Handlers
/**
* `pressButton:` manages the group in the event a BMRadioButton has been put into the pressed state.
*
* @param button The button that has been put into the pressed state.
*/
- (void)pressButton:(BMRadioButton *)button {
    NSUInteger indexOfObject = [self.groupButtonsArray indexOfObject:button];
    [self.pressedButtonsIndexArray addObject:@(indexOfObject)];

    if ([self.delegate respondsToSelector:@selector(didPressRadioButtonAtIndex:forRadioGroup:)]) {
        [self.delegate didPressRadioButtonAtIndex:indexOfObject
                                    forRadioGroup:self];
    }

    if (self.selectionType == BMRadioButtonGroupSelectionSingle) {
        for (BMRadioButton *b in self.groupButtonsArray) {
            if (b.pressed) {
                b.pressed = NO;
            }
        }
    }

}


/**
* `unpressButton:` manages the group in the event a BMRadioButton has been put into the unpressed state.
*
* @param button The button that has been put into the unpressed state.
*/
- (void)unpressButton:(BMRadioButton *)button {
    NSUInteger indexOfObject = [self.groupButtonsArray indexOfObject:button];

    [self.pressedButtonsIndexArray removeObject:@(indexOfObject)];

    if ([self.delegate respondsToSelector:@selector(didUnpressRadioButtonAtIndex:forRadioGroup:)]) {
        [self.delegate didUnpressRadioButtonAtIndex:indexOfObject
                                      forRadioGroup:self];
    }
}



#pragma mark - <BMRadioButtonDelegate>
- (BOOL)shouldChangeStateForButton:(BMRadioButton *)button {
    BOOL buttonFuturePressed = !button.pressed;

    if (buttonFuturePressed) {
        [self pressButton:button];
        return YES;

    } else {
        if (self.keepOnePressed && self.pressedButtonsIndexArray.count < 2) {
            return NO;
        }

        [self unpressButton:button];
        return YES;
    }

}



#pragma mark - Setters and Getters
/**
* @returns a NSArray of all the buttons in the group
*/
- (NSArray *)groupButtons {
    return [NSArray arrayWithArray:_groupButtonsArray];
}



/**
* @returns a NSArray of all selected button indexes (as NSNumbers) in the group.
*/
- (NSArray *)pressedButtonsIndexes {
    if (self.pressedButtonsIndexArray == nil) {
        return nil;

    } else if (self.pressedButtonsIndexArray.count < 1) {
        return nil;

    } else {
        return [NSArray arrayWithArray:_pressedButtonsIndexArray];
    }
}

@end

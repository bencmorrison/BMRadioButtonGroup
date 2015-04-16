//
//  ViewController.m
//  BMRadioButtonGroup
//
//  Created by Ben Morrison on 4/8/15.
//  Copyright (c) 2015 Benjamin Morrison. All rights reserved.
//

#import "ViewController.h"
#import "BMRadioButton.h"

@interface ViewController ()

@property (nonatomic, strong) BMRadioButtonGroup *radioButtonGroup1;
@property (nonatomic, strong) BMRadioButtonGroup *radioButtonGroup2;

@property (nonatomic, weak) IBOutlet BMRadioButton *button1;
@property (nonatomic, weak) IBOutlet BMRadioButton *button2;
@property (nonatomic, weak) IBOutlet BMRadioButton *button3;
@property (nonatomic, weak) IBOutlet BMRadioButton *button4;
@property (nonatomic, weak) IBOutlet BMRadioButton *button5;
@property (nonatomic, weak) IBOutlet BMRadioButton *button6;

@property (nonatomic, weak) IBOutlet UILabel *group1Label;
@property (nonatomic, weak) IBOutlet UILabel *group2Label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.radioButtonGroup1 = [[BMRadioButtonGroup alloc] initWithSelectionType:BMRadioButtonGroupSelectionSingle];
    self.radioButtonGroup1.delegate = self;

    [self.radioButtonGroup1 addRadioButtonsToGroupInArray:@[
            self.button1,
            self.button2,
            self.button3
    ]];

    [self.radioButtonGroup1 setDefaultPressedButtons:@[self.button2]];


    self.radioButtonGroup2 = [[BMRadioButtonGroup alloc] initWithSelectionType:BMRadioButtonGroupSelectionMultiple];
    self.radioButtonGroup2.delegate = self;

    [self.radioButtonGroup2 addRadioButtonsToGroupInArray:@[
            self.button4,
            self.button5,
            self.button6
    ]];

    [self.radioButtonGroup2 setDefaultPressedButtons:@[self.button6]];
    self.radioButtonGroup2.keepOnePressed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - <BMRadioButtonGroupDelegate>
- (void)didPressRadioButtonAtIndex:(NSUInteger)index forRadioGroup:(BMRadioButtonGroup *)radioButtonGroup {
    NSLog(@"Button at Index: %@ was selected", @(index));
    if (radioButtonGroup == self.radioButtonGroup1) {
        self.group1Label.text = [NSString stringWithFormat:@"Button %@ was pressed.", @(index + 1)];
    
    } else {
        self.group2Label.text = [NSString stringWithFormat:@"Button %@ was pressed.", @(index + 1)];
    }
}



- (void)didUnpressRadioButtonAtIndex:(NSUInteger)index forRadioGroup:(BMRadioButtonGroup *)radioButtonGroup {
    NSLog(@"Button at Index: %@ was deselected", @(index));
    if (radioButtonGroup == self.radioButtonGroup1) {
        self.group1Label.text = [NSString stringWithFormat:@"Button %@ was unpressed.", @(index + 1)];
        
    } else {
        self.group2Label.text = [NSString stringWithFormat:@"Button %@ was unpressed.", @(index + 1)];
    }
}
@end

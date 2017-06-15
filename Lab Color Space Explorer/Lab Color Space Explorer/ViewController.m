//
//  ViewController.m
//  Lab Color Space Explorer
//
//  Created by Jian on 2017/6/15.
//  Copyright © 2017年 jian. All rights reserved.
//

#import "ViewController.h"
#import "JJKeyValueObserver.h"
#import "LabColor.h"

@interface ViewController ()
@property (nonatomic, strong) LabColor *labColor;
@property (weak, nonatomic) IBOutlet UISlider *lSlider;
@property (weak, nonatomic) IBOutlet UISlider *aSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labColor = [[LabColor alloc] init];
    
    [JJKeyValueObserver addObserveObject:_labColor keyPath:@"color" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew changeBlock:^(NSDictionary *c) {
        self.colorView.backgroundColor = self.labColor.color;
    }];
}

- (void)setLabColor:(LabColor *)labColor {
    _labColor = labColor;
    
    self.lSlider.value = self.labColor.lComponent;
    self.aSlider.value = self.labColor.aComponent;
    self.bSlider.value = self.labColor.bComponent;
}

- (IBAction)updateLComponent:(UISlider *)sender{
    self.labColor.lComponent = sender.value;
}

- (IBAction)updateAComponent:(UISlider *)sender {
    self.labColor.aComponent = sender.value;
}

- (IBAction)updateBComponent:(UISlider *)sender {
    self.labColor.bComponent = sender.value;
}


@end

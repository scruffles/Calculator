//
//  ViewController.h
//  Calculator
//
//  Created by Bryan on 5/26/13.
//  Copyright (c) 2013 Bryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *lcdImage;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel *displayLabel;

- (IBAction)buttonPressed:(id)sender;

@end

//
//  ViewController.h
//  ConversionCalculator
//
//  Created by John Berry on 1/31/16.
//  Copyright © 2016 aMDevG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UITextField *outPutField;
@property (weak, nonatomic) IBOutlet UILabel *outPutLabel;
@property (weak, nonatomic) IBOutlet UITextField *inPutField;
    
- (NSArray *) downloadExchRate: (NSString*)currency;




@end



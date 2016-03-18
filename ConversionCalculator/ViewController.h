//
//  ViewController.h
//  ConversionCalculator
//
//  Created by John Berry on 1/31/16.
//  Copyright © 2016 aMDevG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;



- (NSArray*) downloadExchRate:(NSString*)currency;
- (void)bannerViewDidLoadAd:(ADBannerView *)banner;

@end



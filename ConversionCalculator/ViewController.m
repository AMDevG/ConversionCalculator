//
//  ViewController.m
//  ConversionCalculator
//
//  Created by John Berry on 1/31/16.
//  Copyright © 2016 aMDevG. All rights reserved.
//

#import "ViewController.h"


@interface ViewController (){
    NSArray *_arrstatus;
}

@property (strong) NSArray *currencyPair;


@property (strong) NSArray *data;


@property (weak, nonatomic) IBOutlet UITextField *inPut;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *calcButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation ViewController

@synthesize currencyPair;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_outPutField setUserInteractionEnabled:NO];
    
    
     NSArray *data = [self downloadExchRate: @"GBP"];
    
    _arrstatus = @[@"AUD",@"BGN",@"BRL",@"CAD",@"CHF",@"CNY",@"CZK",@"DKK",@"EUR",@"GBP",@"HKD",@"HRK",@"HUF",@"IDR",@"ILS",@"INR",@"JPY",@"KRW",@"MXN",@"MYR",@"NOK",@"NZD",@"PHP",@"PLN",@"RON",@"RUB",@"SEK",@"SGD",@"THB",@"TRY",@"ZAR"];
    
    self.myPickerView.dataSource = self;
    self.myPickerView.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrstatus.count;
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _arrstatus[row];
}


- (NSArray*) downloadExchRate:(NSString*)currency {
    
    NSString *curVal = @"USD";
    
    NSMutableString *remoteUrl = [NSMutableString stringWithFormat:@"https://api.fixer.io/latest?base=%@",curVal];
    
    NSLog(remoteUrl);
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:remoteUrl]];
    
    NSError *jsonError = nil;
    NSHTTPURLResponse *jsonResponse = nil;
    NSData *response;
    
    
    do {
        response = [NSURLConnection sendSynchronousRequest:request returningResponse:&jsonResponse error:&jsonError];
        
        
    } while ([jsonError domain] == NSURLErrorDomain);
    
    
    if([jsonResponse statusCode] != 200) {
        NSLog(@"%ld", (long)[jsonResponse statusCode]);
    } else {
        NSLog(@"%@", @"200 OK");
    }
    NSError* error;
    
    if(response) {
        
        currencyPair = [NSJSONSerialization
                        JSONObjectWithData:response
                        options:kNilOptions
                        error:&error];
    }
    
    else{
        NSLog((@"Response was empty"));
    }
    return currencyPair;
    
}


-(IBAction) updateButton:(id)sender{
    NSMutableString *buf = [NSMutableString new];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}






@end

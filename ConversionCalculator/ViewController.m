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
@property NSInteger *rowValue;
@property (strong) NSString *selectedEntry;
@property (weak, nonatomic) IBOutlet UITextField *inputBox;
@property (weak, nonatomic) IBOutlet UITextField *outputBox;
@property (weak, nonatomic) IBOutlet UILabel *curSym;
@property (weak, nonatomic) IBOutlet UIButton *calcButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation ViewController

@synthesize currencyPair;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_outputBox setUserInteractionEnabled:NO];
    _arrstatus = @[@"AUD",@"BGN",@"BRL",@"CAD",@"CHF",@"CNY",@"CZK",@"DKK",@"EUR",@"GBP",@"HKD",@"HRK",@"HUF",@"IDR",@"ILS",@"INR",@"JPY",@"KRW",@"MXN",@"MYR",@"NOK",@"NZD",@"PHP",@"PLN",@"RON",@"RUB",@"SEK",@"SGD",@"THB",@"TRY",@"ZAR"];
    
    self.myPickerView.dataSource = self;
    self.myPickerView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray*) downloadExchRate:(NSString*)currency {
    
    NSString *curVal = @"USD";
    NSMutableString *remoteUrl = [NSMutableString stringWithFormat:@"https://api.fixer.io/latest?base=%@",curVal];
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
    NSInteger *selection= self.rowValue;
    NSString *countryCode = [_arrstatus objectAtIndex:selection];
    NSDictionary *data = [self downloadExchRate: countryCode];
    NSDictionary *secData = [data objectForKey:@"rates"];
    NSString *conversionRate = [secData objectForKey:(@"%@",countryCode)];
    
    double convDoub = [conversionRate doubleValue];
    
    NSString *input = (_inputBox.text);
    
    double doubInput = [input doubleValue];
    
    double convertedResult = (doubInput * convDoub);
    
    NSNumber *rounded = [NSNumber numberWithDouble:convertedResult];
    
    NSString * strResult = [NSString stringWithFormat:@"%.2f",convertedResult];
    
    _outputBox.text = strResult;
    _curSym.text = countryCode;

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


- (void)pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger) component {
    self.rowValue = row;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}



@end

//
//  ViewController.m
//  ConversionCalculator
//
//  Created by John Berry on 1/31/16.
//  Copyright © 2016 aMDevG. All rights reserved.
//

#import "ViewController.h"

@import iAd;


@interface ViewController (){
    NSArray *_arrstatus;
    NSArray *_arrCountry;
    NSDictionary *curSymbols;
    BOOL _bannerIsVisible;
    ADBannerView *_adBanner;
     
}
@property (weak, nonatomic) IBOutlet UILabel *countrySymb;
@property (strong) NSArray *currencyPair;
@property (strong) NSArray *data;
@property NSInteger *rowValue;
@property (strong) NSString *selectedEntry;
@property (weak, nonatomic) IBOutlet UITextField *inputBox;
@property (weak, nonatomic) IBOutlet UITextField *outputBox;
@property (weak, nonatomic) IBOutlet UILabel *curSym;
@property (weak, nonatomic) IBOutlet UIButton *calcButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *swapButton;
@property (weak, nonatomic) IBOutlet UILabel *baseSymb;


@end

@implementation ViewController

@synthesize currencyPair;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_outputBox setUserInteractionEnabled:NO];
     
     UIImage *btnImage = [UIImage imageNamed:@"refresh-icon.png"];
     [_swapButton setImage:btnImage forState:UIControlStateNormal];
     
    
    _arrstatus = @[@"EUR",@"GBP",@"MXN",@"AUD",@"BGN",@"BRL",@"CAD",@"CHF",@"CNY",@"CZK",@"DKK",@"HKD",@"HRK",@"HUF",@"IDR",@"ILS",@"INR",@"JPY",@"KRW",@"MYR",@"NOK",@"NZD",@"PHP",@"PLN",@"RON",@"RUB",@"SEK",@"SGD",@"THB",@"TRY",@"ZAR"];
    
    _arrCountry = @[ @"Euro", @"British pound", @"Mexican peso",@"Australian dollar", @"Bulgarian lev",@"Brazilian real", @"Canadian dollar", @"Swiss franc", @"Chinese yuan", @"Czech kroner", @"Danish krone",@"Hong Kong dollar", @"Croation kuna", @"Hungarian forint",@"Indonesian rupiah", @"Israeli new sheqel", @"Indian rupee", @"Japanese yen",@"South Korean won",@"Malaysin ringgit", @"Norwegian krone", @"New Zealand dollar", @"Phillippine peso",@"Polish zloty", @"Romanian leu", @"Russian rouble", @"Swedish Krona", @"Singapore dollar", @"Thai baht", @"Turkish lira", @"South African rand" ];
    
    curSymbols = @{
                                @"MXN" : @"$",
                                @"AUD" : @"$",
                                @"BGN" : @"лв",
                                @"BRL" : @"R$",
                                @"CAD" : @"$",
                                @"CHF" : @"CHF",
                                @"CNY" : @"¥",
                                @"CZK" : @"Kč",
                                @"DKK" : @"kr",
                                @"HRK" : @"kn",
                                @"HUF" : @"Ft",
                                @"IDR" : @"Rp",
                                @"MYR" : @"RM",
                                @"PHP" : @"₱",
                                @"RON" : @"lei",
                                @"RUB" : @"руб",
                                @"SEK" : @"kr",
                                @"SGD" : @"$",
                                @"THB" : @"฿",
                                @"TRY" : @"₺",
                                @"ZAR" : @"R",
                                };
    
    self.myPickerView.dataSource = self;
    self.myPickerView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
      
      _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
      _adBanner.delegate = self;
     
}

- (NSArray*) downloadExchRate:(NSString*)currency {
    
    NSString *curVal = currency;
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
    
     UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
     activityView.center=self.view.center;
     [activityView startAnimating];
     [self.view addSubview:activityView];
     

    NSInteger *selection= self.rowValue;
    NSString *countryCode = [_arrstatus objectAtIndex:selection];
    NSString *countrySelect = [_arrCountry objectAtIndex:selection];
     
     NSString *baseCurrency = _baseSymb.text;
     
    
    NSDictionary *data = [self downloadExchRate: baseCurrency];
   
     NSDictionary *secData = [data objectForKey:@"rates"];
    NSString *conversionRate = [secData objectForKey:(@"%@",countryCode)];

    double convDoub = [conversionRate doubleValue];
    
    NSString *input = (_inputBox.text);
    
    NSString *stringWithoutSpaces = [input stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double doubInput = [stringWithoutSpaces doubleValue];
    double convertedResult = (doubInput * convDoub);
  
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    formatter.minimumFractionDigits = 3;
    [formatter setUsesGroupingSeparator:YES];
    [formatter setMaximumFractionDigits:2];
    
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithDouble:convertedResult]];

    NSString *testStr = _inputBox.text;
    
    if ([testStr rangeOfString:@","].location == NSNotFound) {
         NSString *formattedInput =  [formatter stringFromNumber:[NSNumber numberWithDouble:doubInput]];
        _inputBox.text = formattedInput;
    }
  
    _curSym.text = countryCode;
    _outputBox.text = formattedString;
    
    /////CURRENCY SYMBOL CODE ////////////////////////////////////

    id countryCurrency = [curSymbols objectForKey:countryCode];
    
    if(countryCurrency == nil){
           NSLog(@"nil");
        NSLocale *lcl = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSString *countryCurrency = [lcl displayNameForKey:NSLocaleCurrencySymbol value:countryCode] ;
        _countrySymb.text = countryCurrency;
        
    }
    else{
        NSLog(@"%@",countryCurrency);
        _countrySymb.text = countryCurrency;
    }
     
    // [activityView stopAnimating];

}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrCountry.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _arrCountry[row];
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

     
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
     {
          if (!_bannerIsVisible)
          {
               // If banner isn't part of view hierarchy, add it
               if (_adBanner.superview == nil)
               {
                    [self.view addSubview:_adBanner];
               }
               
               [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
               
               // Assumes the banner view is just off the bottom of the screen.
               banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
               
               [UIView commitAnimations];
               
               _bannerIsVisible = YES;
          }
          
     }
     
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
     {
          NSLog(@"Failed to retrieve ad");
          if(_bannerIsVisible){
               [UIView beginAnimations:@"animateBannerOff" context:NULL];
               banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
               [UIView commitAnimations];
               _bannerIsVisible = NO;
               
          }
     }
     

-(IBAction) swapButton:(id)sender{
     
     NSString * tmpSwitch = _curSym.text;
     
     _curSym.text = _baseSymb.text;
     
     _baseSymb.text = tmpSwitch;
     
     
     
     
}





@end

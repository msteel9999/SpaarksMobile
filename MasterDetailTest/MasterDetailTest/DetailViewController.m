//
//  DetailViewController.m
//  MasterDetailTest
//
//  Created by martin steel on 25/02/2013.
//  Copyright (c) 2013 martin steel. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize itemNumber = _itemNumber;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

//@property (weak, nonatomic) IBOutlet UITextField *temperatureTextField;
//@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

//- (IBAction)convertButton_TouchUpInside:(id)sender {
- (IBAction)ClickButton:(id)sender{
// construct envelope (not optimized, intended to show basic steps)
//    NSString *envelopeText =
//    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema- to instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
//    "  <soap12:Body>\n"
//    "    <CelsiusToFahrenheit xmlns=\"http://tempuri.org/\">\n"
//    "      <Celsius>20</Celsius>\n"
//    "    </CelsiusToFahrenheit>\n"
//    "  </soap12:Body>\n"
//    "</soap12:Envelope>";
    
    NSString *envelopeText =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
     "<soap12:Body>"
     "<GetSmartcardStatus xmlns=\"http://www.spaarks.com/DBSmartcard\">"
     "<smartcardIdentifier>gem2_6C3A507401B0828F</smartcardIdentifier>"
     "</GetSmartcardStatus>"
     "</soap12:Body>"
     "</soap12:Envelope>"];
    //
    //envelopeText = [NSString stringWithFormat:envelopeText, temperatureTextField.text];
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    // construct request
    //NSString *url = @"http://www.w3schools.com/webservices/tempconvert.asmx";
    //NSString *url = @"http://www.w3schools.com/webservices/tempconvert.asmx";
    NSString *url = @"http://rdp.spaarks.com:8086/smartcardservice.asmx";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    // fire away
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
        _responseData = [NSMutableData data];
        else
            NSLog(@"NSURLConnection initWithRequest: Failed to return a connection.");
            }

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError: %@ %@",
          error.localizedDescription,
          [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // extract result using regular expression (only as an example)
    // this is not a good way to do it; should use XPath queries with XML DOM such as GDataXMLDocument
    NSString *responseText = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    //NSString *pattern = @"<CelsiusToFahrenheitResult>(\\d+\\.?\\d*)</CelsiusToFahrenheitResult>";
    NSString *pattern = @"<smartcardIdentifier>(\\d+\\.?\\d*)</smartcardIdentifier";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:responseText options:0 range:NSMakeRange(0, responseText.length)];
    if (match)
        NSLog([responseText substringWithRange:[match rangeAtIndex:1]]);
    else
            NSLog(@"Response error.");
}
//
//- (IBAction)ClickButton:(id)sender
//{
//    NSString *soapMsg =
//    [NSString stringWithFormat:
//     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//     "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
//     "<soap12:Body>"
//     "<GetSmartcardStatus xmlns=\"http://www.spaarks.com/DBSmartcard\">"
//     "<smartcardIdentifier>gem2_6C3A507401B0828F</smartcardIdentifier>"
//     "</GetSmartcardStatus>"
//     "</soap12:Body>"
//     "</soap12:Envelope>"];
//    
//    NSURL *url = [NSURL URLWithString: @"http://rdp.spaarks.com:8086/smartcardservice.asmx"];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
//    
//    
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
//    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [req addValue:@"http://www.spaarks.com/DBSmartcard/GetSmartcardStatus" forHTTPHeaderField:@"SOAPAction"];
//    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
//    [req setHTTPMethod:@"POST"];
//    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
//
//    _conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
//    //if (_conn) {
//    //    _webData = [[NSMutableData data] retain];
//    //}
//    
//     /*@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//     "<soap:Envelope
//                         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
//                         xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
//                         xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//     "<soap:Body>"
//     "<FindCountryAsXml
//     xmlns=\"http://www.ecubicle.net/webservices/\">"
//     "<V4IPAddress>%@</V4IPAddress>"
//     "</FindCountryAsXml>"
//     "</soap:Body>"
//     "</soap:Envelope>",  ipAddress.text
//     ];*/
//
//      /*  NSString *queryString =
//        [NSString stringWithFormat: @"https://spk-pc16:444/smartcardservice.asmx/GetSmartcardStatus"];
//        NSURL *url = [NSURL URLWithString:queryString];
//        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
//        [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        
//        [req addValue:0 forHTTPHeaderField:@"Content-Length"];
//        [req setHTTPMethod:@"GET"];
//        [activityIndicator startAnimating];
//        conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
//        if (conn) {
//            webData = [[NSMutableData data] retain];*/
//}
//
//-(void) connection:(NSURLConnection *) connection
//didReceiveResponse:(NSURLResponse *) response {
//    [_webData setLength: 0];
//}
//
//-(void) connection:(NSURLConnection *) connection
//    didReceiveData:(NSData *) data {
//    [_webData appendData:data];
//}
//
//-(void) connection:(NSURLConnection *) connection
//  didFailWithError:(NSError *) error {
//    //[_webData release];
//    //[connection release];
//}
//
//-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
//    NSLog(@"Almost Done");
//    NSLog(@"DONE. Received Bytes: %d", [_webData length]);
//    NSString *theXML = [[NSString alloc]
//                        initWithBytes: [_webData mutableBytes]
//                        length:[_webData length]
//                        encoding:NSUTF8StringEncoding];
//    //---shows the XML---
//    NSLog(theXML);
//}

- (void)setDetailImage:(id)newDetailImage
{
    if (_detailImage != newDetailImage) {
        _detailImage = newDetailImage;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    
    UIImage *pele = [UIImage imageNamed:@"Pele.jpeg"];
    UIImage *maradona = [UIImage imageNamed:@"Maradona.jpeg"];
    
    UIImage *cruyff = [UIImage imageNamed:@"Cruyff-turn2.jpg"];
    UIImage *messi = [UIImage imageNamed:@"lionel-messi-barcelona.jpg"];

    switch (_itemNumber)
    {
        case 0:
            [_detailDescriptionImage setImage:pele];
            break;
        case 1:
            [_detailDescriptionImage setImage:maradona];
            break;
        case 2:
            [_detailDescriptionImage setImage:cruyff];
            break;
        case 3:
            [_detailDescriptionImage setImage:messi];
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end

//
//  ViewController.m
//  SimpleHTTPCall
//
//  Created by Joe on 1/17/17.
//  Copyright © 2017 Joe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSURLConnection* connection;
    NSMutableData* webData;
}
- (IBAction)downloadHtml:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backgroundTap:(id)sender {
    [self.webAdress resignFirstResponder];
}
-(IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction)downloadHtml:(UIButton *)sender {
    self.responseView.text=@"";
    //Create a NSURL object with the string using the HTTP protocol
    NSURL *url;
    if (self.webAdress.text==@"") {
        url=[NSURL URLWithString:@"http://www.zhuxinger.com"];
    }
    else{
        url=[NSURL URLWithString:self.webAdress.text];
    }
        //Create a NSURLRequest from the URL
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    //it's not required to set the http method since
    //if not set it will default to GET
    [theRequest setHTTPMethod:@"GET"];
    connection=[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (connection) {
        webData=[[NSMutableData alloc] init];
    }
}

#pragma mark delegates
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:@"Error" message:@"Can't make a connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void) connectionDidFinishLoading:(NSURLConnection *) connection{
    NSString *responseString=[[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    self.responseView.text=responseString;
}
@end

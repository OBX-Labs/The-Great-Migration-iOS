//
//  MainViewController.m
//  Bastard
//
//  Created by Christian Gratton on 11-06-06.
//  Copyright 2011 Christian Gratton. All rights reserved.
//
/*
#import "MainViewController.h"

#import "EAGLView.h"
#import "InfoController.h"

@implementation MainViewController

@synthesize glView, infoView;

- (id)init {
    self = [super init];
    if (self) {
        //set screen size
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
        glView = [[EAGLView alloc] initWithFrame:rect];
        
        //container view (everything is in here...)
        // make the overlay view that will hold subviews
        containerView = [[UIView alloc] initWithFrame:rect];
        [containerView setMultipleTouchEnabled:NO];
        containerView.opaque = YES;
        containerView.backgroundColor = [UIColor blackColor];
        [containerView addSubview: glView];
        
        //info view
        infoView = [[InfoController alloc] init:self];
        infoView.containerView = containerView;
        [containerView insertSubview:infoView.view aboveSubview:glView];
        
        //ad container view to screen
        [self.view addSubview:containerView];
        //[self.view addSubview:glView];
    }
    
    return self;
}

- (void) composeMail:(NSString*)path
{
    //create the main controller
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setMailComposeDelegate:self];
    [[controller navigationBar] setTintColor:[UIColor blackColor]];
    
    //get the email address
    int qmarkIndex = [path rangeOfString:@"?"].location;
    NSString* email = qmarkIndex == NSNotFound ? path : [path substringToIndex:qmarkIndex];
    
    //look if the link specifies a subject or body
    NSString* subject = @"";
    NSString* body = @"";
    if (qmarkIndex != NSNotFound) {
        path = [path substringFromIndex:qmarkIndex+1];
        NSRange subjMark = [path rangeOfString:@"subject=" options:NSCaseInsensitiveSearch];
        if (subjMark.location != NSNotFound) {
            int subjStart = subjMark.location+subjMark.length;
            NSRange ampMark = [path rangeOfString:@"&"
                                          options:NSCaseInsensitiveSearch
                                            range:NSMakeRange(subjStart, path.length - subjStart)];
            subject = [path substringWithRange:(ampMark.location == NSNotFound ?
                                                NSMakeRange(subjStart, path.length - subjStart) :
                                                NSMakeRange(subjStart, ampMark.location - subjStart))];
            subject = [subject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSRange bodyMark = [path rangeOfString:@"body=" options:NSCaseInsensitiveSearch];
        if (bodyMark.location != NSNotFound) {
            int bodyStart = bodyMark.location+bodyMark.length;
            NSRange ampMark = [path rangeOfString:@"&"
                                          options:NSCaseInsensitiveSearch
                                            range:NSMakeRange(bodyStart, path.length - bodyStart)];
            body = [path substringWithRange:(ampMark.location == NSNotFound ?
                                             NSMakeRange(bodyStart, path.length - bodyStart) :
                                             NSMakeRange(bodyStart, ampMark.location - bodyStart))];
            body = [body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }				
    }
    
    //set the values and present the controller
    [controller setToRecipients:[NSArray arrayWithObject:email]];
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:YES];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//manage the model mail composer
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    //[infoView release];
    [glView release];
    //[containerView release];
    [super dealloc];
}

@end
*/
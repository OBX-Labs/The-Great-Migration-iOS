/*
 
 File: GLES2SampleAppDelegate.m
 
 Abstract: The app delegate that ties everything together.
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#import "TheGreatMigration_iOSAppDelegate.h"
#import "EAGLView.h"
#import "MainSettings.h"
#import "TestFlight.h"

#import "OKPoEMM.h"
#import "OKPreloader.h"
#import "OKTextManager.h"
#import "OKAppProperties.h"
#import "OKPoEMMProperties.h"
#import "OKInfoViewProperties.h"

@implementation TheGreatMigration_iOSAppDelegate

@synthesize window;
//@synthesize mainView;
@synthesize eaglView;
//@synthesize containerView;
//@synthesize glView;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Launch TestFlight
    //[TestFlight takeOff:@"7e187526-9900-46aa-b1cc-d41d8440961a"];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"fLaunch"])
        [self setDefaultValues];
    
    //create the TouchInterceptionWindow to catch touches over the Info view's UIWebview
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //create the main view controller that will hold all views
    //mainView = [[MainViewController alloc] init];
    
    // Get Screen Bounds
    CGRect sBounds = [[UIScreen mainScreen] bounds];
    CGRect sFrame = CGRectMake(sBounds.origin.x, sBounds.origin.y, sBounds.size.height, sBounds.size.width); // Invert height and width to componsate for portrait launch (these values will be set to determine behaviors/dimensions in EAGLView)
    
    // Set app properties
    [OKAppProperties initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"OKAppProperties.plist"] andOptions:launchOptions];
    [OKPoEMMProperties initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"OKPoEMMProperties.plist"]];
    
    
    BOOL isIPad2 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
                    [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]);
    
    if (isIPad2) {
        MAX_BEASTS = 4;
        MAX_PRE_SPAWN_BEASTS = 2;
    }
    
     BOOL canLoad = YES;
    // Show the preloader
    OKPreloader *preloader = [[OKPreloader alloc] initWithFrame:sFrame forApp:self loadOnAppear:canLoad];
    
    // If we can't load a text, show a warning to the user
    if(!canLoad)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Error" message:@"It would appear that all app files were corrupted. Please delete and re-install the app and try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }

    //Add to window
    [self.window setRootViewController:preloader];
    [self.window makeKeyAndVisible];
    
    //done
    return YES;
    
    
    
}

- (void) setDefaultValues
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"exhibition_preference"];
    /* There seems to be an issue with the Bundle Version being 2.0.0 instead of 1.0.2 so I set the default value instead of getting the current one
     [[NSUserDefaults standardUserDefaults] setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"version_preference"];
     */
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"guide_preference"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fLaunch"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadOKPoEMMInFrame:(CGRect)frame
{
    // Initialize EAGLView (OpenGL)
    eaglView = [[EAGLView alloc] initWithFrame:frame];
    
    // Initilaize OKPoEMM (EAGLView, OKInfoView, OKRegistration... wrapper)
    self.poemm = [[OKPoEMM alloc] initWithFrame:frame EAGLView:eaglView isExhibition:[[NSUserDefaults standardUserDefaults] boolForKey:@"exhibition_preference"]];
    [self.window setRootViewController:self.poemm];
    
    //Start EAGLView animation
    if(eaglView) [eaglView startAnimation];
    
    // Asked for performance version
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"guide_preference"]) {
        [self.poemm promptForPerformance];
    } else {
        // If ever performance was disabled, make sure we leave the current state of exhibition
        [self.poemm setisExhibition:[[NSUserDefaults standardUserDefaults] boolForKey:@"exhibition_preference"]];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPerformance"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Appirater after eaglview is started and a few seconds after to let everything get in motion
    [self performSelector:@selector(manageAppirater) withObject:nil afterDelay:10.0f];
}


- (void) applicationWillResignActive:(UIApplication *)application
{
    RESUME_APP = YES; //let something, later, know that we're resuming the app, not starting from  fresh or continuing
	//[mainView.glView stopAnimation];
    //[mainView.glView resetTouches];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Asked for performance version
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"guide_preference"]) {
        [self.poemm promptForPerformance];
    } else {
        // If ever performance was disabled, make sure we leave the current state of exhibition
        [self.poemm setisExhibition:[[NSUserDefaults standardUserDefaults] boolForKey:@"exhibition_preference"]];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPerformance"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [eaglView startAnimation];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
	//[mainView.glView stopAnimation];
}

//- (void) toggleInfo { [mainView.infoView toggleView]; }
//- (BOOL) isInfoVisible { return [mainView.infoView isVisible]; }
//- (BOOL) isInfoVisible { return [eaglView  isVisible]; }

//- (UIImage*) screenCapture { return [mainView.glView screenCapture]; }

- (void) dealloc
{
	[window release];
    //[mainView release];
	
	[super dealloc];
}

#pragma mark - Appirate

- (void) manageAppirater
{
    [Appirater appLaunched:YES];
    [Appirater setDelegate:self];
    [Appirater setLeavesAppToRate:YES]; // Just too hard on the memory
    [Appirater setAppId:@"446777294"];
    [Appirater setDaysUntilPrompt:5];
    [Appirater setUsesUntilPrompt:5];
}

-(void)appiraterDidDisplayAlert:(Appirater *)appirater
{
    [eaglView stopAnimation];
}

-(void)appiraterDidDeclineToRate:(Appirater *)appirater
{
    [eaglView startAnimation];
}

-(void)appiraterDidOptToRate:(Appirater *)appirater
{
    [eaglView stopAnimation];
}

-(void)appiraterDidOptToRemindLater:(Appirater *)appirater
{
    [eaglView startAnimation];
}

-(void)appiraterWillPresentModalView:(Appirater *)appirater animated:(BOOL)animated
{
    [eaglView stopAnimation];
}

-(void)appiraterDidDismissModalView:(Appirater *)appirater animated:(BOOL)animated
{
    [eaglView startAnimation];
}


@end

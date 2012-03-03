#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

#import "BBWeeAppController-Protocol.h"

float VIEW_HEIGHT = 71.0f;

static NSBundle *_NCExampleWeeAppBundle = nil;

@interface NCExampleController: NSObject <BBWeeAppController>
{
	UIView *_view;
    UIScrollView *scrollView;
    
    UIImage *bgImg;
    UIImage *stretchableBgImg;
    
    UIImageView *tempView;
    UIImageView *page1;
    UIImageView *page2;
    
    UILabel *label;
    UIButton *button;
    
    UITapGestureRecognizer* buttonGesture;    
    
    UIViewController *controller;
    UIWindow *window;
}
@property (nonatomic, retain) UIView *view;

- (void)setupAfterRotation;
- (void)addControls;

- (IBAction)ButtonPressed:(id)sender;

@end

@implementation NCExampleController
@synthesize view = _view;

+ (void)initialize
{
	_NCExampleWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init
{
	if((self = [super init]) != nil)
    {
        //Initialising the view
        _view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, VIEW_HEIGHT)];
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //Initialising the scrollview
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _view.bounds.size.width, VIEW_HEIGHT)];
        scrollView.pagingEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scrollView.showsHorizontalScrollIndicator = NO;
	} 
    return self;
}

- (void)loadPlaceholderView
{
    //Hiding the scrollview and adding a 'Placeholder' view
    scrollView.hidden = YES;
    [tempView removeFromSuperview];
    
    bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
    stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];   
    
	tempView = [[UIImageView alloc] initWithImage:stretchableBgImg];
	tempView.frame = CGRectMake(2.0f, 0.0f, _view.bounds.size.width - 4.0f, VIEW_HEIGHT);
	tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_view addSubview:tempView];
}

- (void)loadFullView
{
    [self setupAfterRotation];
    [self addControls];
}

- (void)setupAfterRotation
{
    [page1 removeFromSuperview];
    [page2 removeFromSuperview];
    
    //Setting the scrollview size
    [scrollView setContentSize:CGSizeMake(_view.bounds.size.width * 2, VIEW_HEIGHT)];
    
    //Initialising the 2 pages with the backgorund images
    
    bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
    stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
    
    page1 = [[UIImageView alloc] initWithImage:stretchableBgImg];
    page1.frame = CGRectMake(2.0f, 0.0f, _view.bounds.size.width - 4.0f, VIEW_HEIGHT);
    page1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    page1.userInteractionEnabled = YES;
    
    page2 = [[UIImageView alloc] initWithImage:stretchableBgImg];
    page2.frame = CGRectMake(_view.bounds.size.width + 2.0f, 0.0f, _view.bounds.size.width - 4.0f, VIEW_HEIGHT);
    page2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    page2.userInteractionEnabled = YES;
    
    //Adding the two pages to the array
    [scrollView addSubview:page1];
    [scrollView addSubview:page2];
    
    //Removing the 'Placeholder' view
    [tempView removeFromSuperview];
    
    //Adding the scrollview
    scrollView.hidden = NO;
    [_view addSubview:scrollView];
}

- (void)addControls
{
    //Creating a label
    label = [[UILabel alloc] initWithFrame:CGRectMake(_view.bounds.size.width / 2.0f - 125.0f, VIEW_HEIGHT / 2.0f - 12.5f, 250, 25)];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    
    label.text = @"Scroll right to find a button >>";
    
    //Creating a button
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(_view.bounds.size.width / 2.0f - 15.0f, VIEW_HEIGHT / 2.0f - 22.5f, 200, 30)];
    [button setTitle:@"Tweet" forState:UIControlStateNormal];
    
    //Creating and adding the touch handler to the button
    buttonGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ButtonPressed:)];
    [button addGestureRecognizer:buttonGesture];
    
    //add the controls to the relevant page
    [page1 addSubview:label];
    [page2 addSubview:button];
}

- (IBAction)ButtonPressed:(id)sender
{
    //Send a tweet
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"A Placeholder Tweet :)"];
        
        controller = [[UIViewController alloc] init];
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        window.rootViewController = controller;  
        window.windowLevel = UIWindowLevelAlert;
        
        [window makeKeyAndVisible];
        
        [controller presentModalViewController:tweetSheet animated:YES];
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result)
        {
            [controller dismissModalViewControllerAnimated:YES];
            
            [window release];
            [controller release];
        };
        
        tweetSheet = nil;
        [tweetSheet release];
    }
}

- (void)dealloc
{
    _view = nil;
    [_view release];
    
    scrollView = nil;
    [scrollView release];
    
    bgImg = nil;
    [bgImg release];
    stretchableBgImg = nil;
    [stretchableBgImg release];
    
    tempView = nil;
    [tempView release];
    page1 = nil;
    [page1 release];
    page2 = nil;
    [page2 release];
    
    label = nil;
    [label release];
    button = nil;
    [button release];
    buttonGesture = nil;
    [buttonGesture release];
    
    [window release];
    [controller release];
    window = nil;
    controller = nil;

    [super dealloc];
}

- (float)viewHeight
{
	return VIEW_HEIGHT;
}

@end

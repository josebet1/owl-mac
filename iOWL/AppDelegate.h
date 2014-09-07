//
//  AppDelegate.h
//  iOWL
//
//  Created by Jose Bethancourt on 9/6/14.
//  Copyright (c) 2014 Jose Bethancourt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabber.h"
@interface AppDelegate : NSObject <NSApplicationDelegate, PhotoGrabberDelegate>
{
    PhotoGrabber *grabber;
}

@property (strong) IBOutlet NSImageView *imageWell4;
@property (strong) IBOutlet NSImageView *imageWell3;
@property (strong) IBOutlet NSImageView *imageWell1;
@property (strong) IBOutlet NSImageView *imageWell2;

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic,retain) PhotoGrabber *grabber;

@property (strong) IBOutlet NSTextField *timeRemaining;
@property (strong) IBOutlet NSTextField *welcomeLabel;
@property (strong) IBOutlet NSTextField *photoNumLabel;

@end


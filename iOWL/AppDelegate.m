//
//  AppDelegate.m
//  iOWL
//
//  Created by Jose Bethancourt on 9/6/14.
//  Copyright (c) 2014 Jose Bethancourt. All rights reserved.
//

#import "AppDelegate.h"
#import <IOBluetooth/IOBluetooth.h>
#import "BLCBeaconAdvertisementData.h"
#import "PhotoGrabber.h"
#import <Pusher/Pusher.h>
#import "AFNetworking.h"

@interface AppDelegate () <CBPeripheralManagerDelegate, NSTextFieldDelegate, PhotoGrabberDelegate, PTPusherDelegate>

@property (nonatomic,strong) CBPeripheralManager *manager;
@property (nonatomic, strong) PTPusher *pusher;
@property (nonatomic, strong) NSTimer *bob;
@property (nonatomic, strong) NSString *picture_id;
@property (nonatomic, strong) NSString *fb_id;
@property (nonatomic, strong) NSString *name;
@property bool isLocked;
@property int secs;

@end

@implementation AppDelegate;
@synthesize grabber;


int i =0;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    self.imageWell1.imageFrameStyle = NSImageFrameNone;
    self.imageWell2.imageFrameStyle = NSImageFrameNone;
    self.imageWell3.imageFrameStyle = NSImageFrameNone;
    self.imageWell4.imageFrameStyle = NSImageFrameNone;
    [[_window contentView] setWantsLayer:YES];
    [[_window contentView] layer].contents = [NSImage imageNamed:@"OwlBackground.png"];
  /*         if(self.pusher.connection.isConnected == true)
    {
        self.isLocked = true;
    }

    grabber = [[PhotoGrabber alloc] init];
	grabber.delegate = self;
    
    _manager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                       queue:nil];
    [self startBroadcasting];
    NSLog(@"taking photo");
    //[self.timeRemaining setStringValue:@"5"];
    if(self.isLocked == false)
    {
        _pusher = [PTPusher pusherWithKey:@"0924a0589bee3892e33c" delegate:self];
        [self.pusher connect];
        PTPusherChannel *channel = [_pusher subscribeToChannelNamed:@"photobooth"];
        
        [channel bindToEventNamed:@"take" handleWithBlock:^(PTPusherEvent *channelEvent) {
            
            NSLog(@"WE ARE HERE. WE ARE READY. AND HE MISSPELLED");
            NSLog(@"%@",channelEvent.data);
            
            _name = channelEvent.data[@"name"];
            _fb_id = channelEvent.data[@"fb_id"];
            _picture_id = channelEvent.data[@"photo_id"];
            NSString *welcomeText = @"Welcome, ";
            welcomeText = [welcomeText stringByAppendingString:self.name];
            [self.welcomeLabel setStringValue:welcomeText];
            [self.photoNumLabel setStringValue:@"1st Photo In"];
            [self.timeRemaining setStringValue:@"5"];
            
            self.secs = 6;
            _bob = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(takePhoto:)
                                                  userInfo:nil
                                                   repeats:YES];
            
            
        }];
        
    }

*/
    
    [self setUpConnection];
    
}



-(void)setUpConnection
{
    if(self.pusher.connection.isConnected == true)
    {
        self.isLocked = true;
    }
    
    grabber = [[PhotoGrabber alloc] init];
	grabber.delegate = self;
    
    _manager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                       queue:nil];
    [self startBroadcasting];
    NSLog(@"taking photo");
    //[self.timeRemaining setStringValue:@"5"];
    if(self.isLocked == false)
    {
        _pusher = [PTPusher pusherWithKey:@"0924a0589bee3892e33c" delegate:self];
        [self.pusher connect];
        PTPusherChannel *channel = [_pusher subscribeToChannelNamed:@"photobooth"];
        
        [channel bindToEventNamed:@"take" handleWithBlock:^(PTPusherEvent *channelEvent) {
            
            NSLog(@"WE ARE HERE. WE ARE READY. AND HE MISSPELLED");
            NSLog(@"%@",channelEvent.data);
            
            _name = channelEvent.data[@"name"];
            _fb_id = channelEvent.data[@"fb_id"];
            _picture_id = channelEvent.data[@"photo_id"];
            NSString *welcomeText = @"Welcome, ";
            welcomeText = [welcomeText stringByAppendingString:self.name];
            [self.welcomeLabel setStringValue:welcomeText];
            [self.photoNumLabel setStringValue:@"1st Photo In"];
            [self.timeRemaining setStringValue:@"5"];
            
            self.secs = 6;
            _bob = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(takePhoto:)
                                                  userInfo:nil
                                                   repeats:YES];
            
            
        }];
    }
}



- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"we are broadcasting");
    }
}

- (void)startBroadcasting{
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"D57092AC-DFAA-446C-8EF3-C81AA22815B5"];

    BLCBeaconAdvertisementData *beaconData = [[BLCBeaconAdvertisementData alloc] initWithProximityUUID:proximityUUID
                                                                                                 major:@"5".integerValue
                                                                                                 minor:@"5000".integerValue
                                                                                         measuredPower:@"-66".integerValue];
    
    
    [_manager startAdvertising:beaconData.beaconAdvertisement];
    

}
-(IBAction)takePhoto:(id)sender{
    if(self.secs == 0)
    {
        if (i == 3){
            [_bob invalidate];
            self.isLocked = false;
        }
        NSLog(@"WOOO!");
        [grabber grabPhoto];
        i++;
        if(i == 1)
        {
            [self.photoNumLabel setStringValue:@"2nd Photo In"];
        }
        else if (i == 2)
        {
            [self.photoNumLabel setStringValue:@"3rd Photo In"];
        }
        else if (i == 3)
        {
            [self.photoNumLabel setStringValue:@"4th Photo In"];
        }
        self.secs = 6;

    }
    else
    {
        self.secs--;
        [self.timeRemaining setStringValue:[NSString stringWithFormat:@"%i", self.secs]];
    }
    
    
}
- (void)photoGrabbed:(NSImage*)image
{

    NSLog(@"took teh pic");
    
    NSString *face = [NSString stringWithFormat:@"/Users/josebet1/Desktop/%@.%@_%d.png", _fb_id,_picture_id,i];
    NSString *pic_name = [NSString stringWithFormat:@"%@.%@_%d.png", _fb_id,_picture_id,i];

    NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
    NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
    [data writeToFile:face atomically: NO];
    NSImage *img = [[NSImage alloc] initWithData:data];
    
    if(i == 1)
    {
        self.imageWell1.image = img;
    }
    else if (i == 2)
    {
       self.imageWell2.image = img;
    }
    else if (i ==3)
    {
        self.imageWell3.image = img;
    }
    else
    {
        self.imageWell4.image = img;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imageWell1.image = nil;
            self.imageWell2.image = nil;
            self.imageWell3.image = nil;
            self.imageWell4.image = nil;
            self.welcomeLabel.stringValue = @"";
            self.photoNumLabel.stringValue = @"";
            self.timeRemaining.stringValue = @"";
            i = 0;
            [self setUpConnection];
            
        });
    }
        
    NSLog(@"life");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"fb_id": _fb_id, @"pic_id": _picture_id};
    NSURL *filePath = [NSURL fileURLWithPath:face];
    NSLog(@"%@", filePath);
    [manager POST:@"http://owl.joseb.me/upload_photo.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"photo" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

	// image is the image from the camera
	// store it to a file or show, manipulate it, have fun
}
@end

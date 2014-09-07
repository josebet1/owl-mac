//
//  PhotoGrabber.h
//  By Erik Rothoff Andersson <erikrothoff.com>
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@protocol PhotoGrabberDelegate <NSObject>

- (void)photoGrabbed:(NSImage*)image;

@end

@interface PhotoGrabber : NSObject {
    CVImageBufferRef currentImage;
    
    QTCaptureDevice *video;
    QTCaptureDecompressedVideoOutput *output;
    QTCaptureInput *input;
    QTCaptureSession *session;
    
    id<PhotoGrabberDelegate> delegate;
}

@property (nonatomic, assign) id<PhotoGrabberDelegate> delegate;

- (void)grabPhoto;
- (NSString*)deviceName;

@end
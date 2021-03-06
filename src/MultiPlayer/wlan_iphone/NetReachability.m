/*

===== IMPORTANT =====

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not
final. Apple is supplying this information to help you plan for the adoption of
the technologies and programming interfaces described herein. This information
is subject to change, and software implemented based on this sample code should
be tested with final operating system software and final documentation. Newer
versions of this sample code may be provided with future seeds of the API or
technology. For information about updates to this and other developer
documentation, view the New & Updated sidebars in subsequent documentation
seeds.

=====================

File: NetReachability.m
Abstract: Convenience class that wraps the SCNetworkReachability APIs from
SystemConfiguration.

Version: 1.1

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

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#undef WIN32

#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

#import "MultiPlayer/wlan_iphone/NetReachability.h"
//#import "Networking_Internal.h"

//MACROS:

#if TARGET_OS_IPHONE
#define IS_REACHABLE(__FLAGS__) (((__FLAGS__) & kSCNetworkReachabilityFlagsReachable) && !((__FLAGS__) & kSCNetworkReachabilityFlagsConnectionRequired))
#if TARGET_IPHONE_SIMULATOR
#define IS_CELL(__FLAGS__) (0)
#else
#define IS_CELL(__FLAGS__) (IS_REACHABLE(__FLAGS__) && ((__FLAGS__) & kSCNetworkReachabilityFlagsIsWWAN))
#endif
#else
#define IS_REACHABLE(__FLAGS__) (((__FLAGS__) & kSCNetworkFlagsReachable) && !((__FLAGS__) & kSCNetworkFlagsConnectionRequired))
#define IS_CELL(__FLAGS__) (0)
#endif

//CLASS IMPLEMENTATION:

@implementation NetReachability

/*
This will consume a reference of "reachability"
*/
- (id) _initWithNetworkReachability:(SCNetworkReachabilityRef)reachability
{
	if(reachability == NULL) 
	{
		[self release];
		return nil;
	}
	
	if((self = [super init])) 
	{
		_netReachability = (void*)reachability;
	}
	
	return self;
}

- (id) initWithDefaultRoute:(BOOL)ignoresAdHocWiFi
{
	return [self initWithIPv4Address:(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM)];
}

- (id) initWithAddress:(const struct sockaddr*)address
{
	return [self _initWithNetworkReachability:(address ? SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, address) : NULL)];
}

- (id) initWithIPv4Address:(UInt32)address
{
	struct sockaddr_in				ipAddress;
	
	bzero(&ipAddress, sizeof(ipAddress));
	ipAddress.sin_len = sizeof(ipAddress);
	ipAddress.sin_family = AF_INET;
	ipAddress.sin_addr.s_addr = htonl(address);
	
	return [self initWithAddress:(struct sockaddr*)&ipAddress];
}

- (id) initWithHostName:(NSString*)name
{
	return [self _initWithNetworkReachability:([name length] ? SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [name UTF8String]) : NULL)];
}

- (void) dealloc
{	
	if(_netReachability)
		CFRelease(_netReachability);
	
	[super dealloc];
}

- (BOOL) isReachable
{
	SCNetworkConnectionFlags		flags;
	
	return (SCNetworkReachabilityGetFlags(_netReachability, &flags) && IS_REACHABLE(flags) ? YES : NO);
}

- (BOOL) isUsingCell
{
	SCNetworkConnectionFlags		flags;
	
	return (SCNetworkReachabilityGetFlags(_netReachability, &flags) && IS_CELL(flags) ? YES : NO);
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08X | reachable = %i>", [self class], (long)self, [self isReachable]];
}

@end

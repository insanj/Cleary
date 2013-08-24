//Cleary by Julian "insanj" Weiss
//(c) 2013 Julian Weiss, see full license in README.md

#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>

@interface Cleary : NSObject <LAListener, UIAlertViewDelegate> {
@private
	UIAlertView *taskView;
}
@end

@implementation Cleary

-(BOOL)dismiss{
	if (taskView) {
		[taskView dismissWithClickedButtonIndex:[taskView cancelButtonIndex] animated:YES];
		[taskView release];
		taskView = nil;
		return YES;
	}//end if

	return NO;
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	[taskView release];
	taskView = nil;

	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Create"]){
		NSString *scheme = [@"clearapp://task/create?taskName=" stringByAppendingString:[alertView textFieldAtIndex:0].text];

		NSString *list = [[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.cleary.plist"]] objectForKey:@"list"];

		if(list){
			if([list intValue] > 0)
				scheme = [scheme stringByAppendingString:[NSString stringWithFormat:@"&listPosition=%i", [list intValue]]];
			else
				scheme = [scheme stringByAppendingString:[NSString stringWithFormat:@"&listName=%@", list]];
		}//end if

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}//end if
}//end alertview

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{

	if (![self dismiss]) {
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"clearapp:"]]){
			taskView = [[UIAlertView alloc] initWithTitle:@"Cleary" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
			[taskView setAlertViewStyle:UIAlertViewStylePlainTextInput];
			[[taskView textFieldAtIndex:0] setPlaceholder:@"New Clear Task"];
		}//end if

		else
			taskView = [[UIAlertView alloc] initWithTitle:@"Clear Required" message:@"Please install Clear for iOS from the App Store to use Cleary!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];

		[taskView show];
		[event setHandled:YES];
	}//end if
}

-(void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event{
	[self dismiss];
}

-(void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event{
	[self dismiss];
}

-(void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event{
	if ([self dismiss])
		[event setHandled:YES];
}

-(void)dealloc{
	[taskView release];
	[super dealloc];
}

+(void)load{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"libactivator.cleary"];
	[pool release];
}

@end 
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSRootController.h>
#import <objc/runtime.h>

@interface PSViewController : UIViewController
-(id)initForContentSize:(CGSize)contentSize;
-(void)setPreferenceValue:(id)value specifier:(id)specifier;
@end

@interface PSListController : PSViewController{
	NSArray *_specifiers;
}

-(void)loadView;
-(void)reloadSpecifier:(PSSpecifier*)specifier animated:(BOOL)animated;
-(void)reloadSpecifier:(PSSpecifier*)specifier;
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
-(PSSpecifier*)specifierForID:(NSString*)specifierID;
@end

@interface PSTableCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
@end

@interface CLPreferencesListController : PSListController
@end

@implementation CLPreferencesListController

-(id)specifiers {
	if(!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"CLPreferences" target:self] retain];

	return _specifiers;
}//end specifiers

-(BOOL)isEmpty:(NSString *)string{
   if([string length] == 0)
       return YES;

   if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
       return YES;

   return NO;
}

-(void)resignKeyboard{
	[self.view endEditing:YES];
    NSString *list = [[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.cleary.plist"]] objectForKey:@"list"];
	
	if(!list || [self isEmpty:list]){
		PSSpecifier* listSpecifier = [self specifierForID:@"ListField"];
		[self setPreferenceValue:@"" specifier:listSpecifier];
		[self reloadSpecifier:listSpecifier animated:YES];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}//end if
}//end resign

-(void)twitter{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:@"insanj"]]];

	else 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:@"insanj"]]];
}//end twitter

-(void)mail{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:me%40insanj.com?subject=Cleary%20(1.1)%20Support"]];
}
@end
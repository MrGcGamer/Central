#import <Preferences/PSSpecifier.h>
#import <UIKit/UIImage+Private.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIColor+Private.h>
#import "DuoTwitterCell.h"

@implementation UIView (fconstraints)
-(void)anchorTop:(nullable NSLayoutAnchor <NSLayoutYAxisAnchor *> *)top 
		 leading:(nullable NSLayoutAnchor <NSLayoutXAxisAnchor *> *)leading 
		  bottom:(nullable NSLayoutAnchor <NSLayoutYAxisAnchor *> *)bottom 
		trailing:(nullable NSLayoutAnchor <NSLayoutXAxisAnchor *> *)trailing 
		 padding:(UIEdgeInsets)insets 
		 	size:(CGSize)size
{

	self.translatesAutoresizingMaskIntoConstraints = NO;

    if (top)
        [self.topAnchor constraintEqualToAnchor:top constant:insets.top].active = YES;
    if (leading)
        [self.leadingAnchor constraintEqualToAnchor:leading constant:insets.left].active = YES;
    if (bottom)
        [self.bottomAnchor constraintEqualToAnchor:bottom constant:-insets.bottom].active = YES;
    if (trailing)
        [self.trailingAnchor constraintEqualToAnchor:trailing constant:-insets.right].active = YES;

    if (size.width != 0)
        [self.widthAnchor constraintEqualToConstant:size.width].active = YES;
    if  (size.height != 0)
        [self.heightAnchor constraintEqualToConstant:size.height].active = YES;

}
@end

@implementation DuoTwitterCell

+ (NSString *)_urlForUsername:(NSString *)user {

	user = [user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"aphelion://"]]) {
		return [@"aphelion://profile/" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
		return [@"tweetbot:///user_profile/" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
		return [@"twitterrific:///profile?screen_name=" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
		return [@"tweetings:///user?screen_name=" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
		return [@"twitter://user?screen_name=" stringByAppendingString:user];
	} else {
		return [@"https://mobile.twitter.com/" stringByAppendingString:user];
	}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {

		_user = specifier.properties[@"firstAccount"];
		_user2 = specifier.properties[@"secondAccount"];
		_displayNameOne = specifier.properties[@"firstLabel"];
		_displayNameTwo = specifier.properties[@"secondLabel"];
		_accountNameOne = specifier.properties[@"firstAccount"];
		_accountNameTwo = specifier.properties[@"secondAccount"];
		
	}

	return self;
}

- (void)didMoveToWindow {
	[super didMoveToWindow];

	UIView *duoCellView = [UIView new];
	UIView *cellOne = [UIView new];
	UIView *cellTwo = [UIView new];
	UIImageView *avatarViewOne = [UIImageView new];
	UIImageView *avatarViewTwo = [UIImageView new];
	UILabel *displayNameOne = [UILabel new];
	UILabel *displayNameTwo = [UILabel new];
	UILabel *accountNameOne = [UILabel new];
	UILabel *accountNameTwo = [UILabel new];
	UIView *separator = [UIView new];

	UIImage *avatarImageOne = [UIImage imageNamed:[NSString stringWithFormat:@"/Library/PreferenceBundles/Centralprefs.bundle/%@.png", _accountNameOne]];
	UIImage *avatarImageTwo = [UIImage imageNamed:[NSString stringWithFormat:@"/Library/PreferenceBundles/Centralprefs.bundle/%@.png", _accountNameTwo]];

	[avatarViewOne setImage:avatarImageOne];
	[avatarViewTwo setImage:avatarImageTwo];
	
	for (UIImageView *imageView in @[avatarViewOne, avatarViewTwo]) {
		imageView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1];
		imageView.userInteractionEnabled = NO;
		imageView.clipsToBounds = YES;
		imageView.layer.cornerRadius = 19;
		imageView.layer.borderWidth = 2;
		imageView.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:0.3] CGColor];
	}

	displayNameOne.text = [@"" stringByAppendingString:_displayNameOne];
	displayNameTwo.text = [@"" stringByAppendingString:_displayNameTwo];
	accountNameOne.text = [@"@" stringByAppendingString:_accountNameOne];
	accountNameTwo.text = [@"@" stringByAppendingString:_accountNameTwo];

	if (@available(iOS 13, *)) {
		displayNameOne.textColor = [UIColor labelColor];
		displayNameTwo.textColor = [UIColor labelColor];
		accountNameOne.textColor = [UIColor secondaryLabelColor];
		accountNameTwo.textColor = [UIColor secondaryLabelColor];
	} else {
		displayNameOne.textColor = [UIColor blackColor];
		displayNameTwo.textColor = [UIColor blackColor];
		accountNameOne.textColor = [UIColor grayColor];
		accountNameTwo.textColor = [UIColor grayColor];
	}

	displayNameOne.font = [UIFont systemFontOfSize:16];
	displayNameTwo.font = [UIFont systemFontOfSize:16];
	accountNameOne.font = [UIFont systemFontOfSize:11];
	accountNameTwo.font = [UIFont systemFontOfSize:11];

	separator.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];

	[self.contentView addSubview:duoCellView];

	[duoCellView anchorTop:nil leading:self.contentView.leadingAnchor bottom:nil trailing:self.contentView.trailingAnchor padding:UIEdgeInsetsZero size:CGSizeMake(0,57)];

	[duoCellView addSubview:cellOne];
	[duoCellView addSubview:cellTwo];

	[cellOne anchorTop:nil leading:duoCellView.leadingAnchor bottom:nil trailing:duoCellView.centerXAnchor padding:UIEdgeInsetsZero size:CGSizeMake(0,57)];
	[cellTwo anchorTop:nil leading:cellOne.trailingAnchor bottom:nil trailing:duoCellView.trailingAnchor padding:UIEdgeInsetsZero size:CGSizeMake(0,57)];

	[cellOne addSubview:avatarViewOne];
	[cellTwo addSubview:avatarViewTwo];

	[avatarViewOne anchorTop:cellOne.topAnchor leading:cellOne.leadingAnchor bottom:nil trailing:nil padding:UIEdgeInsetsMake(9.3333,15,0,0) size:CGSizeMake(38,38)];
	[avatarViewTwo anchorTop:cellTwo.topAnchor leading:cellTwo.leadingAnchor bottom:nil trailing:nil padding:UIEdgeInsetsMake(9.3333,15,0,0) size:CGSizeMake(38,38)];
		
	[cellOne addSubview:displayNameOne];
	[cellTwo addSubview:displayNameTwo];
	[cellOne addSubview:accountNameOne];
	[cellTwo addSubview:accountNameTwo];

	[displayNameOne anchorTop:cellOne.topAnchor leading:avatarViewOne.trailingAnchor bottom:nil trailing:cellOne.trailingAnchor padding:UIEdgeInsetsMake(9,15,0,15) size:CGSizeMake(0,20.3333)];
	[displayNameTwo anchorTop:cellTwo.topAnchor leading:avatarViewTwo.trailingAnchor bottom:nil trailing:cellTwo.trailingAnchor padding:UIEdgeInsetsMake(9,15,0,15) size:CGSizeMake(0,20.3333)];
	[accountNameOne anchorTop:cellOne.topAnchor leading:avatarViewOne.trailingAnchor bottom:nil trailing:cellOne.trailingAnchor padding:UIEdgeInsetsMake(32.3333,15,0,15) size:CGSizeMake(0,15)];
	[accountNameTwo anchorTop:cellTwo.topAnchor leading:avatarViewTwo.trailingAnchor bottom:nil trailing:cellTwo.trailingAnchor padding:UIEdgeInsetsMake(32.3333,15,0,15) size:CGSizeMake(0,15)];

	UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftTap:)];
	[cellOne addGestureRecognizer:leftTap];

	UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightTap:)];
	[cellTwo addGestureRecognizer:rightTap];

	[duoCellView addSubview:separator];

	[separator anchorTop:nil leading:nil bottom:nil trailing:nil padding:UIEdgeInsetsZero size:CGSizeMake(0.5,57)];
	[separator.centerXAnchor constraintEqualToAnchor:duoCellView.centerXAnchor].active = YES;
	[separator.centerYAnchor constraintEqualToAnchor:duoCellView.centerYAnchor].active = YES;
}

- (void)handleLeftTap:(UITapGestureRecognizer *)recognizer {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.class _urlForUsername:_user]] options:@{} completionHandler:nil];
}

- (void)handleRightTap:(UITapGestureRecognizer *)recognizer {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.class _urlForUsername:_user2]] options:@{} completionHandler:nil];
}

@end
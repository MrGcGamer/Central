#import "Tweak.h"

%group Central14
    %hook  SBIconListView
        - (CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 metrics:(id)arg2 {
            doneWaitingForLoad = YES;
            // Get our original point for the current icon
            CGPoint o = %orig(arg1, arg2);
            if ([self isEditing]) return o;
            if (!_pfTweakEnabled) return o;
            if (!([self.iconLocation containsString:@"Root"]) && !_pfChangeFolderLayout) return o;
            if (![self isKindOfClass:%c(_SBHLibraryPodCategoryIconListView)] && [self isKindOfClass:%c(_SBHLibraryPodIconListView)]) return o;
            if (!_pfChangeLibraryLayout && [self isKindOfClass:%c(SBHLibraryCategoryPodIconListView)]) return o;

            // Remainder of amount of icons / icons in row will be the amount of icons in the final row
            NSInteger temp = 0;
            NSInteger tempX = 0;

            for (UIView *icon in self.visibleIcons) {
                if (![icon isKindOfClass:%c(SBWidgetIcon)]) {
                    temp = temp + tempX + 1;
                    tempX = 0;
                }
                else {
                    SBIcon *widget = (SBIcon *)icon;
                    switch (widget.gridSizeClass) {
                        case 1:
                            tempX += 4;
                            break;
                        case 2:
                            tempX += 8;
                            break;
                        case 3:
                            tempX += 16;
                            break;
                    }
                }
            }
            NSInteger iconsInFinalRow = temp % self.iconsInRowForSpacingCalculation; // 22 % 4 = 2 icons in last row

            // If there are no (4) icons in the final row, do nothing
            if (iconsInFinalRow == 0) return o; // nothing to change

            // Get the actual index of the icon (rows-1) * amount of icons in row + which icon in the row - 1 (arrays start at 0)
            NSInteger actualIndexForIcon = (arg1.row-1) * self.iconsInRowForSpacingCalculation + arg1.col - 1;
            // Starting index will be the amount of icons displayed minus the amount in the final row
            NSInteger startingIndex = temp - iconsInFinalRow;						// 22 - 2 = 20 index to start at

            // grabs the icon width 
            CGFloat iconWidth = self.alignmentIconSize.width;

            // gets the left indent for the last row
            CGFloat leftInset = ([UIDevice currentDevice].orientation == 3 || [UIDevice currentDevice].orientation == 5) ? [[[self layout] layoutConfiguration] landscapeLayoutInsets].left : [[[self layout] layoutConfiguration] portraitLayoutInsets].left;
            CGFloat left = (self.bounds.size.width - leftInset * 2 - iconsInFinalRow * iconWidth - (iconsInFinalRow - 1) *  // takes the original left code
                self.horizontalIconPadding                                                                                              // icon spacing
                )/2;                                                                                                                    // divides it all by 2

            // calc and return
            if (actualIndexForIcon >= startingIndex && actualIndexForIcon <= temp)
                o.x = o.x + (([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) ? -left : +left);

            return o;
        }
    %end
%end

%group Central13
    %hook  SBIconListView
        - (CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 metrics:(struct SBIconListLayoutMetrics)arg2 {
            doneWaitingForLoad = YES;
            // Get our original point for the current icon
            CGPoint o = %orig(arg1, arg2);
            if ([self isEditing]) return o;
            if (!_pfTweakEnabled) return o;
            if (!([self.iconLocation containsString:@"Root"]) && !_pfChangeFolderLayout) return o;


            // Remainder of amount of icons / icons in row will be the amount of icons in the final row
            NSInteger iconsInFinalRow = self.firstFreeSlotIndex % self.iconsInRowForSpacingCalculation; // 22 % 4 = 2 icons in last row

            // If there are no (4) icons in the final row, do nothing
            if (iconsInFinalRow == 0) return o; // nothing to change

            // grabs the icon width 
            CGFloat iconWidth = self.alignmentIconSize.width;

            // gets the left indent for the last row
            CGFloat leftInset = ([UIDevice currentDevice].orientation == 3 || [UIDevice currentDevice].orientation == 5) ? [[[self layout] layoutConfiguration] landscapeLayoutInsets].left : [[[self layout] layoutConfiguration] portraitLayoutInsets].left;
            CGFloat left = (self.bounds.size.width - leftInset * 2 - iconsInFinalRow * iconWidth - (iconsInFinalRow - 1) *  // takes the original left code
                self.horizontalIconPadding                                                                                              // icon spacing
                )/2;                                                                                                                    // divides it all by 2

            // Get the actual index of the icon (rows-1) * amount of icons in row + which icon in the row - 1 (arrays start at 0)
            NSInteger actualIndexForIcon = (arg1.row-1) * self.iconsInRowForSpacingCalculation + arg1.col - 1;
            // Starting index will be the amount of icons displayed minus the amount in the final row
            NSInteger startingIndex = self.firstFreeSlotIndex - iconsInFinalRow;						// 22 - 2 = 20 index to start at

            // calc and return
            if (actualIndexForIcon >= startingIndex)
                o.x = o.x + (([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) ? -left : +left);

            return o;
        }
    %end
%end

void reloadCurrentPage() {
    [[[[[%c(SBIconController) sharedInstance] _rootFolderController] rootFolderView] currentIconListView] layoutIconsNow];
}

//preference stuff below

#define kIdentifier @"com.falcon.centralprefs"
#define kSettingsChangedNotification (CFStringRef)@"com.falcon.centralprefs/Prefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.falcon.centralprefs.plist"

static void *observer = NULL;

static void reloadPrefs() {
    if ([NSHomeDirectory()isEqualToString:@"/var/mobile"]) {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs)
                prefs = [NSDictionary new];

            CFRelease(keyList);
        }
    } else
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
}

static void preferencesChanged() {
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    _pfTweakEnabled = [prefs objectForKey:@"tweakEnabled"] ? [[prefs valueForKey:@"tweakEnabled"] boolValue] : YES;
	_pfChangeFolderLayout = [prefs objectForKey:@"changeFolderLayout"] ? [[prefs valueForKey:@"changeFolderLayout"] boolValue] : YES;
    _pfChangeLibraryLayout = [prefs objectForKey:@"changeLibraryLayout"] ? [[prefs valueForKey:@"changeLibraryLayout"] boolValue] : YES;

	if (doneWaitingForLoad)reloadCurrentPage();
}

%ctor {
    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        &observer,
        (CFNotificationCallback)preferencesChanged,
        (CFStringRef)@"com.falcon.centralprefs/Prefs",
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){14, 0, 0}])
        %init (Central14);
    else
	    %init (Central13);
}

#include <UIKit/UIKit.h>

static BOOL doneWaitingForLoad = NO;

static BOOL _pfChangeFolderLayout = YES;
static BOOL _pfChangeLibraryLayout = YES;
static BOOL _pfTweakEnabled = YES;
NSDictionary *prefs = nil;

@interface SBIcon : NSObject
@property (nonatomic, assign) NSInteger gridSizeClass;
@end

@interface SBIconListGridLayoutConfiguration : NSObject
@property (assign,nonatomic) UIEdgeInsets portraitLayoutInsets;
@property (assign,nonatomic) UIEdgeInsets landscapeLayoutInsets;
@end

@interface SBIconListGridLayout
@property (nonatomic,copy,readonly) SBIconListGridLayoutConfiguration * layoutConfiguration;
@end

@interface SBIconListView : UIView
-(NSArray *)visibleIcons;
-(void)layoutIconsNow;
-(double)horizontalIconPadding;
@property (assign,getter=isEditing,nonatomic) BOOL editing;
@property (nonatomic,readonly) SBIconListGridLayout* layout; 
@property (nonatomic, assign) NSUInteger firstFreeSlotIndex;
@property (nonatomic, assign) NSInteger iconsInRowForSpacingCalculation;
@property (nonatomic, retain) NSString *iconLocation;
@property (nonatomic,readonly) CGSize alignmentIconSize; 
@end

@interface SBRootFolderView : UIView
-(SBIconListView *)currentIconListView;
@end
@interface SBRootFolderController : UIViewController
-(SBRootFolderView *)rootFolderView;
@end
@interface SBIconController : UIViewController
-(SBRootFolderController *)_rootFolderController;
+(SBIconController *)sharedInstance;
@end

typedef struct SBIconCoordinate {
    NSInteger row;
    NSInteger col;
} SBIconCoordinate;

struct SBIconListLayoutMetrics {
    unsigned long long _field1;
    unsigned long long _field2;
    struct CGSize _field3;
    struct CGSize _field4;
    double _field5;
    struct UIEdgeInsets _field6;
    _Bool _field7;
    _Bool _field8;
};
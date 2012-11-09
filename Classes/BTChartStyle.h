//
//  BTChartStyle.h
//  ChartTest
//
//  Created by Cameron Cooke on 09/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"


@interface BTChartStyle : NSObject

- (CPTMutableLineStyle *)axisLineStyle;
- (CPTMutableLineStyle *)axisMajorTickLineStyle;
- (CPTMutableLineStyle *)axisMinorTickLineStyle;
- (CPTMutableLineStyle *)gridLineStyle;
- (CPTMutableTextStyle *)axisLabelTextStyle;
- (CPTMutableTextStyle *)graphTitleTextStyle;
- (CPTMutableTextStyle *)legendTextStyle;

@end
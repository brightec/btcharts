//
//  BTChartStyle.m
//  ChartTest
//
//  Created by Cameron Cooke on 09/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "BTChartStyle.h"
#import "CPTPlotRange.h"
#import "CPTBorderedLayer.h"
#import "CPTColor.h"
#import "CPTExceptions.h"
#import "CPTFill.h"
#import "CPTGradient.h"
#import "CPTMutableLineStyle.h"
#import "CPTMutableTextStyle.h"
#import "CPTPlotAreaFrame.h"
#import "CPTUtilities.h"
#import "CPTXYAxis.h"
#import "CPTXYAxisSet.h"
#import "CPTXYGraph.h"
#import "CPTXYPlotSpace.h"


NSString *const kBTDefaultTheme = @"BT Default";


@implementation BTChartStyle


- (CPTMutableTextStyle *)graphTitleTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    textStyle.fontSize = 18.0f;
    textStyle.fontName = @"Helvetica-Bold";
    
    return textStyle;
}


- (CPTMutableLineStyle *)axisLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.75f];
    return lineStyle;
}


- (CPTMutableLineStyle *)axisMajorTickLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.75f];
    return lineStyle;
}


- (CPTMutableLineStyle *)axisMinorTickLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.75f];
    return lineStyle;
}


- (CPTMutableLineStyle *)gridLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 1.0f;
    lineStyle.lineColor = [CPTColor lightGrayColor];
    return lineStyle;
}


- (CPTMutableTextStyle *)axisLabelTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    return textStyle;
}


- (CPTMutableTextStyle *)legendTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    return textStyle;
}


- (CPTMutableTextStyle *)plotLabelTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    return textStyle;
}


- (CPTFill *)backgroundFill
{
    return [CPTFill fillWithColor:[CPTColor clearColor]];
}


# pragma mark -
# pragma mark Padding


- (CGFloat)paddingTop
{
    return 0.0f;
}


- (CGFloat)paddingRight
{
    return 0.0f;
}


- (CGFloat)paddingBottom
{
    return 0.0f;
}


- (CGFloat)paddingLeft
{
    return 0.0f;
}


# pragma mark -
# pragma mark CPTTheme


+ (void)load
{
    [self registerTheme:self];
}


+ (NSString *)name
{
    return kBTDefaultTheme;
}


# pragma mark -
# pragma mark Utility methods

-(void)applyThemeToAxis:(CPTXYAxis *)axis
{
    axis.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    axis.majorIntervalLength         = CPTDecimalFromDouble(1.0);
    axis.tickDirection               = CPTSignNone;
    axis.minorTicksPerInterval       = 4;
    axis.majorTickLineStyle          = [self axisMajorTickLineStyle];
    axis.minorTickLineStyle          = [self axisMinorTickLineStyle];
    axis.axisLineStyle               = [self axisLineStyle];
    axis.majorTickLength             = 7.0f;
    axis.minorTickLength             = 5.0f;
    axis.labelTextStyle              = [self axisLabelTextStyle];
    axis.minorTickLabelTextStyle     = [self axisLabelTextStyle];
    axis.titleTextStyle              = [self axisLabelTextStyle];
}


# pragma mark -
# pragma mark Overriden from CPTTheme


- (id)newGraph
{
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    graph.paddingBottom = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingRight = 0.0f;
    graph.titleTextStyle = [self graphTitleTextStyle];
    
    [self applyThemeToGraph:graph];
    
    return graph;
}


- (void)applyThemeToBackground:(CPTGraph *)graph
{
    graph.fill = [self backgroundFill];
}


- (void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{
    plotAreaFrame.paddingLeft = self.paddingLeft;
    plotAreaFrame.paddingTop = self.paddingTop;
    plotAreaFrame.paddingBottom = self.paddingBottom;
    plotAreaFrame.paddingRight = self.paddingRight;
    plotAreaFrame.masksToBounds = NO;
    plotAreaFrame.masksToBorder = NO;
}



- (void)applyThemeToAxisSet:(CPTAxisSet *)axisSet
{
    for (CPTXYAxis *axis in axisSet.axes) {
        [self applyThemeToAxis:axis];
    }
}


@end

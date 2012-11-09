//
//  BTChartStyle.m
//  ChartTest
//
//  Created by Cameron Cooke on 09/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "BTChartStyle.h"

@implementation BTChartStyle


- (CPTMutableTextStyle *)graphTitleTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor whiteColor];
    textStyle.fontSize = 16.0f;
    textStyle.fontName = @"Helvetica";
    return textStyle;
}


- (CPTMutableLineStyle *)axisLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    return lineStyle;
}


- (CPTMutableLineStyle *)axisMajorTickLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    return lineStyle;
}


- (CPTMutableLineStyle *)axisMinorTickLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    return lineStyle;
}


- (CPTMutableLineStyle *)gridLineStyle
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 1.0;
    lineStyle.lineColor = [CPTColor grayColor];
    return lineStyle;
}


- (CPTMutableTextStyle *)axisLabelTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor whiteColor];
    return textStyle;
}


- (CPTMutableTextStyle *)legendTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor whiteColor];
    return textStyle;
}


@end

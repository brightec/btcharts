//
//  BTBarChart.m
//  ChartTest
//
//  Created by Cameron Cooke on 07/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "BTBarChart.h"


@implementation BTBarChart


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allowPinchScaling = NO;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.allowPinchScaling = NO;
    }
    return self;
}


- (void)setupGraph
{
    // query datasource for the number of groups
    NSInteger numberOfGroups = [self.dataSource numberOfPlotGroupsInChart:self];
    if (numberOfGroups == 0) {
        return;
    }

    // call default implementation to setup basic graph
    [super setupGraph];

    // create the plots based on the number of plots in the first group
    NSInteger plotCount = [self.dataSource chart:self numberOfPlotsInGroup:0];
    for (NSInteger i = 0; i < plotCount; i++) {
        
        id<BTPlotDataItem> plotDataItem = [self.dataSource chart:self dataItemForIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

        // create the bar plot and set default values
        CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
        barPlot.dataSource = self;
        barPlot.identifier = @(i);
        barPlot.barCornerRadius = 5.0f;
        barPlot.title = plotDataItem.plotTypeLabel;
        barPlot.labelOffset = 1;
        barPlot.labelTextStyle = [self.style plotLabelTextStyle];

        // set the widths of the plots and offsets to group plots together in a group
        float dataUnitPerPlot = 1.0/plotCount;
        float margin = 0.05;
        float barWidth = dataUnitPerPlot - margin;
        float startX = 0.0-((barWidth*plotCount)/2)+(barWidth/2);
        float barOffset = startX+(i*barWidth);
        barPlot.barWidth = CPTDecimalFromFloat(barWidth);
        barPlot.barOffset = CPTDecimalFromFloat(barOffset);
        
        // set the border for the bar
        CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
        barLineStyle.lineWidth = 1.0;
        barLineStyle.lineColor = [CPTColor blackColor];
        barPlot.lineStyle = barLineStyle;
        
        // fill the bar with a gradient if colours are available from datasource
        if ([self.delegate respondsToSelector:@selector(barChart:startAndEndGradientColorsForPlotItem:)]) {
            NSArray *gradient = [(id)self.delegate barChart:self startAndEndGradientColorsForPlotItem:i];
            if (gradient.count == 2) {
                UIColor *startColour = (UIColor *)gradient[0];
                UIColor *endColour = (UIColor *)gradient[1];
                
                CPTGradient *fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithCGColor:startColour.CGColor] endingColor:[CPTColor colorWithCGColor:endColour.CGColor]];
                barPlot.fill = [CPTFill fillWithGradient:fillGradient];
            }
        }
                
        if ([self.dataSource respondsToSelector:@selector(barChart:willDisplayPlotItem:)]) {
            [self.delegate barChart:self willDisplayPlotItem:barPlot];
        }

        [self.graph addPlot:barPlot];
    }

    [self addHorizontalLegendAtPosition:CPTRectAnchorBottom];


    CPTXYAxis *x = [self xAxis];
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.axisLabels = [self xAxisLabels];

    CPTXYAxis *y = [self yAxis];
    y.minorTicksPerInterval = 0;
    y.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);

    [self setupPlotSpace];
}


# pragma mark -
# pragma mark CPTPlotDataSource

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSInteger numberOfGroups = [self.dataSource numberOfPlotGroupsInChart:self];
    return numberOfGroups;
}


- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSInteger plotItemIndex = [((NSNumber *)plot.identifier) integerValue];
    id<BTPlotDataItem> a = [self.dataSource chart:self dataItemForIndexPath:[NSIndexPath indexPathForRow:plotItemIndex inSection:index]];
    
    switch (fieldEnum) {
        case CPTBarPlotFieldBarTip:
            return @(a.value);
            break;
            
        case CPTBarPlotFieldBarLocation:
            return @(index);
            break;
            
        default:
            break;
    }
    return nil;
}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{   
    NSInteger plotItemIndex = [((NSNumber *)plot.identifier) integerValue];
    id<BTPlotDataItem> a = [self.dataSource chart:self dataItemForIndexPath:[NSIndexPath indexPathForRow:plotItemIndex inSection:index]];

    if ([a.dataLabel isEqualToString:@"0"]) {
        return [[CPTTextLayer alloc] initWithText:@"" style:self.style.plotLabelTextStyle];
    }
    
    return [[CPTTextLayer alloc] initWithText:a.dataLabel style:self.style.plotLabelTextStyle];
}


@end

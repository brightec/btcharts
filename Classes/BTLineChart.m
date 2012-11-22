//
//  BTLineChart.m
//  ChartTest
//
//  Created by Cameron Cooke on 08/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "BTLineChart.h"

@implementation BTLineChart

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

    // create plot symbol
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor blackColor];
	CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor whiteColor]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size		 = CGSizeMake(10.0, 10.0);

    // create the plots based on the number of plots in the first group
    NSInteger plotCount = [self.dataSource chart:self numberOfPlotsInGroup:0];
    for (NSInteger i = 0; i < plotCount; i++) {

        id<BTPlotDataItem> plotDataItem = [self.dataSource chart:self dataItemForIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

        // plot line style
        CPTMutableLineStyle *dataLineStyle = [[CPTLineStyle lineStyle] mutableCopy];
        dataLineStyle.lineColor = [CPTColor whiteColor];
        dataLineStyle.lineWidth = 5.0f;

        // set the line colour based on value from datasource
        if ([self.delegate respondsToSelector:@selector(lineChart:lineColourForPlotItem:)]) {
            UIColor *lineColour = [(id)self.delegate lineChart:self lineColourForPlotItem:i];
            dataLineStyle.lineColor = [CPTColor colorWithCGColor:lineColour.CGColor];
        }

        // create the scatter plot and set default values
        CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
        plot.dataLineStyle = dataLineStyle;
        plot.dataSource = self;
        plot.identifier = @(i);
        plot.title = plotDataItem.plotTypeLabel;
        plot.plotSymbol = plotSymbol;
        plot.labelOffset = 5;
        plot.labelTextStyle = [self.style plotLabelTextStyle];
        
        if ([self.delegate respondsToSelector:@selector(lineChart:willDisplayPlotItem:)]) {
            [self.delegate lineChart:self willDisplayPlotItem:plot];
        }
        
        [self.graph addPlot:plot];
    }

    [self addVerticalLegendAtPosition:CPTRectAnchorRight];

    CPTXYAxis *x = [self xAxis];
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.axisLabels = [self xAxisLabels];

    CPTXYAxis *y = [self yAxis];
    y.minorTicksPerInterval = 0;

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
        case CPTScatterPlotFieldX:
            return @(index);
            break;

        case CPTScatterPlotFieldY:
            return @(a.value);
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

    return [[CPTTextLayer alloc] initWithText:a.dataLabel style:self.style.plotLabelTextStyle];
}


@end

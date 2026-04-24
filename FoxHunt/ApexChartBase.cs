using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.CompilerServices;
    using System.Security;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.VisualBasic;
    using System.Web.UI.WebControls;
    using System.Web.UI;
    using FusionCharts;
    using static FoxHunt.ApexChart;
    using Newtonsoft.Json;
    using static FoxHunt.ApexChart.TooltipFixedOptions;

    public class ApexChart : Panel
    {
        protected LiteralControl content = new LiteralControl();

        #region AI gen bs

        public class ApexChartConfig
        {
            public ChartOptions chart { get; set; }
            public PlotOptions plotOptions { get; set; }
            public DataLabelsOptions dataLabels { get; set; }
            public string[] colors { get; set; }
            public SeriesData[] series { get; set; }
            public GridOptions grid { get; set; }
            public AxisOptions xaxis { get; set; }
            public AxisOptions yaxis { get; set; }
            public LegendOptions legend { get; set; }
            public TooltipOptions tooltip { get; set; }
        }


        public class ChartOptions
        {
            [JsonProperty("type")]
            public string Type { get; set; }

            [JsonProperty("width")]
            public object Width { get; set; } // Can be string or number

            [JsonProperty("height")]
            public object Height { get; set; } // Can be string or number

            [JsonProperty("foreColor")]
            public string ForeColor { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }

            [JsonProperty("toolbar")]
            public ToolbarOptions Toolbar { get; set; }

            [JsonProperty("zoom")]
            public ZoomOptions Zoom { get; set; }

            [JsonProperty("animations")]
            public AnimationsOptions Animations { get; set; }

            [JsonProperty("events")]
            public EventsOptions Events { get; set; }

            [JsonProperty("sparkline")]
            public SparklineOptions Sparkline { get; set; }

            [JsonProperty("dropShadow")]
            public DropShadowOptions DropShadow { get; set; }

            [JsonProperty("id")]
            public string Id { get; set; }

            [JsonProperty("group")]
            public string Group { get; set; }

            [JsonProperty("defaultLocale")]
            public string DefaultLocale { get; set; }

            [JsonProperty("locales")]
            public List<LocaleOptions> Locales { get; set; }
        }

        public class LocaleOptions
        {
            [JsonProperty("name")]
            public string Name { get; set; }
            [JsonProperty("options")]
            public LocaleOptionsDetail options { get; set; }
        }

        public class LocaleOptionsDetail
        {
            [JsonProperty("months")]
            public List<string> Months { get; set; }
            [JsonProperty("shortMonths")]
            public List<string> ShortMonths { get; set; }
            [JsonProperty("days")]
            public List<string> Days { get; set; }
            [JsonProperty("shortDays")]
            public List<string> ShortDays { get; set; }
            [JsonProperty("toolbar")]
            public LocaleToolbarOptions Toolbar { get; set; }
        }

        public class LocaleToolbarOptions
        {
            [JsonProperty("exportToSVG")]
            public string ExportToSVG { get; set; }
            [JsonProperty("exportToPNG")]
            public string ExportToPNG { get; set; }
            [JsonProperty("exportToCSV")]
            public string ExportToCSV { get; set; }
            [JsonProperty("selection")]
            public string Selection { get; set; }
            [JsonProperty("selectionZoom")]
            public string SelectionZoom { get; set; }
            [JsonProperty("selectionXaxis")]
            public string SelectionXaxis { get; set; }
            [JsonProperty("selectionYaxis")]
            public string SelectionYaxis { get; set; }
            [JsonProperty("zoomIn")]
            public string ZoomIn { get; set; }
            [JsonProperty("zoomOut")]
            public string ZoomOut { get; set; }
            [JsonProperty("pan")]
            public string Pan { get; set; }
            [JsonProperty("reset")]
            public string Reset { get; set; }
        }

        public class ToolbarOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("tools")]
            public ToolbarToolsOptions Tools { get; set; }

            [JsonProperty("autoSelected")]
            public string AutoSelected { get; set; }
        }

        public class ToolbarToolsOptions
        {
            [JsonProperty("download")]
            public bool Download { get; set; }

            [JsonProperty("selection")]
            public bool Selection { get; set; }

            [JsonProperty("zoom")]
            public bool Zoom { get; set; }

            [JsonProperty("zoomin")]
            public bool ZoomIn { get; set; }

            [JsonProperty("zoomout")]
            public bool ZoomOut { get; set; }

            [JsonProperty("pan")]
            public bool Pan { get; set; }

            [JsonProperty("reset")]
            public bool Reset { get; set; }

            [JsonProperty("customIcons")]
            public List<ToolbarCustomIconOptions> CustomIcons { get; set; }
        }

        public class ToolbarCustomIconOptions
        {
            [JsonProperty("icon")]
            public string Icon { get; set; }
            [JsonProperty("index")]
            public int Index { get; set; }
            [JsonProperty("title")]
            public string Title { get; set; }
            [JsonProperty("click")]
            public string Click { get; set; }

        }

        public class ZoomOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("type")]
            public string Type { get; set; }

            [JsonProperty("autoScaleYaxis")]
            public bool AutoScaleYaxis { get; set; }
        }

        public class AnimationsOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("easing")]
            public string Easing { get; set; }

            [JsonProperty("speed")]
            public int Speed { get; set; }

            [JsonProperty("animateGradually")]
            public AnimationsAnimateGraduallyOptions AnimateGradually { get; set; }

            [JsonProperty("dynamicAnimation")]
            public AnimationsDynamicAnimationOptions DynamicAnimation { get; set; }
        }

        public class AnimationsAnimateGraduallyOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }
            [JsonProperty("delay")]
            public int Delay { get; set; }
        }

        public class AnimationsDynamicAnimationOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }
            [JsonProperty("speed")]
            public int Speed { get; set; }
        }

        public class EventsOptions
        {
            // ... (Add event handlers as needed) ...
        }

        public class SparklineOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }
        }

        public class DropShadowOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("top")]
            public int Top { get; set; }

            [JsonProperty("left")]
            public int Left { get; set; }

            [JsonProperty("blur")]
            public int Blur { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }
        }

        public class DataLabelsOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("enabledOnSeries")]
            public List<int> EnabledOnSeries { get; set; }

            [JsonProperty("textAnchor")]
            public string TextAnchor { get; set; }

            [JsonProperty("distributed")]
            public bool Distributed { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }

            [JsonProperty("background")]
            public DataLabelsBackgroundOptions Background { get; set; }

            [JsonProperty("dropShadow")]
            public DropShadowOptions DropShadow { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class DataLabelsBackgroundOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("foreColor")]
            public string ForeColor { get; set; }

            [JsonProperty("padding")]
            public int Padding { get; set; }

            [JsonProperty("borderRadius")]
            public int BorderRadius { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }

            [JsonProperty("dropShadow")]
            public DropShadowOptions DropShadow { get; set; }
        }

        public class StrokeOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("curve")]
            public string Curve { get; set; }

            [JsonProperty("lineCap")]
            public string LineCap { get; set; }

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("width")]
            public object Width { get; set; } // Can be int or list of ints

            [JsonProperty("dashArray")]
            public object DashArray { get; set; } // Can be int or list of ints
        }

        public class FillOptions
        {
            [JsonProperty("type")]
            public object Type { get; set; } // Can be string or list of strings

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("gradient")]
            public GradientOptions Gradient { get; set; }

            [JsonProperty("opacity")]
            public object Opacity { get; set; } // Can be number or list of numbers

            [JsonProperty("image")]
            public FillImageOptions Image { get; set; }

            [JsonProperty("pattern")]
            public FillPatternOptions Pattern { get; set; }
        }

        public class FillImageOptions
        {
            [JsonProperty("src")]
            public List<string> Src { get; set; }

            [JsonProperty("width")]
            public int Width { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }
        }

        public class FillPatternOptions
        {
            [JsonProperty("style")]
            public string Style { get; set; }

            [JsonProperty("width")]
            public int Width { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }

            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }
        }

        public class MarkersOptions
        {
            [JsonProperty("size")]
            public object Size { get; set; } // Can be int or list of ints

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("strokeColors")]
            public List<string> StrokeColors { get; set; }

            [JsonProperty("strokeWidth")]
            public object StrokeWidth { get; set; } // Can be int or list of ints

            [JsonProperty("strokeOpacity")]
            public double StrokeOpacity { get; set; }

            [JsonProperty("strokeDashArray")]
            public object StrokeDashArray { get; set; } // Can be int or list of ints

            [JsonProperty("fillOpacity")]
            public double FillOpacity { get; set; }

            [JsonProperty("discrete")]
            public List<MarkersDiscreteOptions> Discrete { get; set; }

            [JsonProperty("shape")]
            public object Shape { get; set; } // Can be string or list of strings

            [JsonProperty("radius")]
            public int Radius { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("onClick")]
            public string OnClick { get; set; } // JavaScript function as string

            [JsonProperty("onDblClick")]
            public string OnDblClick { get; set; } // JavaScript function as string

            [JsonProperty("hover")]
            public MarkersHoverOptions Hover { get; set; }
        }

        public class MarkersDiscreteOptions
        {
            [JsonProperty("seriesIndex")]
            public int SeriesIndex { get; set; }

            [JsonProperty("dataPointIndex")]
            public int DataPointIndex { get; set; }

            [JsonProperty("fillColor")]
            public string FillColor { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }

            [JsonProperty("size")]
            public int Size { get; set; }

            [JsonProperty("shape")]
            public string Shape { get; set; }
        }

        public class MarkersHoverOptions
        {
            [JsonProperty("size")]
            public int Size { get; set; }

            [JsonProperty("sizeOffset")]
            public int SizeOffset { get; set; }
        }

        public class TooltipOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("enabledOnSeries")]
            public List<int> EnabledOnSeries { get; set; }

            [JsonProperty("shared")]
            public bool Shared { get; set; }

            [JsonProperty("followCursor")]
            public bool FollowCursor { get; set; }

            [JsonProperty("intersect")]
            public bool Intersect { get; set; }

            [JsonProperty("inverseOrder")]
            public bool InverseOrder { get; set; }

            [JsonProperty("custom")]
            public string Custom { get; set; } // JavaScript function as string

            [JsonProperty("fillSeriesColor")]
            public bool FillSeriesColor { get; set; }

            [JsonProperty("theme")]
            public string Theme { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }

            [JsonProperty("x")]
            public TooltipOptions X { get; set; }

            [JsonProperty("y")]
            public TooltipOptions Y { get; set; }

            [JsonProperty("z")]
            public TooltipZOptions Z { get; set; }

            [JsonProperty("marker")]
            public TooltipMarkerOptions Marker { get; set; }

            [JsonProperty("items")]
            public TooltipItemsOptions Items { get; set; }

            [JsonProperty("fixed")]
            public TooltipFixedOptions Fixed { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class TooltipXOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("format")]
            public string Format { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class TooltipYOptions
        {
            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string

            [JsonProperty("title")]
            public TooltipYTitleOptions Title { get; set; }
        }

        public class TooltipYTitleOptions
        {
            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class TooltipZOptions
        {
            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string

            [JsonProperty("title")]
            public string Title { get; set; }
        }

        public class TooltipMarkerOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }
        }

        public class TooltipItemsOptions
        {
            [JsonProperty("display")]
            public string Display { get; set; }
        }

        public class TooltipFixedOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("position")]
            public string Position { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

            public class AxisOptions
        {
            [JsonProperty("type")]
            public string Type { get; set; }

            [JsonProperty("categories")]
            public List<String> Categories { get; set; } // Can be list of strings or numbers

            [JsonProperty("title")]
            public TitleSubtitleOptions Title { get; set; }

            [JsonProperty("labels")]
            public AxisLabelsOptions Labels { get; set; }

            [JsonProperty("axisBorder")]
            public AxisBorderOptions AxisBorder { get; set; }

            [JsonProperty("axisTicks")]
            public AxisTicksOptions AxisTicks { get; set; }

            [JsonProperty("crosshairs")]
            public CrosshairsOptions Crosshairs { get; set; }

            [JsonProperty("tickAmount")]
            public int? TickAmount { get; set; }

            [JsonProperty("tickPlacement")]
            public string TickPlacement { get; set; }

            [JsonProperty("min")]
            public double? Min { get; set; }

            [JsonProperty("max")]
            public double? Max { get; set; }

            [JsonProperty("forceNiceScale")]
            public bool ForceNiceScale { get; set; }

            [JsonProperty("reversed")]
            public bool Reversed { get; set; }

            [JsonProperty("logarithmic")]
            public bool Logarithmic { get; set; }

            [JsonProperty("position")]
            public string Position { get; set; }
        }

        public class LegendOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("showForSingleSeries")]
            public bool ShowForSingleSeries { get; set; }

            [JsonProperty("showForNullSeries")]
            public bool ShowForNullSeries { get; set; }

            [JsonProperty("showForZeroSeries")]
            public bool ShowForZeroSeries { get; set; }

            [JsonProperty("position")]
            public string Position { get; set; }

            [JsonProperty("horizontalAlign")]
            public string HorizontalAlign { get; set; }

            [JsonProperty("floating")]
            public bool Floating { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string

            [JsonProperty("inverseOrder")]
            public bool InverseOrder { get; set; }

            [JsonProperty("width")]
            public object Width { get; set; } // Can be string or number

            [JsonProperty("height")]
            public object Height { get; set; } // Can be string or number

            [JsonProperty("tooltipHoverFormatter")]
            public string TooltipHoverFormatter { get; set; } // JavaScript function as string

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("labels")]
            public LegendLabelsOptions Labels { get; set; }

            [JsonProperty("markers")]
            public LegendMarkersOptions Markers { get; set; }

            [JsonProperty("itemMargin")]
            public LegendItemMarginOptions ItemMargin { get; set; }

            [JsonProperty("onItemClick")]
            public LegendOnItemClickOptions OnItemClick { get; set; }

            [JsonProperty("onItemHover")]
            public LegendOnItemHoverOptions OnItemHover { get; set; }
        }

        public class LegendLabelsOptions
        {
            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("useSeriesColors")]
            public bool UseSeriesColors { get; set; }
        }

        public class LegendMarkersOptions
        {
            [JsonProperty("width")]
            public int Width { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }

            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }

            [JsonProperty("fillColors")]
            public List<string> FillColors { get; set; }

            [JsonProperty("radius")]
            public int Radius { get; set; }

            [JsonProperty("customHTML")]
            public string CustomHTML { get; set; } // JavaScript function as string
        }

        public class LegendItemMarginOptions
        {
            [JsonProperty("horizontal")]
            public int Horizontal { get; set; }

            [JsonProperty("vertical")]
            public int Vertical { get; set; }
        }

        public class LegendOnItemClickOptions
        {
            [JsonProperty("toggleDataSeries")]
            public bool ToggleDataSeries { get; set; }
        }

        public class LegendOnItemHoverOptions
        {
            [JsonProperty("highlightDataSeries")]
            public bool HighlightDataSeries { get; set; }
        }

        public class PlotOptions
        {
            [JsonProperty("bar")]
            public PlotOptionsBarOptions Bar { get; set; }

            [JsonProperty("line")]
            public PlotOptionsLineOptions Line { get; set; }

            [JsonProperty("area")]
            public PlotOptionsAreaOptions Area { get; set; }

            [JsonProperty("radar")]
            public PlotOptionsRadarOptions Radar { get; set; }

            [JsonProperty("pie")]
            public PlotOptionsPieOptions Pie { get; set; }

            [JsonProperty("donut")]
            public PlotOptionsDonutOptions Donut { get; set; }

            [JsonProperty("radialBar")]
            public PlotOptionsRadialBarOptions RadialBar { get; set; }

            [JsonProperty("polarArea")]
            public PlotOptionsPolarAreaOptions PolarArea { get; set; }

            [JsonProperty("candlestick")]
            public PlotOptionsCandlestickOptions Candlestick { get; set; }

            [JsonProperty("boxPlot")]
            public PlotOptionsBoxPlotOptions BoxPlot { get; set; }

            [JsonProperty("heatmap")]
            public PlotOptionsHeatmapOptions Heatmap { get; set; }

            [JsonProperty("treemap")]
            public PlotOptionsTreemapOptions Treemap { get; set; }
        }

        public class PlotOptionsBarOptions
        {
            [JsonProperty("horizontal")]
            public bool Horizontal { get; set; }

            [JsonProperty("barHeight")]
            public string BarHeight { get; set; }

            [JsonProperty("distributed")]
            public bool Distributed { get; set; }

            [JsonProperty("borderRadius")]
            public int BorderRadius { get; set; }

            [JsonProperty("startingShape")]
            public string StartingShape { get; set; }

            [JsonProperty("columnWidth")]
            public string ColumnWidth { get; set; }

            [JsonProperty("rangeBarGroupRows")]
            public bool RangeBarGroupRows { get; set; }

            [JsonProperty("colors")]
            public PlotOptionsBarColorsOptions Colors { get; set; }

            [JsonProperty("dataLabels")]
            public PlotOptionsBarDataLabelsOptions DataLabels { get; set; }
        }

        public class PlotOptionsBarColorsOptions
        {
            [JsonProperty("ranges")]
            public List<PlotOptionsBarColorsRangeOptions> Ranges { get; set; }

            [JsonProperty("backgroundBarColors")]
            public List<string> BackgroundBarColors { get; set; }

            [JsonProperty("backgroundBarOpacity")]
            public double BackgroundBarOpacity { get; set; }

            [JsonProperty("backgroundBarRadius")]
            public int BackgroundBarRadius { get; set; }
        }

        public class PlotOptionsBarColorsRangeOptions
        {
            [JsonProperty("from")]
            public double From { get; set; }

            [JsonProperty("to")]
            public double To { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }
        }

        public class PlotOptionsBarDataLabelsOptions
        {
            [JsonProperty("position")]
            public string Position { get; set; }

            [JsonProperty("maxItems")]
            public int MaxItems { get; set; }

            [JsonProperty("hideOverflowingLabels")]
            public bool HideOverflowingLabels { get; set; }

            [JsonProperty("orientation")]
            public string Orientation { get; set; }
        }

        public class PlotOptionsLineOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("curve")]
            public string Curve { get; set; }

            [JsonProperty("stepped")]
            public bool Stepped { get; set; }

            [JsonProperty("cap")]
            public string Cap { get; set; }

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }
        }

        public class PlotOptionsAreaOptions
        {
            [JsonProperty("fillTo")]
            public string FillTo { get; set; }

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }
        }

        public class PlotOptionsRadarOptions
        {
            [JsonProperty("size")]
            public object Size { get; set; } // Can be int or string

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("polygons")]
            public PlotOptionsRadarPolygonsOptions Polygons { get; set; }
        }

        public class PlotOptionsRadarPolygonsOptions
        {
            [JsonProperty("strokeColors")]
            public string StrokeColors { get; set; }

            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("fill")]
            public PlotOptionsRadarPolygonsFillOptions Fill { get; set; }
        }

        public class PlotOptionsRadarPolygonsFillOptions
        {
            [JsonProperty("colors")]
            public List<string> Colors { get; set; }
        }

        public class PlotOptionsPieOptions
        {
            [JsonProperty("startAngle")]
            public int StartAngle { get; set; }

            [JsonProperty("endAngle")]
            public int EndAngle { get; set; }

            [JsonProperty("expandOnClick")]
            public bool ExpandOnClick { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("customScale")]
            public double CustomScale { get; set; }

            [JsonProperty("dataLabels")]
            public PlotOptionsPieDataLabelsOptions DataLabels { get; set; }

            [JsonProperty("donut")]
            public PlotOptionsPieDonutOptions Donut { get; set; }

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }
        }

        public class PlotOptionsPieDataLabelsOptions
        {
            [JsonProperty("offset")]
            public int Offset { get; set; }

            [JsonProperty("minAngleToShowLabel")]
            public int MinAngleToShowLabel { get; set; }
        }

        public class PlotOptionsPieDonutOptions
        {
            [JsonProperty("size")]
            public string Size { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }

            [JsonProperty("labels")]
            public PlotOptionsPieDonutLabelsOptions Labels { get; set; }
        }

        public class PlotOptionsPieDonutLabelsOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("name")]
            public PlotOptionsPieDonutLabelsNameOptions Name { get; set; }

            [JsonProperty("value")]
            public PlotOptionsPieDonutLabelsValueOptions Value { get; set; }

            [JsonProperty("total")]
            public PlotOptionsPieDonutLabelsTotalOptions Total { get; set; }
        }

        public class PlotOptionsPieDonutLabelsNameOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class PlotOptionsPieDonutLabelsValueOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class PlotOptionsPieDonutLabelsTotalOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("label")]
            public string Label { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class PlotOptionsDonutOptions
        {
            [JsonProperty("size")]
            public string Size { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }

            [JsonProperty("labels")]
            public PlotOptionsDonutLabelsOptions Labels { get; set; }
        }

        public class PlotOptionsDonutLabelsOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("name")]
            public PlotOptionsDonutLabelsNameOptions Name { get; set; }

            [JsonProperty("value")]
            public PlotOptionsDonutLabelsValueOptions Value { get; set; }

            [JsonProperty("total")]
            public PlotOptionsDonutLabelsTotalOptions Total { get; set; }
        }

        public class PlotOptionsDonutLabelsNameOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class PlotOptionsDonutLabelsValueOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class PlotOptionsDonutLabelsTotalOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("label")]
            public string Label { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class PlotOptionsRadialBarOptions
        {
            [JsonProperty("startAngle")]
            public int StartAngle { get; set; }

            [JsonProperty("endAngle")]
            public int EndAngle { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("inverseOrder")]
            public bool InverseOrder { get; set; }

            [JsonProperty("hollow")]
            public PlotOptionsRadialBarHollowOptions Hollow { get; set; }

            [JsonProperty("track")]
            public PlotOptionsRadialBarTrackOptions Track { get; set; }

            [JsonProperty("dataLabels")]
            public PlotOptionsRadialBarDataLabelsOptions DataLabels { get; set; }
        }

        public class PlotOptionsRadialBarHollowOptions
        {
            [JsonProperty("margin")]
            public int Margin { get; set; }

            [JsonProperty("size")]
            public string Size { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }

            [JsonProperty("image")]
            public string Image { get; set; }

            [JsonProperty("width")]
            public int Width { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class PlotOptionsRadialBarTrackOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("startAngle")]
            public int StartAngle { get; set; }

            [JsonProperty("endAngle")]
            public int EndAngle { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }

            [JsonProperty("strokeWidth")]
            public string StrokeWidth { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }

            [JsonProperty("margin")]
            public int Margin { get; set; }

            [JsonProperty("dropShadow")]
            public DropShadowOptions DropShadow { get; set; }
        }

        public class PlotOptionsRadialBarDataLabelsOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("name")]
            public PlotOptionsRadialBarDataLabelsNameOptions Name { get; set; }

            [JsonProperty("value")]
            public PlotOptionsRadialBarDataLabelsValueOptions Value { get; set; }

            [JsonProperty("total")]
            public PlotOptionsRadialBarDataLabelsTotalOptions Total { get; set; }
        }

        public class PlotOptionsRadialBarDataLabelsNameOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class PlotOptionsRadialBarDataLabelsValueOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class PlotOptionsRadialBarDataLabelsTotalOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("label")]
            public string Label { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class PlotOptionsPolarAreaOptions
        {
            [JsonProperty("rings")]
            public PlotOptionsPolarAreaRingsOptions Rings { get; set; }

            [JsonProperty("spokes")]
            public PlotOptionsPolarAreaSpokesOptions Spokes { get; set; }
        }

        public class PlotOptionsPolarAreaRingsOptions
        {
            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }
        }

        public class PlotOptionsPolarAreaSpokesOptions
        {
            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }
        }

        public class PlotOptionsCandlestickOptions
        {
            [JsonProperty("colors")]
            public PlotOptionsCandlestickColorsOptions Colors { get; set; }

            [JsonProperty("wick")]
            public PlotOptionsCandlestickWickOptions Wick { get; set; }
        }

        public class PlotOptionsCandlestickColorsOptions
        {
            [JsonProperty("upward")]
            public string Upward { get; set; }

            [JsonProperty("downward")]
            public string Downward { get; set; }
        }

        public class PlotOptionsCandlestickWickOptions
        {
            [JsonProperty("useFillColor")]
            public bool UseFillColor { get; set; }
        }
        public class PlotOptionsBoxPlotOptions
        {
            [JsonProperty("colors")]
            public PlotOptionsBoxPlotColorsOptions Colors { get; set; }
        }

        public class PlotOptionsBoxPlotColorsOptions
        {
            [JsonProperty("upper")]
            public string Upper { get; set; }

            [JsonProperty("lower")]
            public string Lower { get; set; }
        }

        public class PlotOptionsHeatmapOptions
        {
            [JsonProperty("radius")]
            public int Radius { get; set; }

            [JsonProperty("enableShades")]
            public bool EnableShades { get; set; }

            [JsonProperty("shadeIntensity")]
            public double ShadeIntensity { get; set; }

            [JsonProperty("distributed")]
            public bool Distributed { get; set; }

            [JsonProperty("useFillColorAsStroke")]
            public bool UseFillColorAsStroke { get; set; }

            [JsonProperty("reverseNegativeShade")]
            public bool ReverseNegativeShade { get; set; }

            [JsonProperty("colorScale")]
            public PlotOptionsHeatmapColorScaleOptions ColorScale { get; set; }
        }

        public class PlotOptionsHeatmapColorScaleOptions
        {
            [JsonProperty("ranges")]
            public List<PlotOptionsHeatmapColorScaleRangeOptions> Ranges { get; set; }
        }

        public class PlotOptionsHeatmapColorScaleRangeOptions
        {
            [JsonProperty("from")]
            public double From { get; set; }

            [JsonProperty("to")]
            public double To { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("name")]
            public string Name { get; set; }
        }

        public class PlotOptionsTreemapOptions
        {
            [JsonProperty("enableShades")]
            public bool EnableShades { get; set; }

            [JsonProperty("shadeIntensity")]
            public double ShadeIntensity { get; set; }

            [JsonProperty("distributed")]
            public bool Distributed { get; set; }

            [JsonProperty("reverseNegativeShade")]
            public bool ReverseNegativeShade { get; set; }

            [JsonProperty("colorScale")]
            public PlotOptionsTreemapColorScaleOptions ColorScale { get; set; }
        }

        public class PlotOptionsTreemapColorScaleOptions
        {
            [JsonProperty("ranges")]
            public List<PlotOptionsTreemapColorScaleRangeOptions> Ranges { get; set; }
        }

        public class PlotOptionsTreemapColorScaleRangeOptions
        {
            [JsonProperty("from")]
            public double From { get; set; }

            [JsonProperty("to")]
            public double To { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("name")]
            public string Name { get; set; }
        }

        // ... (Sub-classes for PlotOptions: PlotOptionsBarOptions, PlotOptionsLineOptions, etc.) ...
        //Please note that these plot options have many sub options.

        public class ResponsiveOptions
        {
            [JsonProperty("breakpoint")]
            public int Breakpoint { get; set; }

            [JsonProperty("options")]
            public ApexChartOptions Options { get; set; }
        }

        public class GridOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("borderColor")]
            public string BorderColor { get; set; }

            [JsonProperty("strokeDashArray")]
            public int StrokeDashArray { get; set; }

            [JsonProperty("position")]
            public string Position { get; set; }

            [JsonProperty("xaxis")]
            public GridXAxisOptions XAxis { get; set; }

            [JsonProperty("yaxis")]
            public GridYAxisOptions YAxis { get; set; }

            [JsonProperty("row")]
            public GridRowOptions Row { get; set; }

            [JsonProperty("column")]
            public GridColumnOptions Column { get; set; }

            [JsonProperty("padding")]
            public GridPaddingOptions Padding { get; set; }
        }

        public class GridXAxisOptions
        {
            [JsonProperty("lines")]
            public GridLinesOptions Lines { get; set; }
        }

        public class GridYAxisOptions
        {
            [JsonProperty("lines")]
            public GridLinesOptions Lines { get; set; }
        }

        public class GridLinesOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }
        }

        public class GridRowOptions
        {
            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }
        }

        public class GridColumnOptions
        {
            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }
        }

        public class GridPaddingOptions
        {
            [JsonProperty("top")]
            public int Top { get; set; }

            [JsonProperty("right")]
            public int Right { get; set; }

            [JsonProperty("bottom")]
            public int Bottom { get; set; }

            [JsonProperty("left")]
            public int Left { get; set; }
        }

        public class AnnotationsOptions
        {
            [JsonProperty("points")]
            public List<AnnotationsPointOptions> Points { get; set; }

            [JsonProperty("xaxis")]
            public List<AnnotationsXAxisOptions> XAxis { get; set; }

            [JsonProperty("yaxis")]
            public List<AnnotationsYAxisOptions> YAxis { get; set; }

            [JsonProperty("positioning")]
            public string Positioning { get; set; }

            [JsonProperty("texts")]
            public List<AnnotationsTextOptions> Texts { get; set; }

            [JsonProperty("images")]
            public List<AnnotationsImageOptions> Images { get; set; }
        }

        public class AnnotationsPointOptions
        {
            [JsonProperty("x")]
            public object X { get; set; } // Can be number or string

            [JsonProperty("y")]
            public object Y { get; set; } // Can be number or string

            [JsonProperty("seriesIndex")]
            public int SeriesIndex { get; set; }

            [JsonProperty("marker")]
            public AnnotationsPointMarkerOptions Marker { get; set; }

            [JsonProperty("label")]
            public AnnotationsPointLabelOptions Label { get; set; }
        }

        public class AnnotationsPointMarkerOptions
        {
            [JsonProperty("size")]
            public int Size { get; set; }

            [JsonProperty("fillColor")]
            public string FillColor { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }

            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("shape")]
            public string Shape { get; set; }

            [JsonProperty("radius")]
            public int Radius { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class AnnotationsPointLabelOptions
        {
            [JsonProperty("borderColor")]
            public string BorderColor { get; set; }

            [JsonProperty("borderWidth")]
            public int BorderWidth { get; set; }

            [JsonProperty("borderRadius")]
            public int BorderRadius { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }

            [JsonProperty("text")]
            public string Text { get; set; }

            [JsonProperty("textAnchor")]
            public string TextAnchor { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }
        }

        public class AnnotationsXAxisOptions
        {
            [JsonProperty("x")]
            public object X { get; set; } // Can be number or string

            [JsonProperty("x2")]
            public object X2 { get; set; } // Can be number or string

            [JsonProperty("strokeDashArray")]
            public int StrokeDashArray { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }

            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("fillColor")]
            public string FillColor { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }

            [JsonProperty("label")]
            public AnnotationsXAxisLabelOptions Label { get; set; }
        }

        public class AnnotationsXAxisLabelOptions
        {
            [JsonProperty("text")]
            public string Text { get; set; }

            [JsonProperty("textAnchor")]
            public string TextAnchor { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }

            [JsonProperty("borderColor")]
            public string BorderColor { get; set; }

            [JsonProperty("borderWidth")]
            public int BorderWidth { get; set; }

            [JsonProperty("borderRadius")]
            public int BorderRadius { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }
        }

        public class AnnotationsYAxisOptions
        {
            [JsonProperty("y")]
            public object Y { get; set; } // Can be number or string

            [JsonProperty("y2")]
            public object Y2 { get; set; } // Can be number or string

            [JsonProperty("strokeDashArray")]
            public int StrokeDashArray { get; set; }

            [JsonProperty("strokeColor")]
            public string StrokeColor { get; set; }

            [JsonProperty("strokeWidth")]
            public int StrokeWidth { get; set; }

            [JsonProperty("fillColor")]
            public string FillColor { get; set; }

            [JsonProperty("opacity")]
            public double Opacity { get; set; }

            [JsonProperty("label")]
            public AnnotationsYAxisLabelOptions Label { get; set; }
        }

        public class AnnotationsYAxisLabelOptions
        {
            [JsonProperty("text")]
            public string Text { get; set; }

            [JsonProperty("textAnchor")]
            public string TextAnchor { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }

            [JsonProperty("borderColor")]
            public string BorderColor { get; set; }

            [JsonProperty("borderWidth")]
            public int BorderWidth { get; set; }

            [JsonProperty("borderRadius")]
            public int BorderRadius { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }
        }

        public class AnnotationsTextOptions
        {
            [JsonProperty("x")]
            public object X { get; set; } // Can be number or string

            [JsonProperty("y")]
            public object Y { get; set; } // Can be number or string

            [JsonProperty("text")]
            public string Text { get; set; }

            [JsonProperty("textAnchor")]
            public string TextAnchor { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }

            [JsonProperty("borderColor")]
            public string BorderColor { get; set; }

            [JsonProperty("borderWidth")]
            public int BorderWidth { get; set; }

            [JsonProperty("borderRadius")]
            public int BorderRadius { get; set; }

            [JsonProperty("background")]
            public string Background { get; set; }
        }

        public class AnnotationsImageOptions
        {
            [JsonProperty("path")]
            public string Path { get; set; }

            [JsonProperty("x")]
            public object X { get; set; } // Can be number or string

            [JsonProperty("y")]
            public object Y { get; set; } // Can be number or string

            [JsonProperty("width")]
            public int Width { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        // ... (Sub-classes for AnnotationsOptions: AnnotationsPointOptions, AnnotationsXAxisOptions, etc.) ...
        //Please note that these annotation options have many sub options.

        public class StatesOptions
        {
            [JsonProperty("normal")]
            public StatesNormalOptions Normal { get; set; }

            [JsonProperty("hover")]
            public StatesHoverOptions Hover { get; set; }

            [JsonProperty("active")]
            public StatesActiveOptions Active { get; set; }
        }

        public class StatesNormalOptions
        {
            [JsonProperty("filter")]
            public StatesFilterOptions Filter { get; set; }
        }

        public class StatesHoverOptions
        {
            [JsonProperty("filter")]
            public StatesFilterOptions Filter { get; set; }
        }

        public class StatesActiveOptions
        {
            [JsonProperty("filter")]
            public StatesFilterOptions Filter { get; set; }
        }

        public class StatesFilterOptions
        {
            [JsonProperty("type")]
            public string Type { get; set; }

            [JsonProperty("value")]
            public double Value { get; set; }
        }

        public class AxisLabelsOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("rotate")]
            public int Rotate { get; set; }

            [JsonProperty("rotateAlways")]
            public bool RotateAlways { get; set; }

            [JsonProperty("hideOverlappingLabels")]
            public bool HideOverlappingLabels { get; set; }

            [JsonProperty("trim")]
            public bool Trim { get; set; }

            [JsonProperty("minHeight")]
            public int MinHeight { get; set; }

            [JsonProperty("maxWidth")]
            public int MaxWidth { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("format")]
            public string Format { get; set; }

            [JsonProperty("formatter")]
            public string Formatter { get; set; } // JavaScript function as string
        }

        public class AxisBorderOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }

            [JsonProperty("width")]
            public string Width { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class AxisTicksOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("borderType")]
            public string BorderType { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("height")]
            public int Height { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }
        }

        public class CrosshairsOptions
        {
            [JsonProperty("show")]
            public bool Show { get; set; }

            [JsonProperty("width")]
            public object Width { get; set; } // Can be string or number

            [JsonProperty("stroke")]
            public CrosshairsStrokeOptions Stroke { get; set; }

            [JsonProperty("fill")]
            public CrosshairsFillOptions Fill { get; set; }

            [JsonProperty("dropShadow")]
            public DropShadowOptions DropShadow { get; set; }
        }

        public class CrosshairsStrokeOptions
        {
            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("width")]
            public int Width { get; set; }

            [JsonProperty("dashArray")]
            public int DashArray { get; set; }
        }

        public class CrosshairsFillOptions
        {
            [JsonProperty("type")]
            public string Type { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("gradient")]
            public GradientOptions Gradient { get; set; }
        }

        public class GradientOptions
        {
            [JsonProperty("shade")]
            public string Shade { get; set; }

            [JsonProperty("type")]
            public string Type { get; set; }

            [JsonProperty("shadeIntensity")]
            public double ShadeIntensity { get; set; }

            [JsonProperty("gradientToColors")]
            public List<string> GradientToColors { get; set; }

            [JsonProperty("inverseColors")]
            public bool InverseColors { get; set; }

            [JsonProperty("opacityFrom")]
            public double OpacityFrom { get; set; }

            [JsonProperty("opacityTo")]
            public double OpacityTo { get; set; }

            [JsonProperty("stops")]
            public List<int> Stops { get; set; }
        }

        public class ApexChartOptions
        {
            // Core Chart Options
            [JsonProperty("chart")]
            public ChartOptions Chart { get; set; }

            [JsonProperty("series")]
            public List<SeriesData> Series { get; set; }

            [JsonProperty("xaxis")]
            public AxisOptions XAxis { get; set; }

            [JsonProperty("yaxis")]
            public List<AxisOptions> YAxis { get; set; }

            [JsonProperty("labels")]
            public List<string> Labels { get; set; }

            [JsonProperty("colors")]
            public List<string> Colors { get; set; }

            [JsonProperty("title")]
            public TitleSubtitleOptions Title { get; set; }

            [JsonProperty("subtitle")]
            public TitleSubtitleOptions Subtitle { get; set; }

            [JsonProperty("dataLabels")]
            public DataLabelsOptions DataLabels { get; set; }

            [JsonProperty("stroke")]
            public StrokeOptions Stroke { get; set; }

            [JsonProperty("fill")]
            public FillOptions Fill { get; set; }

            [JsonProperty("markers")]
            public MarkersOptions Markers { get; set; }

            [JsonProperty("tooltip")]
            public TooltipOptions Tooltip { get; set; }

            [JsonProperty("legend")]
            public LegendOptions Legend { get; set; }

            [JsonProperty("plotOptions")]
            public PlotOptions PlotOptions { get; set; }

            [JsonProperty("responsive")]
            public List<ResponsiveOptions> Responsive { get; set; }

            [JsonProperty("grid")]
            public GridOptions Grid { get; set; }

            [JsonProperty("annotations")]
            public AnnotationsOptions Annotations { get; set; }

            [JsonProperty("states")]
            public StatesOptions States { get; set; }

            [JsonProperty("theme")]
            public ThemeOptions Theme { get; set; }
        }

        public class ThemeOptions
        {
            [JsonProperty("mode")]
            public string Mode { get; set; }

            [JsonProperty("palette")]
            public string Palette { get; set; }

            [JsonProperty("monochrome")]
            public ThemeMonochromeOptions Monochrome { get; set; }
        }

        public class ThemeMonochromeOptions
        {
            [JsonProperty("enabled")]
            public bool Enabled { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }

            [JsonProperty("shadeTo")]
            public string ShadeTo { get; set; }

            [JsonProperty("shadeIntensity")]
            public double ShadeIntensity { get; set; }
        }

        // Sub-Classes (Example: ChartOptions)

        // Example: SeriesData

        public class SeriesData
        {
            [JsonProperty("name")]
            public string Name { get; set; }

            [JsonProperty("data")]
            public List<object> Data { get; set; } // Can be numbers, dates, objects, etc.
        }

        // Example: TitleSubtitleOptions
        public class TitleSubtitleOptions
        {
            [JsonProperty("text")]
            public string Text { get; set; }

            [JsonProperty("align")]
            public string Align { get; set; }

            [JsonProperty("margin")]
            public int Margin { get; set; }

            [JsonProperty("offsetX")]
            public int OffsetX { get; set; }

            [JsonProperty("offsetY")]
            public int OffsetY { get; set; }

            [JsonProperty("floating")]
            public bool Floating { get; set; }

            [JsonProperty("style")]
            public TextStyleOptions Style { get; set; }
        }

        // Example: TextStyleOptions
        public class TextStyleOptions
        {
            [JsonProperty("fontSize")]
            public string FontSize { get; set; }

            [JsonProperty("fontFamily")]
            public string FontFamily { get; set; }

            [JsonProperty("fontWeight")]
            public string FontWeight { get; set; }

            [JsonProperty("color")]
            public string Color { get; set; }
        }

        #endregion

        public ApexChartOptions Options = new ApexChartOptions();
        public enum ChartType
        {
            line,
            area,
            bar,
            column,
            boxPlot,
            candlestick,
            rangeBar,
            rangeArea,
            heatmap,
            treemap,
            funnel,
            multiAxis,
            pie,
            donut,
            radar,
            radialBar,
            circularGauge,
            synchronizedCharts
        }

        protected override void Render(System.Web.UI.HtmlTextWriter writer)
        {
            writer.Write("<script>$(function(){" + OutputJS(this.ClientID)+ "})</script>");
            base.Render(writer);
        }

        public string OutputJS(string chartContainerId)
        {
            var settings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore, // Ignore null properties during serialization
                Formatting = Formatting.None // Remove unnecessary whitespace
            };

            string jsonOptions = JsonConvert.SerializeObject(this.Options, settings);

            // Escape backslashes and single quotes for JavaScript
            jsonOptions = jsonOptions.Replace("\\", "\\\\").Replace("'", "\\'");

            StringBuilder jsBuilder = new StringBuilder();
            jsBuilder.AppendLine($"var options_{chartContainerId} = {jsonOptions};");
            jsBuilder.AppendLine($"var chart_{chartContainerId} = new ApexCharts(document.querySelector('#{chartContainerId}'), options_{chartContainerId});");
            jsBuilder.AppendLine($"chart_{chartContainerId}.render();");

            return jsBuilder.ToString();
        }

        //        private string getContent()
        //        {
        //            var js = $@"
        // <script type='text/javascript'> 
        //  const analyticsBarChartEl = document.querySelector('#{this.ID}'),
        //    analyticsBarChartConfig = {{
        //      chart: {{
        //        height: 260,
        //        type: 'bar',
        //        toolbar: {{
        //          show: false
        //        }}
        //      }],
        //      plotOptions: {
        //        bar: {
        //          horizontal: false,
        //          columnWidth: '20%',
        //          borderRadius: 3,
        //          startingShape: 'rounded'
        //        }
        //      },
        //      dataLabels: {
        //        enabled: false
        //      },
        //      colors: [config.colors.primary, config.colors_label.primary],
        //      series: [
        //        {
        //          name: '2020',
        //          data: [8, 9, 15, 20, 14, 22, 29, 27, 13]
        //        },
        //        {
        //          name: '2019',
        //          data: [5, 7, 12, 17, 9, 17, 26, 21, 10]
        //        }
        //      ],
        //      grid: {
        //        borderColor: borderColor
        //      },
        //      xaxis: {
        //        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
        //        axisBorder: {
        //          show: false
        //        },
        //        axisTicks: {
        //          show: false
        //        },
        //        labels: {
        //          style: {
        //            colors: labelColor
        //          }
        //        }
        //      },
        //      yaxis: {
        //        min: 0,
        //        max: 30,
        //        tickAmount: 3,
        //        labels: {
        //          style: {
        //            colors: labelColor
        //          }
        //        }
        //      },
        //      legend: {
        //        show: false
        //      },
        //      tooltip: {
        //        y: {
        //          formatter: function (val) {
        //            return '$ ' + val + ' thousands';
        //          }
        //        }
        //      }
        //    };
        //  if (typeof analyticsBarChartEl !== undefined && analyticsBarChartEl !== null) {
        //    const analyticsBarChart = new ApexCharts(analyticsBarChartEl, analyticsBarChartConfig);
        //    analyticsBarChart.render();
        //  }
        //";
        //            return "  " + Constants.vbCrLf + "     var " + var + " = new FusionCharts(\"" + swf + "\", \"" + swfid + "\", \"" + this.Width.Value + "\", \"" + this.Height.Value + "\", \"0\", \"1\");" + Constants.vbCrLf + xml + Constants.vbCrLf + var + ".addParam(\"wmode\", \"opaque\");" + Constants.vbCrLf + var + ".render(\"" + innerpnl.ClientID + "\");" + Constants.vbCrLf + "   </script> " + Constants.vbCrLf;
        //        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            registerControl(this.Page);

        }

        /// <summary>
        /// Registers all necessary javascript and css files for this control to function on the page.
        /// </summary>
        /// <param name="page"></param>
        /// <remarks></remarks>
        [System.ComponentModel.Description("Registers all necessary javascript and css files for this control to function on the page.")]
        public static void registerControl(Page page)
        {
            if (page != null)
            {
                jQueryLibrary.jQueryInclude.addScriptFile(page, "/assets/vendor/libs/apex-charts/apexcharts.js",useFullPath:true);
                jQueryLibrary.jQueryInclude.addScriptFile(page, "/assets/vendor/libs/apex-charts/apex-charts.css", useFullPath: true);
            }
        }

 

        public static System.Drawing.Color parseColor(string hexstring)
        {
            try
            {
                int r = int.Parse(hexstring.Substring(0, 2), System.Globalization.NumberStyles.HexNumber);
                int g = int.Parse(hexstring.Substring(2, 2), System.Globalization.NumberStyles.HexNumber);
                int b = int.Parse(hexstring.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
                return System.Drawing.Color.FromArgb(r, g, b);
            }
            catch (Exception ex)
            {
                return System.Drawing.Color.Black; /* TODO Change to default(_) if this is not a reference type */;
            }
        }

        public static string getColorHex(System.Drawing.Color color)
        {
            if (color == null )
                return null;
            try
            {
                return string.Format("{0:X2}{1:X2}{2:X2}", color.R, color.G, color.B);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }

}
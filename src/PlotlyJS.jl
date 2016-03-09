module PlotlyJS

using JSON
using Blink
using Colors

using Base.Dates

# globals for this package
const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")
const _finance_js_path = joinpath(dirname(dirname(@__FILE__)),
                                  "deps", "plotlyjs-finance.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"
const _js_finance_cdn_path =
    "https://cdn.rawgit.com/etpinard/plotlyjs-finance/master/plotlyjs-finance.js"

# include these here because they are used below
include("traces_layouts.jl")
abstract AbstractPlotlyDisplay

# core plot object
type Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
end

# include the rest of the core parts of the package
include("json.jl")
include("display.jl")
include("subplots.jl")
include("api.jl")
include("savefig.jl")

# Set some defaults for constructing `Plot`s
Plot() = Plot(GenericTrace{Dict{Symbol,Any}}[], Layout(), Base.Random.uuid4())

Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout()) =
    Plot(data, layout, Base.Random.uuid4())

Plot(data::AbstractTrace, layout=Layout()) = Plot([data], layout)

# NOTE: we export trace constructing types from inside api.jl
export

    # core types
    Plot, GenericTrace, Layout, ElectronDisplay, JupyterDisplay,
    ElectronPlot, JupyterPlot,

    # other methods
    savefig, svg_data, png_data, jpeg_data, webp_data,

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!,
    extendtraces!, prependtraces!,

    # non-!-versions (forks, then applies, then returns fork)
    restyle, relayout, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces,

    # helper methods
    plot, fork

#=
open = [33.01, 33.31, 33.50, 32.06, 34.12, 33.05, 33.31, 33.50]
high = [34.20, 34.37, 33.62, 34.25, 35.18, 33.25, 35.37, 34.62]
low = [31.70, 30.75, 32.87, 31.62, 30.81, 32.75, 32.75, 32.87]
close = [34.10, 31.93, 33.37, 33.18, 31.18, 33.10, 32.93, 33.70]
dates = collect(Date(2014, 1, 1):Day(1):Date(2014, 1, length(open)))
o = OHLCTrace(open, high, low, close, dates)
d = dates[1]
=#

end # module

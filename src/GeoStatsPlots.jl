module GeoStatsPlots

using GeoStatsBase
using Variography
using RecipesBase
using StatsBase
using Distances
using Meshes

include("geostatsbase/problems/estimation.jl")
include("geostatsbase/problems/learning.jl")
include("geostatsbase/problems/simulation.jl")
include("geostatsbase/ensembles.jl")
include("geostatsbase/histograms.jl")
include("geostatsbase/hscatter.jl")
include("geostatsbase/weighting.jl")

include("variography/empirical.jl")
include("variography/theoretical.jl")
include("variography/varioplane.jl")

end

using GeoStatsPlots
using Variography
using GeoStatsBase
using GeoStatsImages
using CSV
using Meshes
using Distributions
using DelimitedFiles
using Plots; gr(size=(600, 400))
using ReferenceTests, ImageIO
using Test, Random

# workaround for GR warnings
ENV["GKSwstype"] = "100"

datadir = joinpath(@__DIR__, "data")

@testset "GeoStatsPlots.jl" begin
  include("geostatsbase.jl")
  include("variography.jl")
end

using GeoStatsPlots
using Variography
using GeoStatsBase
using GeoStatsImages
using Meshes
using DelimitedFiles
using Plots; gr(size=(600, 400))
using ReferenceTests, ImageIO
using Test

# workaround for GR warnings
ENV["GKSwstype"] = "100"

datadir = joinpath(@__DIR__, "data")

@testset "GeoStatsPlots.jl" begin
  include("variography.jl")
end

@testset "GeoStatsBase.jl" begin
  @testset "Problems" begin
    data2D = georef(CSV.File(joinpath(datadir, "data2D.tsv")), (:x, :y))
    grid2D = CartesianGrid(100, 100)

    @testset "Estimation" begin
      problem2D = EstimationProblem(data2D, grid2D, :value)
      @test_reference "data/estimation.png" plot(problem2D, ms=2)
    end

    @testset "Simulation" begin
      problem2D = SimulationProblem(data2D, grid2D, :value, 100)
      @test_reference "data/simulation.png" plot(problem2D, ms=2)
    end

    @testset "Learning" begin
      rng = MersenneTwister(42)
      sdata = georef((x=rand(rng, 10), y=rand(rng, 10), z=rand(rng, 10)), 10rand(rng, 2, 10))
      tdata = georef((x=rand(rng, 10, 10),))
      rtask = RegressionTask(:x, :y)
      ctask = ClusteringTask(:x, :c)

      problem = LearningProblem(sdata, tdata, ctask)
      @test_reference "data/learning.png" plot(problem, ms=2)
    end
  end

  @testset "Ensembles" begin
    d = CartesianGrid(10, 10)
    r = (z=[1:100 for i in 1:10],)
    s = Ensemble(d, r)
    @test_reference "data/ensemble.png" plot(s, size=(800, 300))
  end

  @testset "EmpiricalHistogram" begin
    rng = MersenneTwister(42)
    z₁ = randn(rng, 10000)
    z₂ = z₁ + randn(rng, 10000)
    d = georef((z₁=z₁, z₂=z₂), CartesianGrid(100, 100))
    h1 = EmpiricalHistogram(d, :z₁)
    h2 = EmpiricalHistogram(d, :z₂)

    @test_reference "data/histogram1.png" plot(h1)
    @test_reference "data/histogram2.png" plot(h2)
  end

  @testset "HScatter" begin
    sdata = georef(CSV.File(joinpath(datadir, "samples2D.tsv")), (:x, :y))
    p0 = hscatter(sdata, :value, lag=0)
    p1 = hscatter(sdata, :value, lag=1)
    p2 = hscatter(sdata, :value, lag=2)
    p3 = hscatter(sdata, :value, lag=3)
    plt = plot(p0, p1, p2, p3, layout=(2, 2), size=(600, 600))
    @test_reference "data/hscatter.png" plt
  end

  @testset "Weighting" begin
    @testset "DensityRatioWeighting" begin
      rng = MersenneTwister(123)

      r1 = Normal(0, 2)
      r2 = MixtureModel([Normal(-2, 1), Normal(2, 2)], [0.2, 0.8])

      n  = 1000
      z1 = sort(rand(rng, r1, n))
      z2 = sort(rand(rng, r2, n))

      d1 = georef((z=z1,), PointSet(reshape(1:n, 1, :)))
      d2 = georef((z=z2,), PointSet(reshape(1:n, 1, :)))

      dre = LSIF(rng=rng)

      w = weight(d1, DensityRatioWeighting(d2, estimator=dre))

      plt = plot(z1, pdf.(r1, z1), size=(800, 400), label="source")
      plot!(z1, pdf.(r2, z1), label="target")
      plot!(z1, w .* pdf.(r1, z1), label="approx")
      @test_reference "data/densratio.png" plt
    end
  end
end

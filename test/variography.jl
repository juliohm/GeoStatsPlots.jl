@testset "Variography.jl" begin
  @testset "Empirical" begin
    wl = geostatsimage("WalkerLake")
    TI = asarray(wl, :Z)[1:20,1:20]
    d = georef((z=TI,))
    γ = EmpiricalVariogram(d, :z, maxlag=15.0)
    @test_reference "data/empirical.png" plot(γ)
  end

  @testset "Theoretical" begin
    # stationary variogram models
    γs = [
      NuggetEffect(), GaussianVariogram(), ExponentialVariogram(),
      MaternVariogram(), SphericalVariogram(), SphericalVariogram(range=2.0), 
      CubicVariogram(), PentasphericalVariogram(), SineHoleVariogram()
    ]

    # non-stationary variogram models
    γn = [PowerVariogram(), PowerVariogram(exponent=0.4)]

    plt1 = plot()
    for γ ∈ γs
      plot!(plt1, γ)
    end

    plt2 = plot()
    for γ ∈ γn
      plot!(plt2, γ)
    end

    plt = plot(plt1, plt2, size=(600, 800), layout=(2, 1))
    @test_reference "data/theoretical.png" plt
  end

  @testset "Varioplane" begin
    img = readdlm(joinpath(datadir, "anisotropic.tsv"))
    data = georef((z=img,))
    γ = EmpiricalVarioplane(data, :z, maxlag=50.0)

    @test_reference "data/varioplane.png" plot(γ)
  end
end

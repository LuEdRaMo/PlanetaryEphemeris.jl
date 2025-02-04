using ArgParse, PlanetaryEphemeris, Dates

function parse_commandline()

    s = ArgParseSettings()
    
    # Program name (for usage & help screen)
    s.prog = "integrate_ephemeris.jl"  
    # Desciption (for help screen)
    s.description = "Integrates JPL DE430 Ephemeris" 

    @add_arg_table! s begin
        "--maxsteps"
            help = "Maximum number of steps during integration"
            arg_type = Int
            default = 1_000_000 
        "--jd0"
            help = "Starting time of integration; options are: \"2000-01-01T12:00:00\" or \"1969-06-28T00:00:00\""
            arg_type = DateTime
            default = DateTime(2000, 1, 1, 12) # DateTime(1969, 6, 28, 0, 0, 0)
        "--nyears"
            help = "Number of years"
            arg_type = Float64
            default = 31.0
        "--dynamics"
            help = "Dynamical model function"
            arg_type = Function
            default = DE430!
        "--nast"
            help = "Number of asteroid perturbers"
            arg_type = Int
            default = 343 # 16
        "--order"
            help = "Order of Taylor polynomials expansions during integration"
            arg_type = Int
            default = 25
        "--abstol"
            help = "Absolute tolerance"
            arg_type = Float64
            default = 1.0E-20
        "--parse_eqs"
            help = "Whether to use the taylorized method of jetcoeffs (a-priori faster) or not"
            arg_type = Bool
            default = true 
        "--bodyind"
            help = "Body indices in output"
            arg_type = UnitRange{Int}
            default = 1:(11+16) # 1:(11+nast)
            # bodyind = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 30, 40, 41, 46, 55, 62, 73, 113, 115, 277, 322] # SS + 25 ast perturbers
    end

    s.epilog = """
        examples:\n
        \n
        # Multi-threaded\n
        julia -t 4 --project integrate_ephemeris.jl --maxsteps 100 --jd0 "2000-01-01T12:00:00"\n
        \n
        # Single-threaded\n
        julia --project integrate_ephemeris.jl --maxsteps 100 --jd0 "2000-01-01T12:00:00"\n
        \n
    """

    return parse_args(s)
end

function main(maxsteps::Int, jd0_datetime::DateTime, nyears::Float64, dynamics::Function, nast::Int,
              bodyind::UnitRange{Int}, order::Int, abstol::Float64, parse_eqs::Bool)

    println("*** Integrate Ephemeris ***")
    println("Number of threads: ", Threads.nthreads())
    println("Dynamical function: ", dynamics) 
    
    jd0 = datetime2julian(jd0_datetime) 
    println( "Initial time of integration: ", string(jd0_datetime) )
    println( "Final time of integration: ", string(julian2datetime(jd0 + nyears*yr)) )
    
    println("*** Integrator warmup ***")
    _ = propagate(1, jd0, nyears, Val(true), dynamics = dynamics, nast = nast, order = order, abstol = abstol, 
                  parse_eqs = parse_eqs)
    println("*** Finished warmup ***")
    
    println("*** Full integration ***")
    sol = propagate(maxsteps, jd0, nyears, Val(true), dynamics = dynamics, nast = nast, order = order, abstol = abstol, 
                    parse_eqs = parse_eqs)
    println("*** Finished full integration ***")

    # Total number of bodies (Sun + 8 Planets + Moon + Pluto + Asteroids)
    N = 11 + nast

    selecteph2jld2(sol, bodyind, nyears, N)

    nothing 
end 

function main()

    parsed_args = parse_commandline()

    maxsteps = parsed_args["maxsteps"] :: Int
    jd0_datetime = parsed_args["jd0"] :: DateTime
    nyears = parsed_args["nyears"] :: Float64
    dynamics = parsed_args["dynamics"] :: Function
    nast = parsed_args["nast"] :: Int 
    bodyind = parsed_args["bodyind"] :: UnitRange{Int}
    order = parsed_args["order"] :: Int
    abstol = parsed_args["abstol"] :: Float64
    parse_eqs = parsed_args["parse_eqs"] :: Bool

    main(maxsteps, jd0_datetime, nyears, dynamics, nast, bodyind, order, abstol, parse_eqs)
    
end

main()

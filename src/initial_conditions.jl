function initialcond(N)
    # output from JPL Horizons

    q0 = Array{Float64}(undef, 6N) #initial condition array

    #sun
    i = 1
    q0[3i-2:3i]         .= [-0.001540802671596509, 0.004388892781614234, 0.0018586387984276204]
    q0[3(N+i)-2:3(N+i)] .= [-6.1097519947560104e-6, -1.9315720527799756e-6, -7.092564632949261e-7]
    #mercury
    i = 2
    q0[3i-2:3i]         .= [0.30463855240994336, -0.22392628728480796, -0.15184871660133695]
    q0[3(N+i)-2:3(N+i)] .= [0.013061958045043438, 0.020301299145881607, 0.009489733386709897]
    #venus
    i = 3
    q0[3i-2:3i]         .= [-0.237072014577044, -0.6270407380775972, -0.2673243807990398]
    q0[3(N+i)-2:3(N+i)] .= [0.018988211994487827, -0.005631644544426741, -0.0037355365661481976]
    #earth
    i = 4
    q0[3i-2:3i]         .= [1.0014019963481986, 0.023596413386838894, 0.01018195925304404]
    q0[3(N+i)-2:3(N+i)] .= [-0.000639155607893068, 0.015722602165727708, 0.0068170176732665335]
    #moon
    i = 5
    q0[3i-2:3i]         .= [1.0003674329783419, 0.025641175831289952, 0.011164916510692924]
    q0[3(N+i)-2:3(N+i)] .= [-0.0011956034264746331, 0.015524326306986554, 0.006676849606816583]
    #mars
    i = 6
    q0[3i-2:3i]         .= [-1.2709605314621826, -0.867850830272076, -0.3639208032155522]
    q0[3(N+i)-2:3(N+i)] .= [0.008879230398263898, -0.009029298818909542, -0.004381331767030986]

    #jupiter
    i = 7
    q0[3i-2:3i]         .= [2.0771280406511172, -4.307585374501204, -1.8969919781861626]
    q0[3(N+i)-2:3(N+i)] .= [0.006810526029641662, 0.003190231984050905, 0.001201585413837322]
    #saturn
    i = 8
    q0[3i-2:3i]         .= [-8.903241825277508, 2.4585721880959657, 1.3987545633343754]
    q0[3(N+i)-2:3(N+i)] .= [-0.0019775344130014273, -0.004960690616673104, -0.001963830282375045]
    #uranus
    i = 9
    q0[3i-2:3i]         .= [19.82869761020428, -2.8804184773825035, -1.5420039075829257]
    q0[3(N+i)-2:3(N+i)] .= [0.000608657359345998, 0.003390327455820013, 0.001476271782483505]
    #neptune
    i = 10
    q0[3i-2:3i]         .= [23.97437761296792, -16.522725639437446, -7.359720948896526]
    q0[3(N+i)-2:3(N+i)] .= [0.0018698352579216142, 0.002353940265223346, 0.0009169282216591951]
    #pluto
    i = 11
    q0[3i-2:3i]         .= [0.14160785233474332, -30.07832275196099, -9.429182840340573]
    q0[3(N+i)-2:3(N+i)] .= [0.003196231513762523, -0.00018940559697633584, -0.001022122301484864]
    # fill initial conditions for 343 asteroids selected for construction of JPL DE430 ephemeris
    ast343ic = readdlm( joinpath(dirname(pathof(PlanetaryEphemeris)), "ast343ic.txt") )
    for i in 12:N
        q0[3i-2:3i]         .= ast343ic[i-11, 1:3]
        q0[3(N+i)-2:3(N+i)] .= ast343ic[i-11, 4:6]
    end
    return q0
end

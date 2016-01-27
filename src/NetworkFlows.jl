### Julia module for Network Flows algorithms
__precompile__() # Precompile option for the module. Is recompiled after changes

module NetworkFlows

# Items to be exported
export Network # constructors
export zero_to_one! # index the nodes from 1 to n instead of 0 to (n-1) for the vectors in Julia
export print # redefinition of the print function for Network
export edmondsKarp # max-flow
export mincut # min-cut
export connectivity # connectivity (max-flow on the unweighted graph)
export kishimoto # multiroute flow
export breakingPoints # of the extended multiroute flow function
export mixedMLA, successMLA # Solution to Network Interdiction/ MLA problems

include("links.jl")
include("network.jl")
include("io.jl")
include("search.jl")
include("flow.jl")
include("cut.jl")
include("extmrflow.jl")
include("mla.jl")

end # module

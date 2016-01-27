### Julia module for Network Flows algorithms
__precompile__() # Precompile option for the module. Is recompiled after changes

module NetworkFlows

# Items to be exported
export Network # constructors
export edmondsKarp # max-flow
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

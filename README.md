## NetworkFlows.jl

[![Build Status](https://travis-ci.org/Azzaare/NetworkFlows.jl.svg?branch=master)](https://travis-ci.org/Azzaare/NetworkFlows.jl)

The documentation is still in progress (so is the package).

NetworkFlows.jl is a Julia package that provides network flows algorithms. The design of this package is based on simple and fast flow algorithms. On mid/long term, it could be merged with other graphs packages in Julia (Graphs.jl,LightGraph.jl, etc).
All data structures and algorithms are implemented in *pure Julia*, and thus they are portable.


### Main Features

The network/graph structure used in *NetworkFlows.jl* tries to optimize the access time for Augmenting Shortest Paths max-flow algorithm. The structure is as follows:
* The graph is simple (no parallel links) and the links are oriented (arcs)
* The links are ordered by (tail,head) and adjacent in a Vector{Arc}. The type Arc has 3 fields: sym::Int for the symmetric(reverse) arc, head::Int for the index of the head node, and cap:Float64 for the value of its capacity. At the import/construction of the graph, a reverse link is added (unless it already exists).
* The nodes are indexed starting from 1 (as the Vectors in julia). The function zero_to_one!() can be used on the links to transform a set of links starting from 0.
* The IO are currently supporting manual input, DIMACS and CSV format input, and redefinition of print(::Network). Example of files for IO are in ioexample/ .
* List of available algorithms:
    - max-flow (Edmonds-Karp): edmondsKarp(g::Network)
    - connectivity(g::Network)
    - multiroute flow (Kishimoto): kishimoto(g::Network, k::Int) where k is the number of routes
    - min-cut (BFS on maxflow): mincut(g::Network)
    - Extended Multiroute Flow (k is a non-integer parameter): breakingPoints(g::Network)
    - Multilink Attack (upper and lower bounds; success rate): mixedMLA(g::Network) and successMLA(g::Network)


### Documentation (starter)

Examples of use are given in the test/runtest.jl

To get started with a simple graph:

edges = [(1,2,2.),(1,3,3.),(1,4,5.),(2,5,2.),(3,5,3.),(4,5,5.),(5,6,3.),(5,7,3.),(5,8,3.),(6,9,3.),(7,9,3.),(8,9,3.),(9,10,7.),(9,11,7.),(10,12,7.),(11,12,7.)]

  g = Network(edges,true,1,12)

  mixedMLA(g)

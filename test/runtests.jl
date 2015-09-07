using NetworkFlows
using Base.Test

## Test link.jl ##
import NetworkFlows.zero_to_one!
@test zero_to_one!([(0,1),(1,2)]) == [(1,2),(2,3)]
@test zero_to_one!([(3,1),(1,2)]) != [(3,1),(1,2)]
@test zero_to_one!([(0,1,1.),(1,2,2.)]) == [(1,2,1.),(2,3,2.)]
@test zero_to_one!([(3,1,0.),(1,2,-2.1)]) != [(3,1,0.),(1,2,-2.1)]

import NetworkFlows.Arc, NetworkFlows.ghostArc, NetworkFlows.simpleArc
@test isequal(Arc(0,1,0.), ghostArc(1))
@test Arc(0,2,1.) == simpleArc(2)

## Test network.jl


## Test io.jl

## Test search.jl

## Test flow.jl

## Test cut.jl

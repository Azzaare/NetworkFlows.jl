using NetworkFlows
using Base.Test

## Test link.jl ##
@test zero_to_one!([(0,1),(1,2)]) == [(1,2),(2,3)]
@test zero_to_one!([(3,1),(1,2)]) != [(3,1),(1,2)]
@test zero_to_one!([(0,1,1.),(1,2,2.)]) == [(1,2,1.),(2,3,2.)]
@test zero_to_one!([(3,1,0.),(1,2,-2.1)]) != [(3,1,0.),(1,2,-2.1)]

## Test network.jl

## Test io.jl

## Test search.jl

## Test flow.jl

## Test cut.jl

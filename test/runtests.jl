using NetworkFlows
using Base.Test

## Test link.jl ##
import NetworkFlows.zero_to_one!
@test zero_to_one!([(0,1),(1,2)]) == [(1,2),(2,3)]
@test zero_to_one!([(3,1),(1,2)]) != [(3,1),(1,2)]
@test zero_to_one!([(0,1,1.),(1,2,2.)]) == [(1,2,1.),(2,3,2.)]
@test zero_to_one!([(3,1,0.),(1,2,-2.1)]) != [(3,1,0.),(1,2,-2.1)]

import NetworkFlows.Arc, NetworkFlows.ghostArc, NetworkFlows.simpleArc
@test Arc(0,1,0.).sym == ghostArc(1).sym
@test Arc(0,1,0.).head == ghostArc(1).head
@test Arc(0,1,0.).cap == ghostArc(1).cap
@test Arc(0,2,1.).sym == simpleArc(2).sym
@test Arc(0,2,1.).head == simpleArc(2).head
@test Arc(0,2,1.).cap == simpleArc(2).cap

## Test network.jl
g1 = Network(1,2,[1,2,2],[Arc(0,2,1.)])
g2 = Network(2,1,[1,2,2],[simpleArc(2)])
@test g1.source == g2.target
@test g2.source == g1.target
@test g1.tails == g2.tails
@test length(g1.links) == length(g2.links)
@test findArc(g1,1,2) == findArc(g2,1,2)

## Test io.jl

## Test search.jl

## Test flow.jl

## Test cut.jl

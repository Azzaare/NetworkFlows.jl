## Min-cut algorithms using max-flow subroutine

# Min-cut from bfs on classical max-flow
function mincut(g::Network, request = :EdmondsKarp)
  if request == :EdmondsKarp
    val, flows = edmondsKarp(g)
  end
#  println(flows)
  cut = bfs(g,:MinCut,flows)
  return val, cut
end

# α_k of a cut
function partSum(g::Network,cutedges::Vector{Int},k::Int)
  Σ = Vector{Float64}()
  for i in cutedges
    push!(Σ,g.links[i].cap)
  end
  sort!(Σ)
  return sum(Σ[1:end-k])
end

function bestMinkCut(g::Network,cuts::Vector{Vector{Int}},k::Int)
  function aux(cutedges)
    partSum(g,cutedges,k)
  end
  return minimum(map(aux,cuts))
end

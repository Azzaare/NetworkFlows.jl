## Min-cut algorithms using max-flow subroutine

# Min-cut from bfs on classical max-flow
function mincut(g::Network, request = :EdmondsKarp)
  if request == :EdmondsKarp
    val, flows = edmondsKarp(g)
  end

  cut = bfs(g,:MinCut,flows)
  return val, cut
end

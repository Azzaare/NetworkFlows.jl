## Flow algorithms: maxflow, multirouteflow, connectivity

# Classical max-flow algorithm
function edmondsKarp(g::Network)
  flows = zeros(length(g.links))
  flow = 0.0

  while true
    u = g.source
    p, x = bfs(g,:Path,flows)
    if x == 0
      break
    end
    for v in p[2:end]
      i = findArc(g,u,v)
      rev = (g.links[i]).sym
      flows[i] = flows[i] + x
      flows[rev] = flows[rev] - x
      u = v
    end
    flow = flow + x
  end
  return (flow,flows)
end

#Connectivity
function connectivity(g::Network)
  function unweight(a::Arc)
    if a.cap == 0.
      return a
    else
      return Arc(a.sym,a.head,1.)
    end
  end
  arcs = map(unweight,g.links)
  gaux = Network(g.source,g.target,g.tails,arcs)
  λ, flows = edmondsKarp(gaux)
  return λ
end

# Multirouteflow
function kishimoto(g0::Network,k::Int)
  #Init
  i = 1
  flow,flows = edmondsKarp(g0)
  p = flow / k
  function restrict(a::Arc)
    Arc(a.sym,a.head,min(p,a.cap))
  end
  arcs = map(restrict,g0.links)
  g = Network(g0.source,g0.target,g0.tails,arcs)
  flow,flows = edmondsKarp(g)

  #Loop
  while flow < k * p
    p = (flow - i * p)/(k - i)
    i = i + 1
    g.links = map(restrict,g0.links)
    flow,flows = edmondsKarp(g)
  end
  #End
  return flow,flows
end

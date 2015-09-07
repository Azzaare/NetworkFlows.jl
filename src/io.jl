## Input/Output functions for networks
# import
import Base.print

# Printing function
function print(g::Network)
  n = length(g.tails) - 1
  m = 0
  str = string()
  for (id,start) in enumerate(g.tails[1:n])
    stop = g.tails[id+1] - 1
    str *= "node $id :"
    for a in g.links[start:stop]
      if a.cap > 0
        aux = (a.head,a.cap)
        str *= " $aux"
        m += 1
      end
    end
    str *= "\n"
  end
  str2 = "The network has $n nodes and $m links."
  str2 *= "The source node is $(g.source) and the sink node is $(g.target).\n"
  str = str2 * str
  print(str)
end

# Network input in natural graph description
function Network(links::Vector{Link}, directed::Bool, s::Int, t::Int)
  if directed
    links, n = addReverseLinks(links)
  else
    links, n = orientLinks(links)
  end
  sort!(links)
  l = length(links)
  tails = zeros(Int,n+1)
  tails[n+1] = l + 1
  arcs = Vector{Arc}()
  sizehint!(arcs, l)

  function findSymmetric(a::Link)
    start = tails[a[2]]
    stop = tails[a[2]+1] - 1
    for (id,e) in enumerate(arcs[start:stop])
      if e.head == a[1]
        return start + id - 1
      end
    end
    return 0
  end

  tail = 0
  for (id,a) in enumerate(links)
    if tail < a[1]
      for i in tail+1:a[1]
        tails[i] = id
      end
      tail = a[1]
    end
    if a[1] < a[2]
      push!(arcs,Arc(0,a[2],a[3]))
    else
      rev = findSymmetric(a)
      asym = arcs[rev]
      asym.sym = id
      push!(arcs,Arc(rev,a[2],a[3]))
    end
  end

  Network(s,t,tails,arcs)
end

function Network(links::Vector{SimpleLink}, directed::Bool, s::Int, t::Int)
  Network(map(weightLink, links), directed, s, t)
end

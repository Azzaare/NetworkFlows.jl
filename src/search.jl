## File with graph search algorithms (BFS, path, etc...)

# BFS algorithm for Network
function bfsPath(g::Network, flows = zeros(length(g.links)))
  n = length(g.tails) - 1
  colors = zeros(Int,n) # unvisited = 0; open = 1; closed = 2
  paths = zeros(Int,n,n)

  # Init
  colors[1] = 1
  queue = [(g.source,typemax(Float64),1)]

  while !isempty(queue)
    v, flow, endofpath = pop!(queue)
    paths[v,endofpath] = v
    if v == g.target
          return (paths[v,1:endofpath], flow)
    end
    for (id,e) in enumerate(g.links[g.tails[v]:(g.tails[v+1]-1)])
      x = e.cap - flows[g.tails[v] + id - 1]
      if (x > 0) && (colors[e.head] == 0)
        pathflow = min(flow,x)
        q = (e.head, pathflow, endofpath + 1)
        push!(queue,q)
        colors[e.head] = 1
        paths[e.head,:] = paths[v,:]
      end
    end
    colors[v] = 2
  end
  return ([0],0.)
end

function bfsMinCut(g::Network, flows = zeros(length(g.links)))
  n = length(g.tails) - 1
  colors = zeros(Int,n) # unvisited = 0; open = 1; closed = 2
  cutedges = Vector{Int}()

  # Init
  colors[g.source] = 1
  queue = [g.source]

  while !isempty(queue)
    v = pop!(queue)
    for (id,e) in enumerate(g.links[g.tails[v]:(g.tails[v+1]-1)])
      if (e.cap > flows[id]) && (colors[e.head] == 0)
        colors[v]=1
        q = e.head
        push!(queue,q)
      end
    end
    colors[v] = 2
  end

  for (tail,v) in enumerate(g.tails[1:n])
    for (id,a) in enumerate(g.links[g.tails[tail]:(g.tails[tail+1]-1)])
      if (colors[tail] - colors[a.head] == 2)
#        push!(cutedges,g.links[id+v-1].sym)
       push!(cutedges,id+v-1)
      end
    end
  end
  return cutedges
end

function bfs(g::Network, request::Symbol, flows = zeros(length(g.links)))
  if request == :Path
    bfsPath(g,flows)
  elseif request == :MinCut
    bfsMinCut(g, flows)
  end
end

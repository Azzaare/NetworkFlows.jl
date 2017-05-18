## Definition of different types of links

# Link is used to define natural encoding of networks by users
# i.e. (tail,head,[capacity])
const Link = Tuple{Int,Int,Float64}
const SimpleLink = Tuple{Int,Int} # Unweighted links

function weightLink(l::SimpleLink,c::Float64)
  Link(l[1],l[2],c)
end
function weightLink(l::SimpleLink)
  weightLink(l,1.)
end

function zero_to_one!(links::Vector{Link})
  for (id,a) in enumerate(links)
    links[id] = (a[1] + 1, a[2] + 1, a[3])
  end
  return links
end
function zero_to_one!(links::Vector{SimpleLink})
  for (id,a) in enumerate(links)
    links[id] = (a[1] + 1, a[2] + 1)
  end
  return links
end

function addReverseLinks(links::Vector{Link})
  arcs = Vector{Link}()
  sizehint!(arcs, 2*length(links))
  n = 0
  for (id,a) in enumerate(links)
    push!(arcs,a)
    push!(arcs,(a[2],a[1],0.))
    n = max(n,a[1],a[2])
  end
  return arcs, n
end
function orientLinks(links::Vector{Link})
  arcs = Vector{Link}()
  sizehint!(arcs, 2*length(links))
  n = 0
  for (id,a) in enumerate(links)
    push!(arcs,a)
    push!(arcs,a[2],a[1],a[3])
    n = max(n,a[1],a[2])
  end
  return arcs, n
end

# Arc are oriented links. The network used a mixed adjacency list, i.e. nodes
# adjacency with storage of reverse arc (sym).
type Arc
  sym::Int
  head::Int
  cap::Float64
end
function Arc(h::Int,c::Float64)
  return Arc(0,h,c)
end
function ghostArc(h::Int)
  return Arc(0,h,0.)
end
function simpleArc(h::Int)
  return Arc(0,h,1.)
end

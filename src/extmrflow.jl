## Algorithm to compute/approximate the MLA values from extended multiroute flow

# Get the slope of the restricted flow function at a given restriction x
function getSlope(g::Network,restriction::Float64,cutedges::Vector{Int})
  slope = 0
  for id in cutedges
    if g.links[id].cap > restriction
      slope += 1
    end
  end
  return slope
end
function getFlowSlope(g::Network,g0::Network,restriction::Float64)
  flow, cutedges = mincut(g)
  slope = getSlope(g0,restriction,cutedges)
  return flow, slope, cutedges
end


# Make a copy of a network with a restricted value on the links capacity
function restriction(x::Float64,g::Network)
  function restrict(a::Arc)
    Arc(a.sym,a.head,min(x,a.cap))
  end
  arcs = map(restrict,g.links)
  new_g = Network(g.source,g.target,g.tails,arcs)
  return new_g
end

function intersection(x1,y1,a1,x2,y2,a2)
  b1 = y1 - a1 * x1
  b2 = y2 - a2 * x2
  x = (b2 - b1)/(a1 - a2)
  y = a1 * x + b1
#  println("$y1 = $a1 * $x1 + $b1")
#  println("$y2 = $a2 * $x2 + $b2")
#  println("x=$x y=$y")
  return (x,y)
end

function auxiliary_points(g::Network)
  λ = round(Int,connectivity(g))
  n = length(g.tails)
  auxpoints = fill((0.,0.),λ+1)
  cuts = Vector{Vector{Int}}()

  resmin, resmax = minmaxCapacity(g)
  resmin = resmin/2.
  gmin = restriction(resmin,g)
#  print(gmin)
  fmin, smin, cutedges = getFlowSlope(gmin,g,resmin)
#  println("smin=",smin,", resmin=",resmin,", fmin=",fmin,", λ=",λ)
  auxpoints[λ + 1 - smin] = (resmin,fmin)
  push!(cuts,cutedges)

  fmax, smax, cutedges = getFlowSlope(g,g,resmax)
  auxpoints[λ + 1 - smax] = (resmax,fmax)
  push!(cuts,cutedges)

  if smin > smax + 1
    queue = [((fmin,smin,resmin),(fmax,smax,resmax))]
  end

  while !isempty(queue)
    (f1,s1,r1),(f2,s2,r2) = pop!(queue)
    res, expectslope = intersection(r1,f1,s1,r2,f2,s2)
    g_res = restriction(res,g)
    f_res, s_res, cutedges = getFlowSlope(g_res,g,res)
    auxpoints[λ + 1 - s_res] = (res,f_res)
    push!(cuts,cutedges)

    if (s1 > s_res + 1) && ((r2,f2) != (res,f_res))
      q = (f1,s1,r1),(f_res,s_res,res)
      push!(queue,q)
    end
    if (s_res > s2 + 1) && ((r1,f1) != (res,f_res))
      q = (f_res,s_res,res),(f2,s2,r2)
      push!(queue,q)
    end
  end
  return auxpoints, cuts
end

function breakingPoints(g::Network)
  auxpoints, cuts = auxiliary_points(g)
  λ = length(auxpoints) - 1
  breakingpoints = Vector{Tuple{Float64,Float64,Int}}()
  left_index = 1

  for (id,p) in enumerate(auxpoints)
    if id == 1
      push!(breakingpoints,(0.,0.,λ))
    else
      p_left = breakingpoints[left_index]
#      println("p=",p)
      if p[1] != 0
        interx, intery = intersection(p_left[1],p_left[2],p_left[3],p[1],p[2], λ + 1 - id)
        push!(breakingpoints,(interx,intery,λ + 1 - id))
        left_index += 1
      else
        push!(breakingpoints,(-1.,-1.,λ + 1 - id))
      end
    end
  end
#  println(auxpoints)
#  println(breakingpoints)
  return breakingpoints
end

function breakingPointsCuts(g::Network)
  auxpoints, cuts = auxiliary_points(g)
  λ = length(auxpoints) - 1
  breakingpoints = Vector{Tuple{Float64,Float64,Int}}()
  left_index = 1

  for (id,p) in enumerate(auxpoints)
    if id == 1
      push!(breakingpoints,(0.,0.,λ))
    else
      p_left = breakingpoints[left_index]
#      println("p=",p)
      if p[1] != 0
        interx, intery = intersection(p_left[1],p_left[2],p_left[3],p[1],p[2], λ + 1 - id)
        push!(breakingpoints,(interx,intery,λ + 1 - id))
        left_index += 1
      else
        push!(breakingpoints,(-1.,-1.,λ + 1 - id))
      end
    end
  end
#  println(auxpoints)
#  println(breakingpoints)
  return breakingpoints, cuts
end

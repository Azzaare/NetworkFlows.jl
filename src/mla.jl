## Multilink Attack algorithms

function projection(x::Float64,y::Float64,slope::Int)
  return y - slope*x
end

function mixedMLA(g::Network)
  breakingpoints, cuts = breakingPointsCuts(g)

  λ = breakingpoints[1][3]
  bounds = fill((typemax(Float64), 0.),λ) #(lower bound, upper bound) init

  k = λ
  for p in breakingpoints[2:end]
    if p[1] != -1.
      for i in (p[3]+1):(k-1)
        π = projection(p[1],p[2],i)
        A = min(p[2] - p[1]*p[3],bestMinkCut(g,cuts,i))
#        A = p[2] - p[1]*p[3]
        bounds[λ-i] = (π,A)
      end
      α = projection(p[1],p[2],p[3])
      bounds[λ-p[3]] = (α,α)
      k = p[3]
    end
  end
  return bounds
#  α0 = breakingpoints[end][2]
#  bounds[λ+1] = (α0,α0)
end

function successMLA(g::Network)
  bounds = mixedMLA(g)
  Σ = 0
  for i in bounds
    if i[1] == i[2]
      Σ += 1
    end
  end
  return Σ/length(bounds)
end

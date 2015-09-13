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

function printFull(g::Network)
  n = length(g.tails) - 1
  m = 0
  str = string()
  for (id,start) in enumerate(g.tails[1:n])
    stop = g.tails[id+1] - 1
    str *= "node $id :"
    for a in g.links[start:stop]
      aux = (a.head,a.cap)
      str *= " $aux"
      m += 1
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

# DIMACS format input
function orderedDIMACS(fname::String, foutput = "")
  # Init Strings
  comments = Vector{String}()
  links = Vector{Link}()
  linklines = Vector{Int}()
  problem_line = 0
  source_line = 0
  sink_line = 0
  problem = ""
  source = ""
  sink = ""

  open(fname,"r") do file
    for (id,line) in enumerate(eachline(file))
      words = split(line)
      if words[1] == "p"
        problem = line
        problem_line = id
      elseif words[1] == "c"
        push!(comments,line)
      elseif words[1] == "n"
        if words[3] == "s"
          source = line
          source_line = id
        else words[3] == "t"
          sink = line
          sink_line = id
        end
      else # words[1] == 'a'
        tail = parse(Int,words[2])
        head = parse(Int,words[3])
        cap = parse(Float64,words[4])
        push!(links,(tail,head,cap))
        push!(linklines,id)
      end
    end
  end
  sort!(links)

  strout = ""
  if foutput == ""
    foutput = fname
  end
  open(foutput,"w") do file
    linecpt = 0
    while !isempty(links) || !isempty(comments)
      linecpt += 1
      if linecpt == problem_line
        strout *= problem
      elseif linecpt == source_line
        strout *= source
      elseif linecpt == sink_line
        strout *= sink
      elseif !isempty(links) && (linecpt == linklines[1])
        l = shift!(links)
        strout *= "a $(l[1]) $(l[2]) $(l[3])\n"
        shift!(linklines)
      else
        strout *= shift!(comments)
      end
    end
    write(file,strout)
  end
end

function dimacsNetwork(fname::String)
  links = Vector{Link}()
  source = 0
  sink = 0
  directed = true

  open(fname,"r") do file
    for line in eachline(file)
      words = split(line)
      if words[1] == "n"
        if words[3] == "s"
          source = parse(Int,words[2])
        else words[3] == "t"
          sink = parse(Int,words[2])
        end
      elseif words[1] == "a"
        tail = parse(Int,words[2])
        head = parse(Int,words[3])
        cap = parse(Float64,words[4])
        push!(links,(tail,head,cap))
      end
    end
  end

  Network(links, directed, source, sink)
end

function csvNetwork(fname::String, source::Int, sink::Int)
  links = Vector{Link}()
  directed = true

  data = readcsv(fname)
  for j in 1:size(data,1)
    push!(links, (round(Int,data[j,1]), round(Int,data[j,2]), data[j,3]))
  end
  Network(links,directed,source,sink)
end

function Network(fname::String,format::Symbol, st = (1,2) )
  if format == :DIMACS
    dimacsNetwork(fname)
  elseif format == :CSV
    source, sink = st
    csvNetwork(fname,source, sink)
  end
end

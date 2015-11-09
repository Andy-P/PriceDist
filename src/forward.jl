
function outStr(s::StateResult)
    str = "$(s.starttime),$(s.endtime)"
    str = "$str,$(s.startstate[1]),$(s.startstate[2])"
    str = "$str,$(s.result[1]),$(s.result[2])"
    return str
end

function walkForward(fileStr::AbstractString,
                    inpath::AbstractString, output::AbstractString)
    e = MktEvent()
    dc = IODataCache()

    stateResults = StateResult[]
    results = StateResult[]

    cnt = 0
    f = open(joinpath(inpath, fileStr),"r")
    o = open( output,"w")
    while !eof(f)
        cnt += 1
        fillBinaryEvent!(f, dc, e) # get next market event
        state = [e.bid, e.ask]
        endTm = e.dt + Dates.Minute(10)
        s = StateResult(e.dt, endTm, state, [0., 0.],false)
        push!(stateResults,s)
        completed = processPairs(stateResults,e)
        map(x->println(o,outStr(x)),completed)
        if cnt > 38500 break end
    end
    close(f)

    return results
end

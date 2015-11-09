type StateResult
    starttime::DateTime
    endtime::DateTime
    startstate::Vector
    result::Vector
    completed::Bool
    # function StateResult(starttime::DateTime,state::Vector)
    #     new(starttime,starttime,state,Float64[])
    # end
end


function processPairs(stateResults::Vector{StateResult}, e::MktEvent)

    completed = StateResult[]
    i = 0
    while length(stateResults) - i > 0
        if e.dt >= stateResults[i+1].endtime # time's up!
            push!(completed,  shift!(stateResults)) # extract the state/result pair
            completed[end].completed =  true
        elseif e.isExec == 1 # is execution not rate update
            # if X milliseconds (tm) of results have not been accumulated,
            # update result
            stateResults[i+1].result = Float64[e.bid, e.ask]
        end
        i += 1
    end
    return completed
end

type StateResult
    starttime::DateTime
    endtime::DateTime
    startstate::Vector
    result::Vector
    function StateResult(starttime::DateTime,state::Vector)
        new(starttime,starttime,state,Float64[])
    end
end

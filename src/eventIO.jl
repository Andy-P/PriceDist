type MktEvent
    d::Int32 # date
    t::Int64# time
    dt::DateTime # datetime
    isExec::Int32
    bid::Float32
    ask::Float32
    lastAmt::Int32
    BS::Int32
    OC::Int32
    CP::Int32
    oType::Int32
    AcctID::Int32
    function MktEvent()
        new(zero(Int32),   zero(Int64),   typemin(DateTime), zero(Int32),
            zero(Float32), zero(Float32), zero(Int32),       zero(Int32),
            zero(Int32),   zero(Int32),   zero(Int32),       zero(Int32))
    end
end

function datetimeParse(d::Int32, t::Int64)
    yr = floor(d / 10000)
    mn = floor((d - yr * 10000) / 100)
    dy = floor(d - (yr * 10000 + mn * 100))
    hr = floor(t/ 3600000)
    mi = floor((t - hr * 3600000) / 60000)
    sc = floor((t - (hr * 3600000 + mi * 60000)) /  1000)
    ms = floor(t - (hr * 3600000 + mi * 60000 + sc * 1000))
    DateTime(yr, mn, dy, hr, mi, sc, ms)
end

type IODataCache
    ints::Array{Int32,1}
    intsLrg::Array{Int64,1}
    floats::Array{Float32,1}
    IODataCache() = new(zeros(Int32,1),zeros(Int64,1),zeros(Float32,1))
end

function fillBinaryEvent!(io::IOStream, d::IODataCache, e::MktEvent)
    read!(io, d.ints); e.d = d.ints[1]
    read!(io, d.intsLrg); e.t = d.intsLrg[1]
    e.dt = datetimeParse(e.d,e.t)
    read!(io, d.ints); e.isExec = d.ints[1]
    read!(io, d.floats); e.bid = d.floats[1]
    read!(io, d.floats); e.ask = d.floats[1]
    read!(io, d.ints); e.lastAmt = d.ints[1]
    read!(io, d.ints); e.BS = d.ints[1] * -1
    read!(io, d.ints); e.OC = d.ints[1]
    read!(io, d.ints); e.CP = d.ints[1]
    read!(io, d.ints); e.oType = d.ints[1]
    read!(io, d.ints); e.AcctID = d.ints[1]
end

oTypes = ["UNDEFINED" => -1,"null" => 0, "Bulk Settlement"=> 1,"LIMIT"=> 2,"Loss Cut"=> 3,
          "Market"=> 4,"null"=> 5,"Quoted"=> 6,"STOP"=> 7]

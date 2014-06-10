# module MyUtils

# export less, tail, head, @stdoless, @stdohead, @stdotail
# import Base.less


function myhy(T::Type)
    println(T)
    if T == Any
        return
    else
        myhy(super(T))
    end
end



function less(f::Function)
    #io, P = writesto(ignorestatus(`less`), STDOUT)
    io, P = open(ignorestatus(`less`),"w",STDOUT)
    try
        f(io)
        close(io)        
        wait(P)
    catch err 
#        println("Errortype = ", typeof(err))
        kill(P)
        if typeof(err) != Base.UVError 
            rethrow()                   
        end        
    finally
        close(io)
#        return
    end    
end

function tail(f::Function, n::Int)
#    io, P = writesto(`tail --lines=$n`, STDOUT)
    io, P = open(`tail --lines=$n`, "w", STDOUT)
    try
        f(io)
        close(io)
        wait(P)
    catch
        kill(P)
        rethrow()
    finally
        close(io)
    end    
end

function head(f::Function, n::Int)
#    io, P = writesto(ignorestatus(`head --lines=$n`), STDOUT)
    io, P = open(ignorestatus(`head --lines=$n`), "w", STDOUT)
    try
        f(io)
        wait(P)
    catch err
        kill(P)
        if typeof(err) != Base.UVError #unclear why it occurs
            rethrow()
        end
    finally
        close(io)
    end 
end

function tail(A::Union(AbstractMatrix,AbstractVector), n::Int = 10)
    tail(n) do io
        Base.print_matrix(io, A, typemax(Int), typemax(Int))
    end
end

function head(A::Union(AbstractMatrix,AbstractVector), n::Int = 10)
    head(n) do io
        Base.print_matrix(io, A, typemax(Int), typemax(Int))
    end
end


function less(A::Union(AbstractMatrix,AbstractVector))
    less() do io
        Base.print_matrix(io, A, typemax(Int), typemax(Int))
    end
end

macro stdotail(args...)
    nargs = length(args)
    if nargs == 0 ||  nargs > 2 
        error("wrong number of args")
    elseif nargs == 1
        n=10
        ex=args[1]
    elseif nargs == 2
        n=args[1]
        ex=args[2]
    end
    
    quote
        tail($(esc(n))) do io
            bkSTDOUT=STDOUT
            try
                redirect_stdout(io)
                $(esc(ex))                
            finally
                close(io)
                redirect_stdout(bkSTDOUT)
            end
        end
    end
end

macro stdohead(args...)
    nargs = length(args)
    if nargs == 0 ||  nargs > 2 
        error("wrong number of args")
    elseif nargs == 1
        n=10
        ex=args[1]
    elseif nargs == 2
        n=args[1]
        ex=args[2]
    end
    
    quote
        head($(esc(n))) do io
            bkSTDOUT=STDOUT
           try
               redirect_stdout(io)
               $(esc(ex))
           finally
               redirect_stdout(bkSTDOUT)
           end
        end
    end
end

macro stdoless(ex)
    quote
        less() do io
            bkSTDOUT=STDOUT
            try 
                redirect_stdout(io)
                $(esc(ex))
            finally
                close(io)
                redirect_stdout(bkSTDOUT)
            end
        end
    end
end

nothing


#end

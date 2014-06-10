Some utilities for Julia
========================

`less`, `head`,`tail` of `Union(AbstractMatrix,AbstractVector)`

Example:

```
julia> a = rand(3,3)
3x3 Array{Float64,2}:
 0.766276  0.0889738  0.766481
 0.462892  0.373601   0.519861
 0.106218  0.143746   0.93921

julia> less(a)

0.766275719445157    0.088973818257575    0.766481334416224
0.46289191095778826  0.3736013900788684   0.5198610738240492
0.10621829502292024  0.14374570106101703  0.9392096208934924
:(END)
```

Some similar macros to intercept `STDOUT` of a program (`@stdohless`, `@stdohead`, `@stdotail`) 

Example:

```
julia> @stdohless 3 for i=1.:1.:100000. println(i) end;
1.0
2.0
3.0

```

WARNING
=======

It somehow overwrites the builtin pager behavior, so that once included, 

```
julia> println |> less
```

does not work anylonger. TO BE FIXED.

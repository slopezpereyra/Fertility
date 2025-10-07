# Questions for Jen

(1) Some staging files had a "U" stage. 

(2) Wrongs as of 6 October 2025: (2, 6), (6, 7) 

Issues are related not to EEG loading but artifact detection. Output for S2, N6:

```julia
julia> artfs = detect_artifacts(eeg, "EEG5", 60*5)
Error in `purrr::map()`:
ℹ In index: 79.
ℹ With name: 79.
Caused by error in `if (Reduce("|", x == Inf)) ...`:
! missing value where TRUE/FALSE needed
Run `rlang::last_trace()` to see where the error occurred.
ERROR: REvalError: 
Stacktrace:
 [1] reval_p(expr::Ptr{LangSxp}, env::Ptr{EnvSxp})
   @ RCall ~/.julia/packages/RCall/GLHIY/src/eval.jl:105
 [2] reval_p(expr::Ptr{RCall.ExprSxp}, env::Ptr{EnvSxp})
   @ RCall ~/.julia/packages/RCall/GLHIY/src/eval.jl:119
 [3] reval(str::String, env::RObject{EnvSxp})
   @ RCall ~/.julia/packages/RCall/GLHIY/src/eval.jl:136
 [4] macro expansion
   @ ~/.julia/packages/RCall/GLHIY/src/macros.jl:74 [inlined]
 [5] r_detect_artifacts(x::Vector{Float32}, fs::Int64, seg_length::Int64; penalty::Int64)
   @ Main.EEGToolkit.EEGToolkitR ~/.julia/dev/EEGToolkit/src/RInterface.jl:63
 [6] detect_artifacts(eeg::EEG, channel_name::String, seg_length::Int64; penalty::Int64)
   @ Main ~/.julia/dev/EEGToolkit/src/eeg.jl:233
 [7] detect_artifacts(eeg::EEG, channel_name::String, seg_length::Int64)
   @ Main ~/.julia/dev/EEGToolkit/src/eeg.jl:224
 [8] top-level scope
   @ REPL[37]:1
```

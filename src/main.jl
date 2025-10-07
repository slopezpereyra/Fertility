using Pkg;Pkg.activate(".")

using Glob
using Dates
using EDF
using Plots
using FFTW
using DSP
using Statistics
#using DataFrames
using Requires 
using RCall
using CSV 
using DataFrames
using DelimitedFiles

include("../../.julia/dev/EEGToolkit/src/staging.jl")
include("../../.julia/dev/EEGToolkit/src/hypnograms.jl")
include("../../.julia/dev/EEGToolkit/src/ts.jl")
include("../../.julia/dev/EEGToolkit/src/artifacts.jl")
include("../../.julia/dev/EEGToolkit/src/eeg.jl")
include("../../.julia/dev/EEGToolkit/src/resampling.jl")
include("../../.julia/dev/EEGToolkit/src/psd.jl")
include("../../.julia/dev/EEGToolkit/src/spindles.jl")
include("../../.julia/dev/EEGToolkit/src/nrem.jl")
include("../../.julia/dev/EEGToolkit/src/RInterface.jl")
include("../../.julia/dev/EEGToolkit/src/EEGToolkit.jl")
include("src/helpers.jl")


eeg = EEG("SWAIVF004.edf")
signal = eeg._signals["EEG6"]
x = signal.x 
#fs = signal.fs
#S = analyze_eeg(x, fs)
#
#delta_band = findall(x -> x >= 0.3 && x <= 3.9, S.freq)
#fn_delta_power = mean(
#                  sum(S.spectrums[:, delta_band], dims=2)
#                      )
#
#
#eeg2 = EEG2("SWAIVF004.edf")
#signal2 = eeg2._signals["EEG6"]
#
#eeg2._signals
#eeg._signals
#keys(eeg._signals)
#for signal in keys(eeg._signals)
#  eeg._signals[signal]
#  eeg2._signals[signal]
#  print("\n------------------------------------------\n")
#end
#
#plot_ts(signal2, 30)
#
#signal2.x == signal.x
#signal.fs == signal2.fs
#
#
#x = signal.x 
#fs = signal.fs
#S = analyze_eeg(x, fs)
#
#delta_band = findall(x -> x >= 0.3 && x <= 3.9, S.freq)
#fn_delta_power = mean(
#                  sum(S.spectrums[:, delta_band], dims=2)
#                      )
#
eeg = EEG("data/SWA2n6.edf")

function analyze_subject(subject, night; chan="EEG5")
  eeg, stg = load_eeg(subject, night)
  detect_artifacts(eeg, chan, 60*5)
  compute_nrem_powers(eeg, stg; chan)
end


function main()
    wrongs = []
    failed = false
    H = Matrix{Union{Float64, Missing, Int}}(undef, 0, 7)

    # Get list of EDF files in the current directory
    edf_files = glob("*.edf", "data/")

    for file in edf_files
        # Extract the base filename without path and extension
        filename = basename(file)
        m = match(r"SWA(\d+)n(\d+)\.edf", filename)
        if m === nothing
            println("Skipping invalid filename: $filename")
            continue
        end

        subject = parse(Int, m.captures[1])
        night = parse(Int, m.captures[2])
        println("File: $filename => Subject: $subject, Night: $night")

        try
            res = analyze_subject(subject, night)

            # Prepare a row: [subject, night, val1, val2, ..., val5], padded with `missing`
            row = vcat(
                Union{Float64, Missing, Int}[subject, night],
                res,
                fill(missing, max(0, 5 - length(res)))
            )

            # Append the row to H
            H = vcat(H, reshape(row, 1, :))
            display(H)

        catch e
            println("ERROR processing subject $subject night $night: $e")
            push!(wrongs, (subject, night))
        end
    end

    CSV.write("results.csv", DataFrame(H, [:Subject, :Night, :FullNight, :NREM1, :NREM2, :NREM3, :NREM4]))
    return wrongs
end

wrongs = main()
print(wrongs)

#eeg, stg = load_eeg(1, 10)
#
#signal = get_channel(eeg, "EEG6")
#plot_ts(signal, 10)
#
#
#x = signal.x 
#fs = signal.fs
#S = analyze_eeg(x, fs)
#spec.spectrums
#plot_spectrogram(spec)
#
#delta_band = findall(x -> x >= 0.3 && x <= 3.9, S.freq)



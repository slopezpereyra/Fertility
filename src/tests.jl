
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
signal = eeg._signals["EEG6"]
x = signal.x 


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


function load_eeg(subject, night)
  subject, night = string(subject), string(night)
  prefix = "data/SWA" * subject * "n" * night 
  staging = readdlm("data/"* subject *"n" * night * ".TXT", ',', String)[1:end]
  replace!(staging, "NS" => "?", "R" => "5", "W" => "6", "N1" => "1", "N2" => "2", "N3" => "3", "N4" => "4", "U" => "?")
  staging = Staging(staging)
  eeg = EEG(prefix * ".edf")
  return eeg, staging
end

function compute_nrem_powers(eeg, stg; chan = "EEG5")
  signal = get_channel(eeg, chan)  
  x = signal.x 
  fs = signal.fs

  # Compute the Spectrogram
  S = analyze_eeg(x, fs)

  # Get epochs with artifacts and NREM periods with artifacts excluded
  artifacted_epochs = get_epochs_with_artifacts(eeg, chan)
  nrem_periods = nrem(stg)
  nrem_periods = [filter(x -> x ∉ artifacted_epochs, vec) for vec in nrem_periods]

  fn_swa_epochs = findall(x -> x ∈ ["2", "3"], stg)
  fn_swa_epochs = filter(x -> x ∉ artifacted_epochs, fn_swa_epochs)
  delta_band = findall(x -> x >= 0.3 && x <= 3.9, S.freq)
  fn_delta_power = mean(
                    sum(S.spectrums[fn_swa_epochs, delta_band], dims=2)
                        )
  range = min( length(nrem_periods), 4 )
  powers = [fn_delta_power]
  for i in collect(1:range)
    period = nrem_periods[i]
    sub_spectrogram = S.spectrums[period, delta_band]
    power = mean( sum(sub_spectrogram, dims=2) )
    push!(powers, power)
  end
# full night power is the first element in the list, push! adds at the end.
  return powers
end

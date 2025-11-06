using Pkg; Pkg.activate(".")
using CSV
using DataFrames

function merge_sleep_data()
    # 1. Define file names
    arch_file = "sleep_arch_results2.csv"
    power_file = "results.csv"
    println("Loading $arch_file...")
    local df_arch, df_power
    try
        df_arch = CSV.read(arch_file, DataFrame)
    catch e
        println("ERROR: Could not read '$arch_file'.")
        println("Please make sure the file exists in the current directory.")
        println("Error details: $e")
        return
    end

    println("Loading $power_file...")
    try
        df_power = CSV.read(power_file, DataFrame)
    catch e
        println("ERROR: Could not read '$power_file'.")
        println("Please make sure the file exists in the current directory.")
        println("Error details: $e")
        return
    end

    println("Files loaded successfully.")
    println("\nSleep Architecture Data Head:")
    display(first(df_arch, 5))
    println("\nSlow-Wave Power Data Head:")
    display(first(df_power, 5))

    # 3. Join the DataFrames
    # 'innerjoin' will automatically use the common columns (:Subject and :Night)
    # as the join keys. This keeps only the rows that match in both files.
    println("\nJoining DataFrames on :Subject and :Night...")
    df_merged = innerjoin(df_arch, df_power, on = [:Subject, :Night])

    # 4. Sort and save the new DataFrame
    println("✅ Success!")
    return(df_merged)
end

df = merge_sleep_data()
df

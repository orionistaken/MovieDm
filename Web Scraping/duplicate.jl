using DataFrames, CSV

df = CSV.read("combined_series_info.csv", DataFrame)

df_no_duplicate = unique(df)


CSV.write("series_info.csv", df_no_duplicate)


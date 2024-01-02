using DataFrames, CSV


df1 = CSV.read("OdevDm\\serise_info.csv", DataFrame)
df2 = CSV.read("extracted_series_info.csv", DataFrame)


sorted_df1 = sort(df1, [:Title])
sorted_df2 = sort(df2, [:Title])

untitled_df2 = select(sorted_df2, Not(:Title))

merged_df = hcat(sorted_df1,untitled_df2)

CSV.write("merged_series_info.csv", merged_df)



"""
df1 = CSV.read("series_info1.csv", DataFrame)
df2 = CSV.read("extracted_series_info.csv", DataFrame)

println(names(df1))
println(names(df2))


combined_df = outerjoin(df1, df2, on = "Title", makeunique = true)


CSV.write("combined_series_info.csv", combined_df)
"""
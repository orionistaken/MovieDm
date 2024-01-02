using CSV

# Assuming you have a CSV file named "your_dataset.csv"
df = CSV.File("OdevDm\\series_info1.csv") |> DataFrame

# Function to remove leading numbers from the Title column
df.Title = replace.(r"\d+\. " => "" , df.Title)

println(first(df,5))
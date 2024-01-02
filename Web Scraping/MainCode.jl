using Gumbo, Cascadia, DataFrames, CSV

function parse_vote_count(text)
    match_result = match(r"\((\d+(?:\.\d+)?)([KkMm]?)\)", text)
    if match_result === nothing
        return 0.0
    else
        number = parse(Float64, match_result.captures[1])
        multiplier = match_result.captures[2]
        if multiplier in ["K", "k"]
            number *= 1_000
        elseif multiplier in ["M", "m"]
            number *= 1_000_000
        end
        return number
    end
end

function scrape_series_info(html_content)
    parsed_html = parsehtml(html_content)
    series_elements = eachmatch(Selector(".ipc-metadata-list-summary-item"), parsed_html.root)
    series_data = []
    for series in series_elements
        title = try text(eachmatch(Selector(".ipc-title__text"), series)[1]) catch e; "" end
        year = try text(eachmatch(Selector(".dli-title-metadata-item"), series)[1]) catch e; "" end
        description = try text(eachmatch(Selector(".ipc-html-content-inner-div"), series)[1]) catch e; "" end
        rating = try match(r"(\d+\.\d+|\d+)", text(eachmatch(Selector(".ipc-rating-star--imdb"), series)[1])).captures[1] catch e; "" end
        
        vote_count_text = try text(eachmatch(Selector(".ipc-rating-star--voteCount"), series)[1]) catch e; "" end
        vote_count = parse_vote_count(vote_count_text)
      
        push!(series_data, Dict(
            "Title" => title,
            "Year" => year,
            "Description" => description,
            "Rating" => rating,
            "VoteCount" => vote_count
        ))
    end
    return series_data
end

html_content = read("C:\\Users\\sumey\\OneDrive\\Masaüstü\\OdevDm\\html_codes.txt", String)

series_data = scrape_series_info(html_content)
series_df = DataFrame(series_data)

CSV.write("series_info1.csv", series_df)

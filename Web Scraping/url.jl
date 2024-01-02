using Gumbo, Cascadia, DataFrames, CSV, HTTP

dosya_yolu = "C:\\Users\\bkork\\OneDrive\\Documents\\Julia\\OdevDm\\links.csv"
urls = []

urls_df = CSV.read(dosya_yolu, DataFrame)
urls = urls_df.link

titles = []
turler = []
sezon_sayilari = []
bolum_sayilari = []
production_companies = []
actors = []

for url in urls
    try
        response = HTTP.get(url)
        html = parsehtml(String(response.body))

        title_element = first(eachmatch(Selector(".hero__primary-text"), html.root))
        title_text = title_element !== nothing ? strip(Gumbo.text(title_element)) : "Unknown"
        push!(titles, title_text) 

        genre_spans = eachmatch(Selector(".ipc-chip__text"), html.root)
        genres_text = !isempty(genre_spans) ? join([strip(Gumbo.text(genre_span)) for genre_span in genre_spans], ", ") : "Unknown"
        push!(turler, genres_text)

        season_labels = eachmatch(Selector(".ipc-simple-select__label"), html.root)
        season_text = !isempty(season_labels) ? strip(Gumbo.text(first(season_labels))) : "Unknown"
        push!(sezon_sayilari, season_text)

        episode_subtexts = eachmatch(Selector(".ipc-title__subtext"), html.root)
        episode_text = !isempty(episode_subtexts) ? strip(Gumbo.text(first(episode_subtexts))) : "Unknown"
        push!(bolum_sayilari, episode_text)

        production_company_links = eachmatch(Selector(".ipc-metadata-list-item__list-content-item--link"), html.root)
        production_companies_text = !isempty(production_company_links) ? join([strip(Gumbo.text(link)) for link in production_company_links if contains(link.attributes["href"], "/company/")], ", ") : "Unknown"
        push!(production_companies, production_companies_text)

        actor_links = eachmatch(Selector(".ipc-metadata-list-item__list-content-item--link"), html.root)
        actors_text = !isempty(actor_links) ? join([strip(Gumbo.text(link)) for link in actor_links if contains(link.attributes["href"], "/name/")], ", ") : "Unknown"
        push!(actors, actors_text)

    catch e
        println("Error occurred at URL $url: $e")
    end
end

df = DataFrame(
    Title = titles,
    Genres = turler,
    Season_Count = sezon_sayilari,
    Episode_Count = bolum_sayilari,
    Production_Companies = production_companies,
    Actors = actors
)

csv_path = "extracted_series_info.csv"
CSV.write(csv_path, df)
println("Data extracted and written to $csv_path")
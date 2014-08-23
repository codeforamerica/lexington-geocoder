require 'dotenv'
Dotenv.load
require 'sinatra'
require 'json'
require 'elasticsearch'

get '/' do
  erb :index
end

ES = Elasticsearch::Client.new(hosts: ENV['ELASTICSEARCH_URL'])

def search_for(address)
  results = ES.search index: 'addresses',
    body: {query: {query_string:
      {default_field: "ADDRESS",
       query: address.gsub("/", " ")}}}
  results["hits"]
end

def format_parcel(match)
  { "formatted_address" => match['ADDRESS'],
    "parcel_id" => match['PVANUM'],
    "geometry" => {
       "location" => {
          "lat" => match['Y'],
          "lng" => match['X'],
       },
    }}
end

def likely_parcels(query = '123 Main st')
  hits = search_for(query)
  response = {'results' => []}
  return response if hits["total"] == 0

  response['results'] = hits['hits'].map do |hit|
    match = hit['_source']
    format_parcel match
  end
  response
end

get '/geocode' do
  content_type :json
  likely_parcels(params["query"]).to_json
end

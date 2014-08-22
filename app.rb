require 'dotenv'
Dotenv.load
require 'sinatra'
require 'sequel'
require 'json'
require 'elasticsearch'

get '/' do
  erb :index
end


DB = Sequel.connect(ENV['DATABASE_URL'])
PARCELS = DB.from(:parcels)

ES = Elasticsearch::Client.new(hosts: ENV['ELASTICSEARCH_URL'])

def search_for(address)
  results = ES.search index: 'addresses',
    body: {query: {query_string:
      {default_field: "ADDRESS",
       query: address.gsub("/", " ")}}}
  results["hits"]
end


def lookup_parcel(parcel_id)
  parcel = PARCELS.where('"PVANUM" = ?', parcel_id).first
  { "formatted_address" => parcel[:ADDRESS],
    "parcel_id" => parcel[:PVANUM],
    "geometry" => {
       "location" => {
          "lat" => parcel[:Y],
          "lng" => parcel[:X],
       },
    }}
end

def likely_parcels(query = '123 Main st')
  hits = search_for(query)
  response = {'results' => []}
  return response if hits["total"] == 0

  response['results'] = hits['hits'].map do |hit|
    match = hit['_source']
    lookup_parcel match["PVANUM"]
    # { "formatted_address" => match["ADDRESS"]}
  end
  response
end

get '/geocode' do
  content_type :json
  likely_parcels(params["query"]).to_json
end

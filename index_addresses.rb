require 'elasticsearch'
require 'csv'

# Connect to localhost:9200 by default:
es = Elasticsearch::Client.new(hosts: [ENV['BONSAI_URL']], log: true)

CSV.foreach('data/ParcelCentroids.csv', {headers: true}) do |address|
  if address["PVANUM"] =~ /\d+/
    es.index(index: 'addresses',
      type:  'address',
      id: address["PVANUM"],
      body: {
         PVANUM: address["PVANUM"],
         NUM1: address["NUM1"],
         NAME: address["NAME"],
         TYPE: address["TYPE"],
         ADDRESS: address["ADDRESS"],
         UNIT: address["UNIT"]
      })
  end
end

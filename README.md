# Lexington Geocoder

Lexington Geocoder is a service to allow people, but especially computer programs, to submit an address like '123 Main St.' and find its map coordinates and canonical parcel_id in the Lexington, KY Property Value Administrator's set of addressess.

### Why are we doing this?

Because LFUCG (Lexington's government) has many datasets that contain addresses but not an easy way to know that the '449 W. Fourth St.' in one database is the same as the differently spelled '435 W 4th St.' in another. This service lets you look them both up and find their precise parcel id.

### How to use it?

HTTP

* GET `http://lexington-geocoder.herokuapp.com/geocode?query=449+w+4th`

The JSON response is similar to Google's geocoder

```
{"results":
	[
		{"formatted_address":"449 W FOURTH ST",
			"parcel_id":"15602150",
			"geometry":{"location":	{"lat":38.0552851548526,"lng":-84.4949386945456}}},
		{"formatted_address":"449 W SECOND ST",
			"parcel_id":"10350975",
			"geometry":{"location": {"lat":38.0527766687416,"lng":-84.4985605645134}}}
	]
}
```

### What will this do in the future?

TODO

### Who is this made by?

Why, Lexingteam of course.

* [Erik Schwartz](https://github.com/eeeschwartz)
* [Lyzi Diamond](https://github.com/lyzidiamond)
* [Livien Yin](https://github.com/livienyin)

### Setup

* [Install Elasticsearch](http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/_installing_elasticsearch.html) or for osx homebrew users `brew install elasticsearch`
* [Install PostgreSQL](https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md) (this requirement may go away)
* [Install Ruby](https://github.com/codeforamerica/howto/blob/master/Ruby.md)
* [Install csvkit](https://github.com/amandabee/cunyjdata/wiki/Tutorial:-Installing-CSVKit)

```
git clone https://github.com/codeforamerica/lexington-geocoder.git
cd lexington-geocoder
cp .env.sample .env
gem install bundler
bundle install

# make sure postgres is running, then:
createdb lexington_geocoder
csvsql --db postgresql:///lexington_geocoder --insert --table parcels data/ParcelCentroids.csv

# make sure elasticsearch is running then:
ruby index_addresses.rb
... takes a few minutes
bundle exec rackup

`curl http://localhost:9292/geocode?query=449+w+4th`
... should return some json!
```
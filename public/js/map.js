// Create map object
var mapObject = {};

// initialize map
mapObject.init = function() {
  // Create map container
  this.map = L.mapbox.map('map', 'codeforamerica.hek4o94g', {maxZoom: 15, minZoom: 10, accessToken: 'pk.eyJ1IjoiY29kZWZvcmFtZXJpY2EiLCJhIjoiSTZlTTZTcyJ9.3aSlHLNzvsTwK-CYfZsG_Q'}).setView([38.042,-84.515], 11);

  // Make layer group
  this.addresses = L.layerGroup();

}

// add search results to map
mapObject.addToMap = function (data) {
  this.addresses.clearLayers();
  var geoJsonResults = L.geoJson(data, {
    onEachFeature: function(feature, layer) {
      layer.bindPopup(feature.properties.formatted_address);
    }
  });
  this.addresses.addLayer(geoJsonResults).addTo(this.map);
}

// Creates a Leaflet map object
// Sets options for map object
// Sets starting view for map
// Creates addresses layerGroup

// Clears layers from addresses
// Creates Leaflet geojson object of results
// Adds a popup to each results
// Adds results to addresses

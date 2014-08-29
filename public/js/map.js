// initialize map
var map = L.mapbox.map('map', 'codeforamerica.hek4o94g', {maxZoom: 15, minZoom: 10, accessToken: 'pk.eyJ1IjoiY29kZWZvcmFtZXJpY2EiLCJhIjoiSTZlTTZTcyJ9.3aSlHLNzvsTwK-CYfZsG_Q'}).setView([38.042,-84.515], 11);

var addresses = L.layerGroup();

function addToMap(data) {
  addresses.clearLayers();
  var geoJsonResults = L.geoJson(data, {
    onEachFeature: function(feature, layer) {
      layer.bindPopup(feature.properties.formatted_address);
    }
  });
  addresses.addLayer(geoJsonResults).addTo(map);
}

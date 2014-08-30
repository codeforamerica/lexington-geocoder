// Create map object
window.MapBuilder = {};

// initialize map
MapBuilder.init = function(id) {
  // Create map container
  var leafletMap = L.mapbox.map(id, 'codeforamerica.hek4o94g', {maxZoom: 15, minZoom: 10, accessToken: 'pk.eyJ1IjoiY29kZWZvcmFtZXJpY2EiLCJhIjoiSTZlTTZTcyJ9.3aSlHLNzvsTwK-CYfZsG_Q'}).setView([38.042,-84.515], 11);

  // Make layer group
  var addresses = L.layerGroup();

  return {
    addToMap: function (data) {
      addresses.clearLayers();
      var geoJsonResults = L.geoJson(data, {
        onEachFeature: function(feature, layer) {
          layer.bindPopup(feature.properties.formatted_address);
        }
      });
      addresses.addLayer(geoJsonResults).addTo(leafletMap);
    }
  }
}

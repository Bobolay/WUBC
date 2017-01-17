function initialize() {


  var $map = $('#googleMap')
  if(!$map.length){
    return
  }

  var styles = [
    {
      stylers: [
        { hue: "#6eff00" },
        { saturation: -58 },
        { weight: 1.8 },
        { lightness: 14 },
        { gamma: 0.75 }
      ]
    },{
      featureType: "road",
      elementType: "geometry",
      stylers: [
        { lightness: 100 },
        { visibility: "simplified" }
      ]
    },{
      featureType: "road",
      elementType: "labels",
      stylers: [
        { visibility: "off" }
      ]
    }
  ];

  var map_element = $map.get(0)

    var styledMap = new google.maps.StyledMapType(styles, {name: "Styled Map"});
    
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);

    //var xCordinate=23.5012912
    //var yCordinate=49.2785263
    var xCordinate = 49.278521
    var yCordinate = 23.503485

    var lat_lng = new google.maps.LatLng(xCordinate, yCordinate)

    var mapOptions = {
        zoom: 18,
        center: lat_lng,
        panControl:false,
        zoomControl:true,
        mapTypeControl:false,
        scaleControl:false,
        streetViewControl:false,
        overviewMapControl:false,
        rotateControl:false,
        draggable: true,
        scrollwheel: false,
        mapTypeControlOptions:{
            mapTypeIds: [google.maps.MapTypeId.ROADMAP, "map_style"]
        }
    };
    var map = new google.maps.Map(map_element,
        mapOptions);
    var image = image_urls.marker
    var marker = new google.maps.Marker({
        map: map,
        draggable: false,
        position: lat_lng,
        icon: image
    });
    map.mapTypes.set('map_style', styledMap);
    map.setMapTypeId('map_style');
}
google.maps.event.addDomListener(window, 'resize', initialize)
//google.maps.event.addDomListener(window, 'load', initialize)
$document.on("ready page:load", initialize)



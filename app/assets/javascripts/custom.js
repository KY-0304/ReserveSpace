// room住所自動補完
$(window).ready(function () {
  $('#room_postcode').jpostal({
    postcode: [
      '#room_postcode',
    ],
    address: {
      '#room_prefecture_code': '%3',
      '#room_address_city': '%4',
      '#room_address_street': '%5%6%7'
    }
  });
});

//GoogleMap表示
function initMap() {
  let centerPoint = { lat: gon.lat, lng: gon.lng }
  let map = new google.maps.Map(document.getElementById('map'), {
    center: centerPoint,
    zoom: 16,
  });

  marker = new google.maps.Marker({
    position: centerPoint,
    map: map
  });
}

//rate表示
$('#star').raty({
  size: 36,
  starOff: "/images/star-off.png",
  starOn: "/images/star-on.png",
  starHalf: "/images/star-half.png",
  scoreName: 'review[rate]',
  half: true,
});

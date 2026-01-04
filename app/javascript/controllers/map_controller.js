import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // HTMLから受け取るデータを定義
  static values = { 
    apiKey: String, 
    spots: Array 
  }

  connect() {
    this.loadGoogleMaps()
  }

  loadGoogleMaps() {
    // すでにGoogle Mapsが読み込まれていたら初期化だけする
    if (window.google && window.google.maps) {
      this.initMap()
      return
    }

    // スクリプトタグを動的に作成して読み込む
    const script = document.createElement("script")
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=initMapCallback`
    script.async = true
    script.defer = true
    
    // グローバル関数としてコールバックを登録
    window.initMapCallback = () => {
      this.initMap()
    }
    
    document.head.appendChild(script)
  }

  initMap() {
    const spots = this.spotsValue
    if (spots.length === 0) return

    const center = { lat: spots[0].lat, lng: spots[0].lng }

    // this.element は data-controller="map" がついているdivタグ
    const map = new google.maps.Map(this.element, {
      zoom: 12,
      center: center,
    })

    const infoWindow = new google.maps.InfoWindow()

    spots.forEach((spot) => {
      const marker = new google.maps.Marker({
        position: { lat: spot.lat, lng: spot.lng },
        map: map,
        label: {
          text: spot.number,
          color: "white",
          fontWeight: "bold"
        },
        title: spot.name
      })

      const contentString = `
        <div style="text-align: center; width: 150px;">
          <p style="font-weight: bold; margin-bottom: 5px; color: black;">${spot.name}</p>
          <img src="${spot.image_url}" style="width: 100%; height: auto; border-radius: 4px;">
        </div>
      `

      marker.addListener("click", () => {
        infoWindow.setContent(contentString)
        infoWindow.open(map, marker)
      })
    })
  }
}
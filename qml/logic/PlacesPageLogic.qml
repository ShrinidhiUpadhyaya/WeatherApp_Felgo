import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

Item {
    id: logic

    property string geocodeURL: "https://geocoding-api.open-meteo.com/v1/search?name="

    property var longitudeList:[]
    property var latitudeList:[]
    property var countryList: []
    property var placeList: []
    property var timezoneList: []

    //    property string placeName: ""
    //    property string latitude: ""
    //    property string longitude: ""
    //    property string subURL: ""
    //    property string timezone: ""

    property string temperatureUnit: ""



    property bool requestACK: false

    property alias cityListModel: cityListModel



    ListModel {
        id: cityListModel
    }

    //    onRequestACKChanged: {
    //        if(requestACK) {
    //            hourly.parseValueUnits(internal.hourlyData.hourly_units)
    //            hourly.parseHourlyData(internal.hourlyData.hourly,logic.placeName)
    //        }
    //    }

    QtObject {
        id: internal

        property var hourlyData;
        property var dailyData;

    }

    QtObject {
        id: hourly

        property string placeName: ""
        property string latitude: ""
        property string longitude: ""
        property string timezone: ""

        readonly property string temperatureCode: hourly.temperatureNeeded ? "temperature_2m," : ""
        property string timezoneCode:  "&timezone=" + hourly.timezone
        property string weatherCode: hourly.weatherCodeNeeded ? "weathercode," : ""
        property string subURL: ""

        // Features Needed
        property bool temperatureNeeded: true
        property bool weatherCodeNeeded: true

        function featuresNeeded() {
            subURL = temperatureCode + weatherCode + timezoneCode;
        }

        function getHourlyRequestURL() {
            hourly.featuresNeeded()
            return appData.apiURL + hourly.latitude + "&longitude=" + hourly.longitude + "&hourly=" + subURL
        }

        function requestData() {
            var url = hourly.getHourlyRequestURL()
            console.log("Requesting Hourly Data URL:",url)
            HttpRequest
            .get(url)
            .timeout(5000)
            .end(function(err, res) {
                if(res.ok) {
                    var data = res.body;
                    internal.hourlyData = data;
                    daily.requestData(daily.latitude,daily.longitude,daily.timezone);
                    hourly.parseValueUnits(internal.hourlyData.hourly_units)
                    hourly.parseHourlyData(internal.hourlyData.hourly,hourly.placeName)
                }
                else {
                    console.log(err.message)
                    console.log(err.response)
                }
            });
        }

        function parseHourlyData(data,placeName) {
            console.log("Parse Hourly Data")

            var parsedTimeData = data.time;
            var parsedTemperatureData = data.temperature_2m;
            var parsedWeatherIconData = data.weathercode;

            const index = parsedTimeData.findIndex(item => item > appData.currentTime); // find the index of the first item greater than current time

            if (index !== -1) {
                parsedTemperatureData = parsedTemperatureData.slice(index-1)
                parsedTemperatureData = parsedTemperatureData[0].toFixed(0) + temperatureUnit
                parsedWeatherIconData = parsedWeatherIconData.slice(index-1)
                parsedWeatherIconData = parsedWeatherIconData[0]
                parsedWeatherIconData = classifyWeatherIconDescription(parsedWeatherIconData)

                console.log("PlaceName:",placeName)
                console.log("Temperature:",parsedTemperatureData)
                console.log("parsedWeatherIconData",parsedWeatherIconData)

                cityListModel.append({"place":placeName,"temperature":parsedTemperatureData ,"weatherDescription":parsedWeatherIconData,"sunriseTime":"","sunsetTime":""})
            }

            //        page.requestDailyWeatherData(longitudeList[searchSelectedIndex],latitudeList[searchSelectedIndex],timezoneList[searchSelectedIndex]);
            //        popup.close()
//            logic.clearSearchData()
        }

        function parseValueUnits(data) {
            logic.temperatureUnit = data.temperature_2m
        }
    }

    QtObject {
        id: daily

        property string latitude: ""
        property string longitude: ""
        property string timezone: ""

        function getDailyRequestURL() {
            return "https://api.open-meteo.com/v1/dwd-icon?latitude=" + daily.latitude + "&longitude=" + daily.longitude + "&daily=sunrise,sunset&timezone=" + daily.timezone
        }

        function requestData() {
            var url = daily.getDailyRequestURL()
            console.log("Request Daily Data",url)
            HttpRequest
            .get(url)
            .timeout(5000)
            .end(function(err, res) {
                if(res.ok) {
                    var data = res.body
                    internal.dailyData = data.daily;
                    daily.parseDailyWeatherData(internal.dailyData);
                }
                else {
                    console.log(err.message)
                    console.log(err.response)
                }
            });
        }

        function parseDailyWeatherData(data) {
            console.log("Parsing Daily Weather Data",data)

            var sunriseTime = daily.convertDailyTime(data.sunrise[0])
            var sunsetTime = daily.convertDailyTime(data.sunset[0])

            console.log(cityListModel.count)

            cityListModel.setProperty(cityListModel.count-1,"sunriseTime",sunriseTime)
            cityListModel.setProperty(cityListModel.count-1,"sunsetTime",sunsetTime)


            console.log("Sunrise Time:",sunriseTime)
            console.log("Sunset Time:",sunsetTime)
        }

        function convertDailyTime(data) {
            console.log("Convert Time")

            var dateObjects = new Date(data);

            var hours = dateObjects.getHours() ;
            var AmOrPm = hours >= 12 ? 'PM' : 'AM';
            hours = (hours % 12) || 12;
            var minutes = dateObjects.getMinutes()
            minutes = minutes < 10 ? "0"+minutes : minutes;
            hours = hours < 10 ? "0"+hours : hours;
            var finalTime = hours + ":" + minutes + " " + AmOrPm;
            console.log(finalTime)
            return finalTime
        }
    }

    function requestPlaces(text) {
        HttpRequest
        .get(geocodeURL+text)
        .timeout(5000)
        .end(function(err, res) {
            if(res.ok) {
                var data = res.body.results
                var place = []
                var country = []
                var longitude = []
                var latitude = []
                var timezone = []

                data.forEach(function(result) {
                    country.push(result.country)
                    place.push(result.name)
                    longitude.push((result.longitude.toFixed(2)))
                    latitude.push((result.latitude.toFixed(2)))
                    timezone.push((result.timezone))
                })

                logic.countryList = country
                logic.placeList = place
                logic.longitudeList = longitude
                logic.latitudeList = latitude
                logic.timezoneList = timezone
            }
            else {
                console.log(err.message)
                console.log(err.response)
            }
        });
    }


    function requestHourlyWeather(placeName,placeLatitude,placeLongitude,placeTimeZone) {
        console.log("Request Hourly Weather",placeName,placeLatitude,placeLongitude,placeTimeZone)

        hourly.placeName = placeName
        hourly.latitude = placeLatitude
        hourly.longitude = placeLongitude
        hourly.timezone = placeTimeZone

        hourly.requestData();
    }

    function requestDailyWeatherData(placeLatitude,placeLongitude,placeTimeZone) {
        console.log("Request Daily Weather",placeLatitude,placeLatitude,placeTimeZone)

        daily.latitude = placeLatitude
        daily.longitude = placeLongitude
        daily.timezone = placeTimeZone
    }

    function clearSearchData() {
        console.log("Clearing Search Data")
        longitudeList =[]
        latitudeList = []
        countryList = []
        placeList = []
    }

    function classifyWeatherIconDescription(value) {
        if (appData.sunnyValues.includes(value)) {
            return "Sunny"
        } else if (appData.partlyCloudyValues.includes(value)) {
            return "Partly Cloudy"
        }
        else if (appData.rainyValues.includes(value)) {
            return "Rainy"
        }
        else if (appData.thunderStormValues.includes(value)) {
            return "Thunderstorms"
        }
        else if (appData.fogValues.includes(value)) {
            return "Fog"
        }
        else if (appData.snowValues.includes(value)) {
            return "Snow"
        }
    }
}

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

Item {
    id: logic

    property alias cityListModel: cityListModel
    property alias deletion: deletion

    property int searchSelectedIndex: -1

    property bool enableDeletion: false

    property string temperatureUnit: ""

    property var countryList: []
    property var deleteItems: []
    property var longitudeList:[]
    property var latitudeList:[]
    property var placeList: []
    property var placesDataStack: []
    property var timezoneList: []

    signal error()

    ListModel {
        id: cityListModel
    }

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

        property string temperatureCode: hourly.temperatureNeeded ? "temperature_2m," : ""
        property string timezoneCode: "&timezone=" + hourly.timezone
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
            console.log("PlacesPageLogic: Requesting Hourly Data URL:",url)
            HttpRequest
            .get(url)
            .timeout(5000)
            .end(function(err, res) {
                if(res.ok) {
                    var data = res.body;
                    internal.hourlyData = data;
                    console.log("PlacesPageLogic: ", internal.hourlyData)
                    hourly.errorCheck(internal.hourlyData);
                }
                else {
                    console.log("PlacesPageLogic: ",err.message)
                    console.log("PlacesPageLogic: ",err.response)
                    logic.error()
                }
            });
        }

        function errorCheck(data) {
            console.log("@@PlacesPageLogic: Length of data",data.hourly.time.length)
            if(data.hourly.time) {
                console.log("@@PlacesPageLogic: Hourly ACK")
                daily.requestData(daily.latitude,daily.longitude,daily.timezone);
                hourly.parseValueUnits(internal.hourlyData.hourly_units)
                hourly.parseHourlyData(internal.hourlyData.hourly,hourly.placeName)
            } else {
                console.log("@@PlacesPageLogic: Hourly Failed")
                logic.error()
            }
        }

        function parseHourlyData(data,placeName) {
            console.log("PlacesPageLogic: ACKParse Hourly Data")

            var parsedTimeData = data.time;
            var parsedTemperatureData = data.temperature_2m;
            var parsedWeatherIconDescription = data.weathercode;
            var parsedWeatherIconCode;

            const index = parsedTimeData.findIndex(item => item > appData.currentTime); // find the index of the first item greater than current time

            if (index !== -1) {
                parsedTemperatureData = parsedTemperatureData.slice(index-1)
                parsedTemperatureData = parsedTemperatureData[0].toFixed(0) + temperatureUnit
                parsedWeatherIconDescription = parsedWeatherIconDescription.slice(index-1)
                parsedWeatherIconDescription = parsedWeatherIconDescription[0]
                parsedWeatherIconCode = appData.weatherIcon.getWeatherIcon(parsedWeatherIconDescription)
                parsedWeatherIconDescription = appData.weatherIcon.classifyWeatherIconDescription(parsedWeatherIconDescription)

                cityListModel.append({"place":placeName,"temperature":parsedTemperatureData,"weatherIcon":parsedWeatherIconCode,"weatherDescription":parsedWeatherIconDescription,"sunriseTime":"","sunsetTime":""})

                var tempPlacesDataStack=placesDataStack;
                tempPlacesDataStack[placesDataStack.length] = [placesPageData.placeList[placesPageData.searchSelectedIndex],placesPageData.latitudeList[placesPageData.searchSelectedIndex],placesPageData.longitudeList[placesPageData.searchSelectedIndex],placesPageData.timezoneList[placesPageData.searchSelectedIndex]]
                placesDataStack = tempPlacesDataStack;
            }
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
            return appData.apiURL + daily.latitude + "&longitude=" + daily.longitude + "&daily=sunrise,sunset&timezone=" + daily.timezone
        }

        function requestData() {
            var url = daily.getDailyRequestURL()
            console.log("PlacesPageLogic: Request Daily Data",url)
            HttpRequest
            .get(url)
            .timeout(5000)
            .end(function(err, res) {
                if(res.ok) {
                    var data = res.body
                    internal.dailyData = data.daily;
                    daily.errorCheck(internal.dailyData)
                }
                else {
                    console.log("PlacesPageLogic: ", err.message)
                    console.log("PlacesPageLogic: ", err.response)
                }
            });
        }

        function errorCheck(data) {
            if(data.sunrise) {
                console.log("@@PlacesPageLogic: Daily ACK")
                daily.parseDailyWeatherData(internal.dailyData);
            } else {
                console.log("@@PlacesPageLogic: Daily ACK Failed")
            }
        }

        function parseDailyWeatherData(data) {
            console.log("PlacesPageLogic: Parsing Daily Weather Data",data)

            var sunriseTime = appData.convertDailyTime(data.sunrise[0])
            var sunsetTime = appData.convertDailyTime(data.sunset[0])

            cityListModel.setProperty(cityListModel.count-1,"sunriseTime",sunriseTime)
            cityListModel.setProperty(cityListModel.count-1,"sunsetTime",sunsetTime)

            clearSearchData();
        }
    }

    QtObject {
        id: deletion

        function initDeleteItemsArray() {
            var tempDeleteItems=[]

            for(var index=0;index<cityListModel.count;index++) {
                tempDeleteItems[index] = false
            }

            logic.deleteItems = tempDeleteItems
        }

        function enableDeleteItems(index) {
            console.log("PlacesPageLogic: Enabled Delete Items:",index)

            var tempDeleteItems=[]

            for(var i=0;i<cityListModel.count;i++) {
                tempDeleteItems[i] = false
            }

            tempDeleteItems[index] = true
            logic.deleteItems = tempDeleteItems
        }

        function selectedForDeletion(index) {
            var tempDeleteItems = logic.deleteItems
            tempDeleteItems[index] = !tempDeleteItems[index]
            disableDeletion(tempDeleteItems)
            logic.deleteItems = tempDeleteItems
            console.log("PlacesPageLogic: selectedForDeletion ", logic.deleteItems)
        }

        function disableDeletion(data) {
            console.log("PlacesPageLogic: Disable Deletion",data)
            var count = 0;
            for(var index=0;index<data.length;index++) {
                if(data[index] === false) {
                    count++;
                }
            }

            if(count === data.length) {
                logic.enableDeletion = false
            }
        }

        function deleteItems() {
            console.log("Deleting items",logic.deleteItems)
            var indexesToRemove=[];
            for(var index=0;index<cityListModel.count;index++) {
                if(logic.deleteItems[index] === true) {
                    console.log("Index deleted:",index)
                    cityListModel.remove(index)
                    initDeleteItemsArray();
                    indexesToRemove[indexesToRemove.length] = index
                    console.log(placesDataStack)
                }
            }

            indexesToRemove.sort(function(a, b) {
              return b - a;
            });


            for (var removeIndex = 0; removeIndex < indexesToRemove.length; removeIndex++) {
              placesDataStack.splice(indexesToRemove[removeIndex], 1);
            }

            console.log(placesDataStack)
        }
    }

    function sendRequest(placeName,latitude,longitude,timezone) {
        console.log("PlacesPageLogic: Sending Request")
        logic.requestHourlyWeather(placeName,latitude,longitude,timezone)
        logic.requestDailyWeatherData(latitude,longitude,timezone)
    }

    function initialDefaultRequestPlaces(text) {
        console.log("PlacesPageLogic: Requesting Places")
        HttpRequest
        .get(appData.geocodeURL+text)
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

                placesPageData.loadSearchRequest()
            }
            else {
                console.log("PlacesPageLogic: ", err.message)
                console.log("PlacesPageLogic: ", err.response)
            }
        });
    }

    function requestPlaces(text) {
        console.log("PlacesPageLogic: Requesting Places")
        HttpRequest
        .get(appData.geocodeURL+text)
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
                console.log("PlacesPageLogic:", err.message)
                console.log("PlacesPageLogic:", err.response)
            }
        });
    }

    function requestHourlyWeather(placeName,placeLatitude,placeLongitude,placeTimeZone) {
        console.log("PlacesPageLogic: Request Hourly Weather:",placeName,placeLatitude,placeLongitude,placeTimeZone)

        hourly.placeName = placeName
        hourly.latitude = placeLatitude
        hourly.longitude = placeLongitude
        hourly.timezone = placeTimeZone

        hourly.requestData();
    }

    function requestDailyWeatherData(placeLatitude,placeLongitude,placeTimeZone) {
        console.log("PlacesPageLogic: Request Daily Weather:",placeLatitude,placeLatitude,placeTimeZone)

        daily.latitude = placeLatitude
        daily.longitude = placeLongitude
        daily.timezone = placeTimeZone
    }

    function clearSearchData() {
        console.log("PlacesPageLogic: Clearing Search Data")
        longitudeList =[]
        latitudeList = []
        countryList = []
        placeList = []
    }

    function loadSearchRequest() {
        if(placesPageData.placeList.length > 0) {
            placesPageData.sendRequest(placesPageData.placeList[placesPageData.searchSelectedIndex],placesPageData.latitudeList[placesPageData.searchSelectedIndex],placesPageData.longitudeList[placesPageData.searchSelectedIndex],placesPageData.timezoneList[placesPageData.searchSelectedIndex])
        }
    }
}

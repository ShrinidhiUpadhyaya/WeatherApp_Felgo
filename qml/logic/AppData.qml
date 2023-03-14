import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0
import Felgo

Item {
    id: logic

    property alias weatherIcon: weatherIcon

    readonly property string apiURL: "https://api.open-meteo.com/v1/dwd-icon?latitude="
    readonly property string geocodeURL: "https://geocoding-api.open-meteo.com/v1/search?name="

    property string currentTimeString: "Now"
    property string currentTime: Qt.formatDateTime(new Date(), dateTimeFormat)
    property string dateTimeFormat: "yyyy-MM-ddThh:00"
    property string subURL: ""

    property var dailySunriseData: [];
    property var dailyMaxTemperatureData: [];
    property var dailySunsetData: [];
    property var dailyMinTemperatureData: [];
    property var dailyDate: []
    property var dailyWeatherIcon: []

    // Icon Codes
    property var sunnyValues: [0]
    property var partlyCloudyValues: [1,2,3]
    property var rainyValues: [51,53,55,56,57,61,63,65,66,67,80,81,82]
    property var thunderStormValues: [95,96,99]
    property var fogValues: [45,48]
    property var snowValues: [71,73,75,77,85,86]

    // Directions Names
    property var directionsNames: ['North', 'Northeast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'Northwest']

    function convertTime(data) {
        console.log("Convert Time")
        var dateObjects = data.map(function(datetimeString) {
            return new Date(datetimeString);
        });

        var amPmTimeStrings = dateObjects.map(function(dateTimeObject) {
            dateTimeObject = new Date(dateTimeObject)
            var hours = dateTimeObject.getHours() ;
            var AmOrPm = hours >= 12 ? 'PM' : 'AM';
            hours = (hours % 12) || 12;
            var finalTime = hours + " " + AmOrPm;
            return finalTime
        });

        return amPmTimeStrings;
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

    QtObject {
        id: weatherIcon

        function getWeatherIcon(value) {
            if (sunnyValues.includes(value)) {
                return "sunny"
            } else if (partlyCloudyValues.includes(value)) {
                return "partlyCloudy"
            }
            else if (rainyValues.includes(value)) {
                return "rainy"
            }
            else if (thunderStormValues.includes(value)) {
                return "thunderstorms"
            }
            else if (fogValues.includes(value)) {
                return "fog"
            }
            else if (snowValues.includes(value)) {
                return "snow"
            }
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


}

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

Item {
    id: logic

    property string currentTimeString: "Now"
    property string dateTimeFormat: "yyyy-MM-ddThh:00"
    property string currentTime: Qt.formatDateTime(new Date(), dateTimeFormat)


    property string subURL: ""

    readonly property string apiURL: "https://api.open-meteo.com/v1/dwd-icon?latitude="

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

    function getDailyRequestURL() {
        return logic.apiURL + latitude + "&longitude="  + longitude + "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=" + timezone
    }

    function requestDailyWeather(value1,value2,value3) {
        latitude = value1;
        longitude = value2;
        timezone = value3;
        HttpRequest
        .get(getDailyRequestURL())
        .timeout(5000)
        .end(function(err, res) {
            if(res.ok) {
                var data = res.body
                parseDailyData(data.daily)
            }
            else {
                console.log(err.message)
                console.log(err.response)
            }
        });
    }

    function parseDailyData(data) {
        var parsedTimeData = data.time;
        var parsedWeatherCodeData = data.weathercode;
        var parsedSunriseData = data.sunrise;
        var parsedSunsetData = data.sunset;
        var parsedMaxTemperatureData = data.temperature_2m_max;
        var parsedMinTemperatureData = data.temperature_2m_min;

        parsedTimeData = parsedTimeData.map(value => {
                                                var date = new Date(value);
                                                var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                                var dayName = days[date.getDay()];
                                                    return dayName;
                                            });

        parsedMaxTemperatureData = parsedMaxTemperatureData.map(value => {
                                                                    return parseFloat(value.toFixed(0));
                                                                });

        parsedMinTemperatureData = parsedMinTemperatureData.map(value => {
                                                                    return parseFloat(value.toFixed(0));
                                                                });

        parsedWeatherCodeData = parsedWeatherCodeData.map(value => {
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
                                                          });


        parsedSunriseData = convertDailyTime(parsedSunriseData)
        parsedSunsetData = convertDailyTime(parsedSunsetData)


        dailyDate = parsedTimeData;
        dailyWeatherIcon = parsedWeatherCodeData;
        dailySunriseData = parsedSunriseData;
        dailySunsetData = parsedSunsetData;
        dailyMaxTemperatureData = parsedMaxTemperatureData;
        dailyMinTemperatureData = parsedMinTemperatureData;

        console.log("Parsing Daily Data")
        console.log(dailyMaxTemperatureData)
    }

    function convertDailyTime(data) {
        console.log("Convert Time")
        var dateObjects = data.map(function(datetimeString) {
            return new Date(datetimeString);
        });

        var amPmTimeStrings = dateObjects.map(function(dateTimeObject) {
            dateTimeObject = new Date(dateTimeObject)
            var hours = dateTimeObject.getHours() ;
            var AmOrPm = hours >= 12 ? 'PM' : 'AM';
            hours = (hours % 12) || 12;
            var minutes = dateTimeObject.getMinutes()
            var finalTime = hours + ":" + minutes + " " + AmOrPm;
            console.log(finalTime)
            return finalTime
        });

        return amPmTimeStrings;
    }

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
}

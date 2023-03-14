import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

Item {
    id: logic

    property alias uiDisplayData: uiDisplayData

    property int countOfTemperatureShown: 25
    property int homePageCityIndex: 0

    signal error()
    signal allRequestsCompleted();

    QtObject {
        id: internal

        property var hourlyData;
        property var dailyData;
    }

    QtObject {
        id: features

        // Features Needed
        property bool temperatureNeeded: true
        property bool relativeHumidityNeeded: true
        property bool precipitationNeeded: true
        property bool weatherCodeNeeded: true
        property bool surfacePressureNeeded: true
        property bool windSpeedNeeded: true
        property bool windDirectionNeeded: true
        property bool soilMoistureNeeded: true

        readonly property string temperatureCode: temperatureNeeded ? "temperature_2m," : ""
        readonly property string relativeHumidityCode: relativeHumidityNeeded ? "relativehumidity_2m,": ""
        readonly property string precipitationCode: precipitationNeeded ? "precipitation," : ""
        readonly property string weatherCode: weatherCodeNeeded ? "weathercode," : ""
        readonly property string surfacePressureCode: surfacePressureNeeded ? "surface_pressure," : ""
        readonly property string windSpeedCode: windSpeedNeeded ? "windspeed_10m," : ""
        readonly property string windDirectionCode: windDirectionNeeded ? "winddirection_10m," : ""
        readonly property string soilMoistureCode: soilMoistureNeeded ? "soil_moisture_0_1cm" : ""

        function featuresNeeded() {
            hourly.subURL = features.temperatureCode + features.relativeHumidityCode + features.precipitationCode + features.weatherCode + features.surfacePressureCode
                    + features.windSpeedCode + features.windDirectionCode + features.soilMoistureCode;
        }
    }

    QtObject {
        id: hourly

        property string longitude: ""
        property string latitude: ""
        property string timezone: ""
        property string subURL: ""

        property string url: hourly.getHourlyRequestURL()

        function getHourlyRequestURL() {
            features.featuresNeeded()
            return appData.apiURL + hourly.latitude + "&longitude=" + hourly.longitude + "&hourly=" + hourly.subURL
        }

        function requestData() {
            console.log("HomePageLogic: Requesting for Hourly Data:",hourly.url)

            HttpRequest
            .get(hourly.url)
            .timeout(5000)
            .end(function(err, res) {
                if(res.ok) {
                    internal.hourlyData = res.body
                    errorCheck()
                }
                else {
                    console.log("HomePageLogic: ",err.message)
                    console.log("HomePageLogic: ",err.response)
                    logic.error()
                }
            });
        }

        function errorCheck() {
            console.log("HomePageLogic: @@Checking for Errors 'Hourly'")
            if(internal.hourlyData.hourly) {
                console.log("HomePageLogic: Hourly ACK")
                hourly.parseHourlyData(internal.hourlyData.hourly);
                hourly.parseHourlyDetailsUnits(internal.hourlyData.hourly_units);
                logic.requestDailyWeather(hourly.latitude,hourly.longitude,hourly.timezone)

            } else {
                console.log("HomePageLogic: Hourly ACK Failed")
                logic.error()
            }
        }

        function parseHourlyData(data) {
            console.log("HomePageLogic: Parsing Hourly Data",data)
            var parsedTimeData = data.time;
            var parsedTemperatureData = data.temperature_2m;
            var parsedWeatherIconData = data.weathercode;
            var parsedWeatherIconDescription = data.weathercode;


            const index = parsedTimeData.findIndex(item => item > appData.currentTime);

            if (index !== -1) {
                parsedTimeData = parsedTimeData.slice(index-1)
                parsedTimeData = parsedTimeData.slice(0,logic.countOfTemperatureShown)
                parsedTimeData = appData.convertTime(parsedTimeData)
                parsedTimeData[0] = appData.currentTimeString

                parsedTemperatureData = parsedTemperatureData.slice(index-1)
                parsedTemperatureData = parsedTemperatureData.slice(0,logic.countOfTemperatureShown)
                parsedTemperatureData = parsedTemperatureData.map(value => {
                                                                      return parseFloat(value.toFixed(0));
                                                                  });

                parsedWeatherIconData = parsedWeatherIconData.slice(index-1)
                parsedWeatherIconData = parsedWeatherIconData.slice(0,logic.countOfTemperatureShown)
                parsedWeatherIconData = parsedWeatherIconData.map(value => {
                                                                      return appData.weatherIcon.getWeatherIcon(value)
                                                                  });

                parsedWeatherIconDescription = parsedWeatherIconDescription.slice(index-1)
                parsedWeatherIconDescription = parsedWeatherIconDescription[0]


                var tempDetailsValues=[]

                tempDetailsValues[0] = data.precipitation;
                tempDetailsValues[1] = data.relativehumidity_2m;
                tempDetailsValues[2] = data.surface_pressure;
                tempDetailsValues[3] = data.soil_moisture_0_1cm;
                tempDetailsValues[4] = data.windspeed_10m;
                tempDetailsValues[5] = data.winddirection_10m;

                tempDetailsValues[5] = tempDetailsValues[5].map(value => {
                                                                    value = value * 8 / 360;
                                                                    value = Math.round(value, 0);
                                                                    value = (value + 8) % 8
                                                                    return appData.directionsNames[value]
                                                                }
                                                                )

                uiDisplayData.hourlyTimeData = parsedTimeData
                uiDisplayData.hourlyTemperatureData = parsedTemperatureData
                uiDisplayData.hourlyIconCodeData = parsedWeatherIconData
                uiDisplayData.detailsValues = tempDetailsValues
                uiDisplayData.currentWeatherDescription = appData.weatherIcon.classifyWeatherIconDescription(parsedWeatherIconDescription)


                console.log("HomePageLogic: Complete Data for the home page:")
            }
        }

        function parseHourlyDetailsUnits(data) {
            console.log("HomePageLogic: Parsing details data",data)

            var tempDetailsValuesUnits = []

            tempDetailsValuesUnits[0] = data.precipitation;
            tempDetailsValuesUnits[1] = data.relativehumidity_2m;
            tempDetailsValuesUnits[2] = data.surface_pressure;
            tempDetailsValuesUnits[3] = data.soil_moisture_0_1cm;
            tempDetailsValuesUnits[4] = data.windspeed_10m;
            tempDetailsValuesUnits[5] = ""

            uiDisplayData.detailsValuesUnits = tempDetailsValuesUnits
        }
    }

    QtObject {
        id: daily

        property string longitude: ""
        property string latitude: ""
        property string timezone: ""

        property string url: daily.getDailyRequestURL()

        function getDailyRequestURL() {
            return appData.apiURL + daily.latitude + "&longitude="  + daily.longitude + "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=" + daily.timezone
        }

        function requestData() {
            console.log("HomePageLogic: Requesting for daily data:",url)
            HttpRequest
            .get(daily.url)
            .timeout(5000)
            .end(function(err, res) {
                if(res.ok) {
                    var data = res.body
                    internal.dailyData = data;
                    errorCheck()
                }
                else {
                    console.log("HomePageLogic: ", err.message)
                    console.log("HomePageLogic: ", err.response)
                    logic.error()
                }
            });
        }

        function errorCheck() {
            console.log("HomePageLogic: @@Checking for Errors 'Daily'")
            if(internal.dailyData.daily) {
                console.log("HomePageLogic: Daily ACK")
                daily.parseDailyData(internal.dailyData.daily)
                logic.allRequestsCompleted();

            } else {
                console.log("HomePageLogic: Daily ACK Failed")
                console.log("HomePageLogic: ",data.hourly.time)
                logic.error()
            }
        }


        function parseDailyData(data) {
            console.log("HomePageLogic: Parsing Daily Data")

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
                                                                  return appData.weatherIcon.getWeatherIcon(value);
                                                              });

            parsedSunriseData = parsedSunriseData.map(value => {
                                                              return appData.convertDailyTime(value)
                                                          });

            parsedSunsetData = parsedSunsetData.map(value => {
                                                              return appData.convertDailyTime(value)
                                                          });

            uiDisplayData.dailyDate = parsedTimeData;
            uiDisplayData.dailyWeatherIcon = parsedWeatherCodeData;
            uiDisplayData.dailySunriseData = parsedSunriseData;
            uiDisplayData.dailySunsetData = parsedSunsetData;
            uiDisplayData.dailyMaxTemperatureData = parsedMaxTemperatureData;
            uiDisplayData.dailyMinTemperatureData = parsedMinTemperatureData;

            console.log("HomePageLogic: Printing Daily Sunrise Time:",parsedSunriseData)
        }
    }

    QtObject {
        id: uiDisplayData

        //Hourly Data
        property var hourlyTimeData:[];
        property var hourlyTemperatureData:[];
        property var hourlyIconCodeData:[];


        //Daily Data
        property var dailySunriseData: [];
        property var dailyMaxTemperatureData: [];
        property var dailySunsetData: [];
        property var dailyMinTemperatureData: [];
        property var dailyDate: []
        property var dailyWeatherIcon: []

        // Features Displayed in Details Section
        property var detailsLabels: ["Precipitation", "Humidity", "Pressure", "Soil Moisture", "Wind Speed", "Wind Direction"]

        // Details features and units
        property var detailsValues: [];
        property var detailsValuesUnits:[];

        property string currentWeatherDescription: ""
    }

    function requestHourlyWeather(latitude,longitude,timezone) {
        console.log("HomePageLogic: Requesting Hourly Weather:",latitude,longitude,timezone)
        hourly.latitude = latitude;
        hourly.longitude = longitude;
        hourly.timezone = timezone;

        hourly.requestData()
    }

    function requestDailyWeather(latitude,longitude,timezone) {
        console.log("HomePageLogic: Requesting Daily Weather:",latitude,longitude,timezone)
        daily.latitude = latitude;
        daily.longitude = longitude;
        daily.timezone = timezone;

        daily.requestData()
    }
}

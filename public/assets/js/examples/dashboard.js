'use strict';
$(document).ready(function () {

    var colors = {
        primary: $('.colors .bg-primary').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        primaryLight: $('.colors .bg-primary-bright').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        secondary: $('.colors .bg-secondary').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        secondaryLight: $('.colors .bg-secondary-bright').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        info: $('.colors .bg-info').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        infoLight: $('.colors .bg-info-bright').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        success: $('.colors .bg-success').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        successLight: $('.colors .bg-success-bright').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        danger: $('.colors .bg-danger').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        dangerLight: $('.colors .bg-danger-bright').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        warning: $('.colors .bg-warning').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(','),
        warningLight: $('.colors .bg-warning-bright').css('background-color').replace('rgb', '').replace(')', '').replace('(', '').split(',')
    };

    var rgbToHex = function (rgb) {
        var hex = Number(rgb).toString(16);
        if (hex.length < 2) {
            hex = "0" + hex;
        }
        return hex;
    };

    var fullColorHex = function (r, g, b) {
        var red = rgbToHex(r);
        var green = rgbToHex(g);
        var blue = rgbToHex(b);
        return red + green + blue;
    };

    colors.primary = '#' + fullColorHex(colors.primary[0], colors.primary[1], colors.primary[2]);
    colors.secondary = '#' + fullColorHex(colors.secondary[0], colors.secondary[1], colors.secondary[2]);
    colors.info = '#' + fullColorHex(colors.info[0], colors.info[1], colors.info[2]);
    colors.success = '#' + fullColorHex(colors.success[0], colors.success[1], colors.success[2]);
    colors.danger = '#' + fullColorHex(colors.danger[0], colors.danger[1], colors.danger[2]);
    colors.warning = '#' + fullColorHex(colors.warning[0], colors.warning[1], colors.warning[2]);

    /**
     *  Slick slide example
     **/

    if ($('.slick-single-item').length) {
        $('.slick-single-item').slick({
            autoplay: true,
            autoplaySpeed: 3000,
            infinite: true,
            slidesToShow: 4,
            slidesToScroll: 4,
            prevArrow: '.slick-single-arrows a:eq(0)',
            nextArrow: '.slick-single-arrows a:eq(1)',
            responsive: [
                {
                    breakpoint: 1300,
                    settings: {
                        slidesToShow: 3,
                        slidesToScroll: 3,
                    }
                },
                {
                    breakpoint: 992,
                    settings: {
                        slidesToShow: 3,
                        slidesToScroll: 3,
                    }
                },
                {
                    breakpoint: 768,
                    settings: {
                        slidesToShow: 2,
                        slidesToScroll: 2
                    }
                },
                {
                    breakpoint: 540,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1
                    }
                }
            ]
        });
    }

    if ($('.reportrange').length > 0) {
        var start = moment().subtract(29, 'days');
        var end = moment();

        function cb(start, end) {
            $('.reportrange .text').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        }

        $('.reportrange').daterangepicker({
            startDate: start,
            endDate: end,
            ranges: {
                'Today': [moment(), moment()],
                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        }, cb);

        cb(start, end);
    }

    var chartColors = {
        primary: {
            base: '#3f51b5',
            light: '#c0c5e4'
        },
        danger: {
            base: '#f2125e',
            light: '#fcd0df'
        },
        success: {
            base: '#0acf97',
            light: '#cef5ea'
        },
        warning: {
            base: '#ff8300',
            light: '#ffe6cc'
        },
        info: {
            base: '#00bcd4',
            light: '#e1efff'
        },
        dark: '#37474f',
        facebook: '#3b5998',
        twitter: '#55acee',
        linkedin: '#0077b5',
        instagram: '#517fa4',
        whatsapp: '#25D366',
        dribbble: '#ea4c89',
        google: '#DB4437',
        borderColor: '#e8e8e8',
        fontColor: '#999'
    };

    if ($('body').hasClass('dark')) {
        chartColors.borderColor = 'rgba(255, 255, 255, .1)';
        chartColors.fontColor = 'rgba(255, 255, 255, .4)';
    }

    /// Chartssssss

    chart_demo_1();

    chart_demo_2();

    chart_demo_3();

    chart_demo_4();

    chart_demo_5();

    chart_demo_6();

    chart_demo_7();

    chart_demo_8();

    chart_demo_9();

    chart_demo_10();

    function chart_demo_1() {
        if ($('#chart_demo_1').length) {
            var element = document.getElementById("chart_demo_1");
            element.height = 146;
            new Chart(element, {
                type: 'bar',
                data: {
                    labels: ["2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"],
                    datasets: [
                        {
                            label: "Total Sales",
                            backgroundColor: colors.primary,
                            data: [133, 221, 783, 978, 214, 421, 211, 577]
                        }, {
                            label: "Average",
                            backgroundColor: colors.info,
                            data: [408, 947, 675, 734, 325, 672, 632, 213]
                        }
                    ]
                },
                options: {
                    legend: {
                        display: false
                    },
                    scales: {
                        xAxes: [{
                            ticks: {
                                fontSize: 11,
                                fontColor: chartColors.fontColor
                            },
                            gridLines: {
                                display: false,
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                fontSize: 11,
                                fontColor: chartColors.fontColor
                            },
                            gridLines: {
                                color: chartColors.borderColor
                            }
                        }],
                    }
                }
            })
        }
    }

    function chart_demo_2() {
        if ($('#chart_demo_2').length) {
            var ctx = document.getElementById('chart_demo_2').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ["Jun 2016", "Jul 2016", "Aug 2016", "Sep 2016", "Oct 2016", "Nov 2016", "Dec 2016", "Jan 2017", "Feb 2017", "Mar 2017", "Apr 2017", "May 2017"],
                    datasets: [{
                        label: "Rainfall",
                        backgroundColor: chartColors.primary.light,
                        borderColor: chartColors.primary.base,
                        data: [26.4, 39.8, 66.8, 66.4, 40.6, 55.2, 77.4, 69.8, 57.8, 76, 110.8, 142.6],
                    }]
                },
                options: {
                    legend: {
                        display: false,
                        labels: {
                            fontColor: chartColors.fontColor
                        }
                    },
                    title: {
                        display: true,
                        text: 'Precipitation in Toronto',
                        fontColor: chartColors.fontColor,
                    },
                    scales: {
                        yAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor,
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Precipitation in mm',
                                fontColor: chartColors.fontColor,
                            }
                        }],
                        xAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor,
                                beginAtZero: true
                            }
                        }]
                    }
                }
            });
        }
    }

    function chart_demo_3() {
        if ($('#chart_demo_3').length) {
            var element = document.getElementById("chart_demo_3"),
                ctx = element.getContext("2d");


            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                    datasets: [{
                        label: 'Success',
                        borderColor: colors.success,
                        data: [-10, 30, -20, 0, 25, 44, 30, 15, 20, 10, 5, -5],
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        borderDash: [2, 2],
                        fill: false
                    }, {
                        label: 'Return',
                        fill: false,
                        borderDash: [2, 2],
                        borderColor: colors.danger,
                        data: [20, 0, 22, 39, -10, 19, -7, 0, 15, 0, -10, 5],
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }]
                },
                options: {
                    responsive: true,
                    legend: {
                        display: false,
                        labels: {
                            fontColor: chartColors.fontColor
                        }
                    },
                    title: {
                        display: false,
                        fontColor: chartColors.fontColor
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false,
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor,
                                display: false
                            }
                        }],
                        yAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor,
                                min: -50,
                                max: 50
                            }
                        }],
                    }
                }
            });

        }
    }

    function chart_demo_4() {
        if ($('#chart_demo_4').length) {
            var ctx = document.getElementById("chart_demo_4").getContext("2d");
            var densityData = {
                backgroundColor: chartColors.primary.light,
                data: [10, 20, 40, 60, 80, 40, 60, 80, 40, 80, 20, 59]
            };
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                    datasets: [densityData]
                },
                options: {
                    scaleFontColor: "#FFFFFF",
                    legend: {
                        display: false,
                        labels: {
                            fontColor: chartColors.fontColor
                        }
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor
                            }
                        }],
                        yAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor,
                                min: 0,
                                max: 100,
                                beginAtZero: true
                            }
                        }]
                    }
                }
            });
        }
    }

    function chart_demo_5() {
        if ($('#chart_demo_5').length) {
            var ctx = document.getElementById('chart_demo_5').getContext('2d');
            window.myBar = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['January', 'February', 'March', 'April', 'May'],
                    datasets: [
                        {
                            label: 'Dataset 1',
                            backgroundColor: [
                                chartColors.info.base,
                                chartColors.success.base,
                                chartColors.danger.base,
                                chartColors.dark,
                                chartColors.warning.base,
                            ],
                            yAxisID: 'y-axis-1',
                            data: [33, 56, -40, 25, 45]
                        },
                        {
                            label: 'Dataset 2',
                            backgroundColor: chartColors.info.base,
                            yAxisID: 'y-axis-2',
                            data: [23, 86, -40, 5, 45]
                        }
                    ]
                },
                options: {
                    legend: {
                        labels: {
                            fontColor: chartColors.fontColor
                        }
                    },
                    responsive: true,
                    title: {
                        display: true,
                        text: 'Chart.js Bar Chart - Multi Axis',
                        fontColor: chartColors.fontColor
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: true
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor
                            }
                        }],
                        yAxes: [
                            {
                                type: 'linear',
                                display: true,
                                position: 'left',
                                id: 'y-axis-1',
                            },
                            {
                                gridLines: {
                                    color: chartColors.borderColor
                                },
                                ticks: {
                                    fontColor: chartColors.fontColor
                                }
                            },
                            {
                                type: 'linear',
                                display: true,
                                position: 'right',
                                id: 'y-axis-2',
                                gridLines: {
                                    drawOnChartArea: false
                                },
                                ticks: {
                                    fontColor: chartColors.fontColor
                                }
                            }
                        ],
                    }
                }
            });
        }
    }

    function chart_demo_6() {
        if ($('#chart_demo_6').length) {
            var ctx = document.getElementById("chart_demo_6").getContext("2d");
            var speedData = {
                labels: ["0s", "10s", "20s", "30s", "40s", "50s", "60s"],
                datasets: [{
                    label: "Car Speed (mph)",
                    borderColor: chartColors.primary.base,
                    backgroundColor: 'rgba(0, 0, 0, 0',
                    data: [0, 59, 75, 20, 20, 55, 40]
                }]
            };
            var chartOptions = {
                legend: {
                    scaleFontColor: "#FFFFFF",
                    position: 'top',
                    labels: {
                        fontColor: chartColors.fontColor
                    }
                },
                scales: {
                    xAxes: [{
                        gridLines: {
                            color: chartColors.borderColor
                        },
                        ticks: {
                            fontColor: chartColors.fontColor
                        }
                    }],
                    yAxes: [{
                        gridLines: {
                            color: chartColors.borderColor
                        },
                        ticks: {
                            fontColor: chartColors.fontColor
                        }
                    }]
                }
            };
            new Chart(ctx, {
                type: 'line',
                data: speedData,
                options: chartOptions
            });
        }
    }

    function chart_demo_7() {
        if ($('#chart_demo_7').length) {
            var config = {
                type: 'pie',
                data: {
                    datasets: [{
                        borderWidth: 3,
                        borderColor: $('body').hasClass('dark') ? "#313852" : "rgba(255, 255, 255, 1)",
                        data: [
                            1242,
                            742,
                            442,
                            1742
                        ],
                        backgroundColor: [
                            colors.danger,
                            colors.info,
                            colors.warning,
                            colors.success
                        ],
                        label: 'Dataset 1'
                    }],
                    labels: [
                        'Organic Search',
                        'Email',
                        'Refferal',
                        'Social Media',
                    ]
                },
                options: {
                    responsive: true,
                    legend: {
                        display: false
                    }
                }
            };

            var ctx = document.getElementById('chart_demo_7').getContext('2d');
            new Chart(ctx, config);
        }
    }

    function chart_demo_8() {
        if ($('#chart_demo_8').length) {
            new Chart(document.getElementById("chart_demo_8"), {
                type: 'radar',
                data: {
                    labels: ["Africa", "Asia", "Europe", "Latin America", "North America"],
                    datasets: [
                        {
                            label: "1950",
                            fill: true,
                            backgroundColor: "rgba(179,181,198,0.2)",
                            borderColor: "rgba(179,181,198,1)",
                            pointBorderColor: "#fff",
                            pointBackgroundColor: "rgba(179,181,198,1)",
                            data: [-8.77, -55.61, 21.69, 6.62, 6.82]
                        }, {
                            label: "2050",
                            fill: true,
                            backgroundColor: "rgba(255,99,132,0.2)",
                            borderColor: "rgba(255,99,132,1)",
                            pointBorderColor: "#fff",
                            pointBackgroundColor: "rgba(255,99,132,1)",
                            data: [-25.48, 54.16, 7.61, 8.06, 4.45]
                        }
                    ]
                },
                options: {
                    legend: {
                        labels: {
                            fontColor: chartColors.fontColor
                        }
                    },
                    scale: {
                        gridLines: {
                            color: chartColors.borderColor
                        }
                    },
                    title: {
                        display: true,
                        text: 'Distribution in % of world population',
                        fontColor: chartColors.fontColor
                    }
                }
            });
        }
    }

    function chart_demo_9() {
        if ($('#chart_demo_9').length) {
            new Chart(document.getElementById("chart_demo_9"), {
                type: 'horizontalBar',
                data: {
                    labels: ["Africa", "Asia", "Europe", "Latin America", "North America"],
                    datasets: [
                        {
                            label: "Population (millions)",
                            backgroundColor: colors.primary,
                            data: [2478, 2267, 734, 1284, 1933]
                        }
                    ]
                },
                options: {
                    legend: {
                        display: false
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor,
                                display: false
                            }
                        }],
                        yAxes: [{
                            gridLines: {
                                color: chartColors.borderColor,
                                display: false
                            },
                            ticks: {
                                fontColor: chartColors.fontColor
                            },
                            barPercentage: 0.5
                        }]
                    }
                }
            });
        }
    }

    function chart_demo_10() {
        if ($('#chart_demo_10').length) {
            var element = document.getElementById("chart_demo_10");
            new Chart(element, {
                type: 'bar',
                data: {
                    labels: ["1900", "1950", "1999", "2050"],
                    datasets: [
                        {
                            label: "Europe",
                            type: "line",
                            borderColor: "#8e5ea2",
                            data: [408, 547, 675, 734],
                            fill: false
                        },
                        {
                            label: "Africa",
                            type: "line",
                            borderColor: "#3e95cd",
                            data: [133, 221, 783, 2478],
                            fill: false
                        },
                        {
                            label: "Europe",
                            type: "bar",
                            backgroundColor: chartColors.primary.base,
                            data: [408, 547, 675, 734],
                        },
                        {
                            label: "Africa",
                            type: "bar",
                            backgroundColor: chartColors.primary.light,
                            data: [133, 221, 783, 2478]
                        }
                    ]
                },
                options: {
                    title: {
                        display: true,
                        text: 'Population growth (millions): Europe & Africa',
                        fontColor: chartColors.fontColor
                    },
                    legend: {
                        display: true,
                        labels: {
                            fontColor: chartColors.fontColor
                        }
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor
                            }
                        }],
                        yAxes: [{
                            gridLines: {
                                color: chartColors.borderColor
                            },
                            ticks: {
                                fontColor: chartColors.fontColor
                            }
                        }]
                    }
                }
            });
        }
    }

    if ($('#circle-1').length) {
        $('#circle-1').circleProgress({
            startAngle: 1.55,
            value: 0.65,
            size: 90,
            thickness: 10,
            fill: {
                color: colors.primary
            }
        });
    }

    if ($('#sales-circle-graphic').length) {
        $('#sales-circle-graphic').circleProgress({
            startAngle: 1.55,
            value: 0.65,
            size: 180,
            thickness: 30,
            fill: {
                color: colors.primary
            }
        });
    }

    if ($('#circle-2').length) {
        $('#circle-2').circleProgress({
            startAngle: 1.55,
            value: 0.35,
            size: 90,
            thickness: 10,
            fill: {
                color: colors.warning
            }
        });
    }

    ////////////////////////////////////////////

    if ($(".dashboard-pie-1").length) {
        $(".dashboard-pie-1").peity("pie", {
            fill: [colors.primaryLight, colors.primary],
            radius: 30
        });
    }

    if ($(".dashboard-pie-2").length) {
        $(".dashboard-pie-2").peity("pie", {
            fill: [colors.successLight, colors.success],
            radius: 30
        });
    }

    if ($(".dashboard-pie-3").length) {
        $(".dashboard-pie-3").peity("pie", {
            fill: [colors.warningLight, colors.warning],
            radius: 30
        });
    }

    if ($(".dashboard-pie-4").length) {
        $(".dashboard-pie-4").peity("pie", {
            fill: [colors.infoLight, colors.info],
            radius: 30
        });
    }

    ////////////////////////////////////////////

    function bar_chart() {
        if ($('#chart-ticket-status').length > 0) {
            var dataSource = [
                {country: "USA", hydro: 59.8, oil: 937.6, gas: 582, coal: 564.3, nuclear: 187.9},
                {country: "China", hydro: 74.2, oil: 308.6, gas: 35.1, coal: 956.9, nuclear: 11.3},
                {country: "Russia", hydro: 40, oil: 128.5, gas: 361.8, coal: 105, nuclear: 32.4},
                {country: "Japan", hydro: 22.6, oil: 241.5, gas: 64.9, coal: 120.8, nuclear: 64.8},
                {country: "India", hydro: 19, oil: 119.3, gas: 28.9, coal: 204.8, nuclear: 3.8},
                {country: "Germany", hydro: 6.1, oil: 123.6, gas: 77.3, coal: 85.7, nuclear: 37.8}
            ];

            // Return with commas in between
            var numberWithCommas = function (x) {
                return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            };

            var dataPack1 = [40, 47, 44, 38, 27, 40, 47, 44, 38, 27, 40, 27];
            var dataPack2 = [10, 12, 7, 5, 4, 10, 12, 7, 5, 4, 10, 12];
            var dataPack3 = [17, 11, 22, 18, 12, 17, 11, 22, 18, 12, 17, 11];
            var dates = ["Jan", "Jan", "Jan", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"];

            var bar_ctx = document.getElementById('chart-ticket-status');

            bar_ctx.height = 115;

            new Chart(bar_ctx, {
                    type: 'bar',
                    data: {
                        labels: dates,
                        datasets: [
                            {
                                label: 'New Tickets',
                                data: dataPack1,
                                backgroundColor: colors.primary,
                                hoverBorderWidth: 0
                            },
                            {
                                label: 'Solved Tickets',
                                data: dataPack2,
                                backgroundColor: colors.success,
                                hoverBorderWidth: 0
                            },
                            {
                                label: 'Pending Tickets',
                                data: dataPack3,
                                backgroundColor: colors.info,
                                hoverBorderWidth: 0
                            },
                        ]
                    },
                    options: {
                        legend: {
                            display: false
                        },
                        animation: {
                            duration: 10,
                        },
                        tooltips: {
                            mode: 'label',
                            callbacks: {
                                label: function (tooltipItem, data) {
                                    return data.datasets[tooltipItem.datasetIndex].label + ": " + numberWithCommas(tooltipItem.yLabel);
                                }
                            }
                        },
                        scales: {
                            xAxes: [{
                                stacked: true,
                                gridLines: {display: false},
                                ticks: {
                                    fontSize: 11,
                                    fontColor: chartColors.fontColor
                                }
                            }],
                            yAxes: [{
                                stacked: true,
                                ticks: {
                                    callback: function (value) {
                                        return numberWithCommas(value);
                                    },
                                    fontSize: 11,
                                    fontColor: chartColors.fontColor
                                },
                            }],
                        }
                    },
                    plugins: [{
                        beforeInit: function (chart) {
                            chart.data.labels.forEach(function (value, index, array) {
                                var a = [];
                                a.push(value.slice(0, 5));
                                var i = 1;
                                while (value.length > (i * 5)) {
                                    a.push(value.slice(i * 5, (i + 1) * 5));
                                    i++;
                                }
                                array[index] = a;
                            })
                        }
                    }]
                }
            );
        }
    }

    bar_chart();

    function online_users() {
        if ($('#online-users').length > 0) {
            var lastDate = 0;
            var data = []
            var TICKINTERVAL = 86400000
            let XAXISRANGE = 777600000

            function getDayWiseTimeSeries(baseval, count, yrange) {
                var i = 0;
                while (i < count) {
                    var x = baseval;
                    var y = Math.floor(Math.random() * (yrange.max - yrange.min + 1)) + yrange.min;

                    data.push({
                        x, y
                    });
                    lastDate = baseval
                    baseval += TICKINTERVAL;
                    i++;
                }
            }

            getDayWiseTimeSeries(new Date('11 Feb 2017 GMT').getTime(), 10, {
                min: 10,
                max: 90
            })

            function getNewSeries(baseval, yrange) {
                var newDate = baseval + TICKINTERVAL;
                lastDate = newDate

                for (var i = 0; i < data.length - 10; i++) {
                    // IMPORTANT
                    // we reset the x and y of the data which is out of drawing area
                    // to prevent memory leaks
                    data[i].x = newDate - XAXISRANGE - TICKINTERVAL
                    data[i].y = 0
                }

                data.push({
                    x: newDate,
                    y: Math.floor(Math.random() * (yrange.max - yrange.min + 1)) + yrange.min
                })
            }

            function resetData() {
                // Alternatively, you can also reset the data at certain intervals to prevent creating a huge series
                data = data.slice(data.length - 10, data.length);
            }

            var options = {
                series: [{
                    data: data.slice()
                }],
                chart: {
                    id: 'realtime',
                    height: 330,
                    type: 'line',
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false
                    },
                    zoom: {
                        enabled: false
                    }
                },
                dataLabels: {
                    enabled: false
                },
                stroke: {
                    curve: 'smooth',
                    width: 3,
                    colors: ['#ffffff'],
                },
                xaxis: {
                    labels: {
                        show: false,
                    },
                    type: 'datetime',
                    range: XAXISRANGE,
                    axisBorder: {
                        show: false,
                    }
                },
                yaxis: {
                    show: false,
                    max: 100
                },
                grid: {
                    show: false,
                }
            };

            var chart = new ApexCharts(document.querySelector("#online-users"), options);
            chart.render();

            window.setInterval(function () {
                getNewSeries(lastDate, {
                    min: 10,
                    max: 90
                });

                chart.updateSeries([{
                    data: data
                }])
            }, 1000)
        }
    }

    online_users();

    function customerGrowth() {
        if ($('#customer-growth').length > 0) {
            var options = {
                chart: {
                    height: 350,
                    type: 'area',
                    offsetX: -20,
                    offsetY: -10,
                    width: '103%',
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false,
                    }
                },
                dataLabels: {
                    enabled: false
                },
                colors: [colors.primary],
                stroke: {
                    curve: 'smooth',
                    width: 2,
                },
                series: [{
                    name: 'Sales',
                    data: [80, 40, 60, 90, 50, 100, 90, 80, 45, 75, 50, 100]
                }],
                fill: {
                    type: 'gradient',
                    gradient: {
                        opacityFrom: 0.6,
                        opacityTo: 0,
                    }
                },
                xaxis: {
                    categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                }
            };

            var chart = new ApexCharts(
                document.querySelector("#customer-growth"),
                options
            );

            chart.render();
        }
    }

    customerGrowth();

    function device_session_chart() {
        if ($('#device_session_chart').length) {

            var data = [
                {
                    name: "Mobile",
                    data: [90, 152, 138, 145, 120, 123, 140]
                },
                {
                    name: "Tablet",
                    data: [125, 90, 128, 135, 150, 123, 180]
                },
                {
                    name: "Desktop",
                    data: [50, 200, 138, 135, 100, 123, 90]
                }
            ];

            var options = {
                chart: {
                    type: 'area',
                    fontFamily: 'Inter',
                    height: 300,
                    offsetX: -18,
                    width: '103%',
                    stacked: true,
                    events: {
                        selection: function (chart, e) {
                            // console.log(new Date(e.xaxis.min))
                        }
                    },
                    toolbar: {
                        show: false,
                    }

                },
                colors: [colors.primary, colors.secondary, colors.success],
                dataLabels: {
                    enabled: false
                },
                stroke: {
                    curve: 'smooth',
                    width: 1
                },
                series: data,
                fill: {
                    type: 'gradient',
                    gradient: {
                        opacityFrom: .6,
                        opacityTo: 0,
                    }
                },
                legend: {
                    show: false
                },
                xaxis: {
                    categories: [
                        "01 Jan",
                        "02 Jan",
                        "03 Jan",
                        "04 Jan",
                        "05 Jan",
                        "06 Jan",
                        "07 Jan"
                    ]
                }
            };

            var chart = new ApexCharts(
                document.querySelector("#device_session_chart"),
                options
            );

            chart.render();

            /*
              // this function will generate output in this format
              // data = [
                  [timestamp, 23],
                  [timestamp, 33],
                  [timestamp, 12]
                  ...
              ]
              */
            function generateDayWiseTimeSeries(baseval, count, yrange) {
                var i = 0;
                var series = [];
                while (i < count) {
                    var x = baseval;
                    var y = Math.floor(Math.random() * (yrange.max - yrange.min + 1)) + yrange.min;

                    series.push([x, y]);
                    baseval += 86400000;
                    i++;
                }
                return series;
            }
        }
    }

    device_session_chart();

    function analytics_tab1() {
        if ($('#analytics-tab-1').length) {
            var options = {
                series: [{
                    name: 'Users',
                    data: [20, 25, 15, 12, 25, 20, 22]
                }],
                chart: {
                    height: 280,
                    type: 'line',
                    offsetX: -20,
                    offsetY: 20,
                    width: '102%',
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false,
                    }
                },
                stroke: {
                    width: 3,
                    curve: 'smooth'
                },
                xaxis: {
                    type: 'datetime',
                    categories: [
                        "01 Jan",
                        "02 Jan",
                        "03 Jan",
                        "04 Jan",
                        "05 Jan",
                        "06 Jan",
                        "07 Jan"
                    ]
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        shade: 'dark',
                        gradientToColors: [colors.secondary],
                        shadeIntensity: 1,
                        type: 'horizontal',
                        opacityFrom: 1,
                        opacityTo: 1,
                        stops: [0, 100, 100, 100]
                    },
                }
            };

            var chart = new ApexCharts(document.querySelector("#analytics-tab-1"), options);
            chart.render();
        }
    }

    analytics_tab1();

    function analytics_tab2() {
        if ($('#analytics-tab-2').length) {
            var options = {
                series: [{
                    name: 'Conversations',
                    data: [10, 35, 10, 22, 25, 10, 30]
                }],
                chart: {
                    height: 280,
                    type: 'line',
                    offsetX: -20,
                    offsetY: 20,
                    width: '102%',
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false,
                    }
                },
                stroke: {
                    width: 3,
                    curve: 'smooth'
                },
                xaxis: {
                    type: 'datetime',
                    categories: [
                        "01 Jan",
                        "02 Jan",
                        "03 Jan",
                        "04 Jan",
                        "05 Jan",
                        "06 Jan",
                        "07 Jan"
                    ]
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        shade: 'dark',
                        gradientToColors: [colors.secondary],
                        shadeIntensity: 1,
                        type: 'horizontal',
                        opacityFrom: 1,
                        opacityTo: 1,
                        stops: [0, 100, 100, 100]
                    },
                }
            };

            var chart = new ApexCharts(document.querySelector("#analytics-tab-2"), options);
            chart.render();
        }
    }

    analytics_tab2();

    function analytics_tab3() {
        if ($('#analytics-tab-3').length) {
            var options = {
                series: [{
                    name: 'Bounce Rate',
                    data: [20.5, 30.6, 25.6, 22.6, 25.1, 15.5, 18.0]
                }],
                chart: {
                    height: 280,
                    type: 'line',
                    offsetX: -20,
                    offsetY: 20,
                    width: '102%',
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false,
                    }
                },
                stroke: {
                    width: 3,
                    curve: 'smooth'
                },
                xaxis: {
                    type: 'datetime',
                    categories: [
                        "01 Jan",
                        "02 Jan",
                        "03 Jan",
                        "04 Jan",
                        "05 Jan",
                        "06 Jan",
                        "07 Jan"
                    ]
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        shade: 'dark',
                        gradientToColors: [colors.secondary],
                        shadeIntensity: 1,
                        type: 'horizontal',
                        opacityFrom: 1,
                        opacityTo: 1,
                        stops: [0, 100, 100, 100]
                    },
                },
                tooltip: {
                    y: {
                        formatter: function (val) {
                            return "%" + val
                        }
                    }
                }
            };

            var chart = new ApexCharts(document.querySelector("#analytics-tab-3"), options);
            chart.render();
        }
    }

    analytics_tab3();

    function analytics_tab4() {
        if ($('#analytics-tab-4').length) {
            var options = {
                series: [{
                    name: 'Session Duration',
                    data: [25, 30, 25, 32, 25, 30, 18]
                }],
                chart: {
                    height: 280,
                    type: 'line',
                    offsetX: -20,
                    offsetY: 20,
                    width: '102%',
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false,
                    }
                },
                stroke: {
                    width: 3,
                    curve: 'smooth'
                },
                xaxis: {
                    type: 'datetime',
                    categories: [
                        "01 Jan 2020 18:50",
                        "02 Jan 2020 18:50",
                        "03 Jan 2020 18:50",
                        "04 Jan 2020 18:50",
                        "05 Jan 2020 18:50",
                        "06 Jan 2020 18:50",
                        "07 Jan 2020 18:50"
                    ]
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        shade: 'dark',
                        gradientToColors: [colors.secondary],
                        shadeIntensity: 1,
                        type: 'horizontal',
                        opacityFrom: 1,
                        opacityTo: 1,
                        stops: [0, 100, 100, 100]
                    },
                }
            };

            var chart = new ApexCharts(document.querySelector("#analytics-tab-4"), options);
            chart.render();
        }
    }

    analytics_tab4();

    function chart1() {
        if ($('#chart1').length) {
            var options = {
                chart: {
                    type: 'bar',
                    toolbar: {
                        show: false
                    }
                },
                plotOptions: {
                    bar: {
                        horizontal: false,
                        columnWidth: '55%',
                        backgroundBarColors: ['red']
                    },
                },
                dataLabels: {
                    enabled: false
                },
                stroke: {
                    show: true,
                    width: 1,
                    colors: ['transparent']
                },
                colors: [colors.secondary, colors.info, colors.warning],
                series: [{
                    name: 'Net Profit',
                    data: [44, 55, 57, 56, 61, 58, 63, 60, 66]
                }, {
                    name: 'Revenue',
                    data: [76, 85, 101, 98, 87, 105, 91, 114, 94]
                }, {
                    name: 'Free Cash Flow',
                    data: [35, 41, 36, 26, 45, 48, 52, 53, 41]
                }],
                xaxis: {
                    categories: ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
                },
                legend: {
                    position: 'bottom',
                    offsetY: -10
                },
                tooltip: {
                    y: {
                        formatter: function (val) {
                            return "$ " + val + " thousands"
                        }
                    }
                }
            };

            var chart = new ApexCharts(
                document.querySelector("#chart1"),
                options
            );

            chart.render();
        }
    }

    chart1();

    function widget_chart1() {
        if ($('#widget-chart1').length) {
            var ctx = document.getElementById("widget-chart1");
            ctx.height = 50;
            new Chart(ctx.getContext('2d'), {
                type: 'line',
                data: {
                    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sst", "Sun"],
                    datasets: [{
                        label: 'data-2',
                        data: [5, 15, 5, 20, 5, 15, 5],
                        backgroundColor: "rgba(0,0,255,0)",
                        borderWidth: 1,
                        borderColor: colors.success,
                        pointBorder: false,
                    }]
                },
                options: {
                    elements: {
                        point: {
                            radius: 0
                        }
                    },
                    tooltips: {
                        enabled: false
                    },
                    legend: {
                        display: false
                    },
                    scales: {
                        yAxes: [{
                            display: false,
                        }],
                        xAxes: [{
                            display: false
                        }]
                    },
                }
            });
        }
    }

    widget_chart1();

    function widget_chart2() {
        if ($('#widget-chart2').length) {
            var ctx = document.getElementById("widget-chart2");
            ctx.height = 50;
            var barChart = new Chart(ctx.getContext('2d'), {
                type: 'line',
                data: {
                    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sst", "Sun"],
                    datasets: [{
                        label: 'data-2',
                        data: [5, 10, 10, 10, 5, 15, 10],
                        backgroundColor: "rgba(0,0,255,0)",
                        borderColor: colors.warning,
                        borderWidth: 1,
                        pointBorder: false,
                    }]
                },
                options: {
                    elements: {
                        point: {
                            radius: 0
                        }
                    },
                    tooltips: {
                        enabled: false
                    },
                    legend: {
                        display: false
                    },
                    scales: {
                        yAxes: [{
                            display: false
                        }],
                        xAxes: [{
                            display: false
                        }]
                    },
                }
            });
        }
    }

    widget_chart2();

    function widget_chart3() {
        if ($('#widget-chart3').length) {
            var ctx = document.getElementById("widget-chart3");
            ctx.height = 50;
            var barChart = new Chart(ctx.getContext('2d'), {
                type: 'line',
                data: {
                    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sst", "Sun"],
                    datasets: [{
                        label: 'data-2',
                        data: [10, 5, 15, 5, 15, 5, 15],
                        backgroundColor: "rgba(0,0,255,0)",
                        borderColor: colors.danger,
                        borderWidth: 1,
                        pointBorder: false,
                    }]
                },
                options: {
                    elements: {
                        point: {
                            radius: 0
                        }
                    },
                    tooltips: {
                        enabled: false
                    },
                    legend: {
                        display: false
                    },
                    scales: {
                        yAxes: [{
                            display: false
                        }],
                        xAxes: [{
                            display: false
                        }]
                    },
                }
            });
        }
    }

    widget_chart3();

    function contactsStatuses() {
        if ($('#contacts-statuses').length) {
            var chart = new ApexCharts(
                document.querySelector("#contacts-statuses"), {
                    chart: {
                        width: "100%",
                        type: 'donut',
                    },
                    dataLabels: {
                        enabled: false
                    },
                    stroke: {
                        width: 3,
                        colors: $('body').hasClass('dark') ? "#313852" : "rgba(255, 255, 255, 1)",
                    },
                    series: [44, 55, 13, 33],
                    labels: ['New Contact', 'NR1', 'NR2', 'NR3'],
                    colors: [colors.warning, colors.info, colors.success, colors.danger],
                    legend: {
                        position: 'bottom',
                    }
                }
            );

            chart.render();
        }
    }

    contactsStatuses();

    function revenue() {
        if ($('#revenue').length) {
            var ts2 = 1484418600000;
            var dates = [];
            for (var i = 0; i < 120; i++) {
                ts2 = ts2 + 86400000;
                var innerArr = [ts2, dataSeries[1][i].value];
                dates.push(innerArr)
            }

            var options = {
                chart: {
                    type: 'area',
                    fontFamily: "Inter",
                    offsetX: -18,
                    stacked: false,
                    height: 390,
                    width: '103%',
                    toolbar: {
                        show: false
                    }
                },
                dataLabels: {
                    enabled: false
                },
                series: [{
                    name: 'Number of orders',
                    data: dates
                }],
                stroke: {
                    colors: [colors.primary],
                    width: 2
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        opacityFrom: 0.6,
                        opacityTo: 0,
                    }
                },
                yaxis: {
                    labels: {
                        formatter: function (val) {
                            return (val / 1000000).toFixed(0);
                        },
                    }
                },
                xaxis: {
                    type: 'datetime',
                },

                tooltip: {
                    shared: false,
                    y: {
                        formatter: function (val) {
                            return (val / 1000000).toFixed(0)
                        }
                    }
                }
            };

            var chart = new ApexCharts(
                document.querySelector("#revenue"),
                options
            );

            chart.render();
        }
    }

    revenue();

    function hotProducts() {
        if ($('#hot-products').length) {
            var options = {
                series: [44, 55, 13, 36, 30],
                chart: {
                    type: 'donut',
                    fontFamily: "Inter",
                    offsetY: 30,
                    height: 250,
                },
                colors: [colors.primary, colors.secondary, colors.success, colors.warning, colors.danger],
                labels: ['Iphone', 'Samsung', 'Huawei', 'General Mobile', 'Xiaomi'],
                dataLabels: {
                    enabled: false,

                },
                stroke: {
                    colors: $('body').hasClass('dark') ? "#313852" : "#ffffff",
                },
                legend: {
                    show: false
                }
            };

            var chart = new ApexCharts(document.querySelector("#hot-products"), options);
            chart.render();
        }
    }

    hotProducts();

    function activityChart() {
        if ($('#ecommerce-activity-chart').length) {
            var options = {
                chart: {
                    type: 'bar',
                    fontFamily: "Inter",
                    offsetX: -18,
                    height: 312,
                    width: '103%',
                    toolbar: {
                        show: false
                    }
                },
                series: [{
                    name: 'Comments',
                    data: [44, 55, 57, 56, 61, 58, 63, 60, 66]
                }, {
                    name: 'Product View',
                    data: [76, 85, 101, 98, 87, 105, 91, 114, 94]
                }],
                colors: [colors.secondary, colors.info],
                plotOptions: {
                    bar: {
                        horizontal: false,
                        columnWidth: '50%',
                        endingShape: 'rounded'
                    },
                },
                dataLabels: {
                    enabled: false
                },
                stroke: {
                    show: true,
                    width: 8,
                    colors: ['transparent']
                },
                xaxis: {
                    categories: ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
                },
                fill: {
                    opacity: 1
                },
                legend: {
                    position: "top",
                }
            };

            var chart = new ApexCharts(
                document.querySelector("#ecommerce-activity-chart"),
                options
            );

            chart.render();
        }
    }

    activityChart();

    function projectTasks() {
        if ($('#project-tasks').length) {
            var options = {
                colors: [colors.primary, colors.success, colors.info, colors.warning],
                chart: {
                    height: 350,
                    type: 'bar',
                    stacked: true,
                    offsetY: -30,
                    fontFamily: 'Inter',
                    toolbar: {
                        show: false
                    },
                    zoom: {
                        enabled: false
                    }
                },
                plotOptions: {
                    bar: {
                        horizontal: false,
                    },
                },
                series: [{
                    name: 'Project A',
                    data: [44, 55, 41, 67, 22, 43]
                }, {
                    name: 'Project B',
                    data: [13, 23, 20, 8, 13, 27]
                }, {
                    name: 'Project C',
                    data: [11, 17, 15, 15, 21, 14]
                }, {
                    name: 'Project D',
                    data: [21, 7, 25, 13, 22, 8]
                }],
                xaxis: {
                    type: 'datetime',
                    categories: ['01/01/2011 GMT', '01/02/2011 GMT', '01/03/2011 GMT', '01/04/2011 GMT', '01/05/2011 GMT', '01/06/2011 GMT'],
                },
                legend: {
                    position: 'bottom',
                    offsetY: -10
                },
                fill: {
                    opacity: 1
                },
            };

            var chart = new ApexCharts(
                document.querySelector("#project-tasks"),
                options
            );

            chart.render();
        }
    }

    setInterval(function () {
        $('#online-users-text').text(Math.round(Math.random() * 100));
    }, 2000);

    projectTasks();

});

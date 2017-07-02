Chart.pluginService.register({
            afterUpdate: function (chart) {
                if (chart.config.options.elements.center) {
                    var helpers = Chart.helpers;
                    var centerConfig = chart.config.options.elements.center;
                    var globalConfig = Chart.defaults.global;
                    var ctx = chart.chart.ctx;

                    var fontStyle = helpers.getValueOrDefault(centerConfig.fontStyle, globalConfig.defaultFontStyle);
                    var fontFamily = helpers.getValueOrDefault(centerConfig.fontFamily, globalConfig.defaultFontFamily);

                    // Figure out the best font size, if one is not specified
                    ctx.save();
                    var fontSize = helpers.getValueOrDefault(centerConfig.minFontSize, 12);
                    var maxFontSize = helpers.getValueOrDefault(centerConfig.maxFontSize, 55);
                    var maxText = helpers.getValueOrDefault(centerConfig.maxText, centerConfig.text);

                    do {
                        ctx.font = helpers.fontString(fontSize, fontStyle, fontFamily);
                        var textWidth = ctx.measureText(maxText).width;

                        // Check if it fits, is within configured limits and that we are not simply toggling back and forth
                        if (textWidth < chart.innerRadius * 2 && fontSize < maxFontSize)
                            fontSize += 1;
                        else {
                            // Reverse last step
                            fontSize -= 1;
                            break;
                        }
                    } while (true);
                    ctx.restore();

                    // save properties
                    chart.center = {
                        font: helpers.fontString(fontSize, fontStyle, fontFamily),
                        fillStyle: helpers.getValueOrDefault(centerConfig.fontColor, globalConfig.defaultFontColor)
                    };
                }
            },
            afterDraw: function (chart) {
                if (chart.center) {
                    var centerConfig = chart.config.options.elements.center;
                    var ctx = chart.chart.ctx;

                    ctx.save();
                    ctx.font = chart.center.font;
                    ctx.fillStyle = chart.center.fillStyle;
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    var centerX = (chart.chartArea.left + chart.chartArea.right) / 2;
                    var centerY = (chart.chartArea.top + chart.chartArea.bottom) / 2;
                    ctx.fillText(centerConfig.text, centerX, centerY);
                    ctx.restore();
                }
            },
        });

        function createTestPassRateChart(ctx) {
            var data = {
                labels: ["Pass","Fail"],
                datasets: [
                {
                    data: [{NUMBER_OF_PASSED_TESTS},{NUMBER_OF_FAILED_TESTS}],
                    backgroundColor: ["#a3d48d","#d59595"],
                    hoverBackgroundColor: ["#a3d48d","#d59595"]
                }]
            };
            var newTestPassRateChart = new Chart(ctx, {
                type: 'doughnut',
                data: data,
                options: {
                    cutoutPercentage: 64,
                    legend: { position: 'top' },
                    elements: {
                        center: {
                            // This evaluates the max length of the text
                            maxText: '99.99%',
                            text: '{TESTS_PASS_RATE}%',
                            fontColor: '#a3d48d',
                            fontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
                            fontStyle: 'normal'
                        }
                    }
                }
            });
        }
        var testPassRateCharts = $(".testPassRateChart");
        for (var i = 0; i < testPassRateCharts.length; i++) {
            createTestPassRateChart(testPassRateCharts[i]);
        }

        function createTestCoverageChart(ctx) {
            var data = {
                labels: ["Covered","Missed"],
                datasets: [
                {
                    data: [{TEST_COVERAGE},{CODE_NOT_COVERED}],
                    backgroundColor: ["#a3d48d","#d59595"],
                    hoverBackgroundColor: ["#a3d48d","#d59595"]
                }]
            };
            var newTestCoverageChart = new Chart(ctx, {
                type: 'doughnut',
                data: data,
                options: {
                    cutoutPercentage: 64,
                    legend: { position: 'top' },
                    elements: {
                        center: {
                            // This evaluates the max length of the text
                            maxText: '99.99%',
                            text: '{TEST_COVERAGE}%',
                            fontColor: '#d59595',
                            fontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
                            fontStyle: 'normal'
                        }
                    }
                }
            });
        }
        var testCoverageCharts = $(".testCoverageChart");
        for (var i = 0; i < testCoverageCharts.length; i++) {
            createTestCoverageChart(testCoverageCharts[i]);
        }

        $(document).ready(function(){
            $("td > table").hide();
            var expandCollapseButtons = $(".cell-expand-collapse");

            if (expandCollapseButtons.length) {
                expandCollapseButtons.click(function(){
                    var elementToToggle = $(this).siblings("table");
                    elementToToggle.slideToggle("fast");
                    $(this).text($(this).text() == ' Expand' ? ' Collapse' : ' Expand');
                });
            }
        });
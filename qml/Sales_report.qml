import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null
    property var salesData: []
    
    // Connect to database signals
    Connections {
        target: dbManager
        function onOrderDataLoaded(orderData) {
            salesModel.clear();
            for (var i = 0; i < orderData.length; i++) {
                salesModel.append(orderData[i]);
            }
        }
    }
    
    // Load data and update statistics on component completion
    Component.onCompleted: {
        dbManager.getOrdersList();
        updateStatistics();
    }
    
    // Function to update all statistics
    function updateStatistics() {
        totalSalesText.text = "Total Sales\nRs. " + dbManager.getTotalSales().toFixed(2);
        mostUsedPaymentText.text = "Most Used Payment\n" + dbManager.getMUPM();
        
        var bestSeller = dbManager.getBestSellingItemAsMap();
        bestSellerText.text = "Best Seller\n" + bestSeller.name;
        
        highestSaleText.text = "Highest Single Sale\nRs. " + dbManager.getHighestSale().toFixed(2);
        transactionsText.text = "Transactions\n" + dbManager.getTotalTransactions();
        avgSaleText.text = "Avg Sale per Transaction\nRs. " + dbManager.getAverageSale().toFixed(2);
        
        // Get sales data for charts
        salesData = dbManager.getDailySalesData();
        updateCharts();
    }
    
    // Function to update charts
    function updateCharts() {
        // Clear existing data
        pieSeries.clear();
        barSet.values = [];
        barXAxis.categories = [];
        lineSeries.clear();
        
        // Generate payment method data for pie chart
        let cashCount = 0;
        let cardCount = 0;
        let onlineCount = 0;
        
        // Generate daily sales data for bar chart and line chart
        let dailyLabels = [];
        let dailyValues = [];
        
        // Process sales data
        for (let i = 0; i < salesModel.count; i++) {
            let payment = salesModel.get(i).paymentMethod;
            if (payment === "Cash") cashCount++;
            else if (payment === "Card") cardCount++;
            else if (payment === "Online") onlineCount++;
        }
        
        // Process daily sales data
        for (let i = 0; i < salesData.length; i++) {
            dailyLabels.push(salesData[i].date);
            dailyValues.push(salesData[i].amount);
            
            // Add point to line series
            lineSeries.append(i+1, salesData[i].amount);
        }
        
        // Update pie chart
        pieSeries.append("Cash", cashCount > 0 ? cashCount : 10);
        pieSeries.append("Card", cardCount > 0 ? cardCount : 20);
        pieSeries.append("Online", onlineCount > 0 ? onlineCount : 5);
        
        // Update bar chart
        barXAxis.categories = dailyLabels.length > 0 ? dailyLabels : ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        barSet.values = dailyValues.length > 0 ? dailyValues : [100, 200, 150, 250, 300, 400, 350];
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#daeae6"

        Text {
            id: titleText
            y: 40
            text: "Sales Report"
            font.pixelSize: 40
            font.family: "Tahoma"
            font.bold: true
            color: "#333"
            anchors.horizontalCenter: parent.horizontalCenter
            padding: 10
        }

        Row {
            y: 120
            spacing: 10
            width: 850
            anchors.horizontalCenterOffset: -485
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: searchBar
                placeholderText: "Search Order ID or Customer"
                width: 300
                height: 40
            }
            
            ComboBox {
                id: dateFilter
                model: ["All Time", "Today", "This Week", "This Month", "Custom"]
                width: 150
                height: 40
            }
            
            ComboBox {
                id: paymentFilter
                model: ["All", "Cash", "Card", "Online"]
                width: 150
                height: 40
            }
            
            Button {
                width: 120
                height: 40
                text: "Apply Filters"
                background: Rectangle {
                    color: "#4f9c9c"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                }
                onClicked: filterSales()
            }
        }

        // Statistics cards
        Rectangle {
            id: totalSalesCard
            x: 1232
            y: 217
            width: 202
            height: 100
            color: "#7cc660"
            radius: 10
            
            Text {
                id: totalSalesText
                text: "Total Sales\nRs. 0.00"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: transactionsCard
            x: 939
            y: 480
            width: 178
            height: 100
            color: "#FF9800"
            radius: 10
            
            Text {
                id: transactionsText
                text: "Transactions\n0"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: bestSellerCard
            x: 939
            y: 356
            width: 211
            height: 100
            color: "#3c61b1"
            radius: 10
            
            Text {
                id: bestSellerText
                text: "Best Seller\nNone"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: avgSaleCard
            x: 1147
            y: 480
            width: 287
            height: 100
            color: "#673AB7"
            radius: 10
            
            Text {
                id: avgSaleText
                text: "Avg Sale per Transaction\nRs. 0.00"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: mostUsedPaymentCard
            x: 939
            y: 217
            width: 261
            height: 100
            color: "#E91E63"
            radius: 10
            
            Text {
                id: mostUsedPaymentText
                text: "Most Used Payment\nNone"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: highestSaleCard
            x: 1180
            y: 356
            width: 254
            height: 100
            color: "#d464e8"
            radius: 10
            
            Text {
                id: highestSaleText
                text: "Highest Single Sale\nRs. 0.00"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Charts
        ChartView {
            id: pieChartView
            x: 1472
            y: 204
            width: 373
            height: 396
            antialiasing: true
            title: "Payment Methods"
            legend.visible: true
            legend.alignment: Qt.AlignBottom

            PieSeries {
                id: pieSeries
                
                // Placeholder data - will be updated dynamically
                PieSlice { id: cashSlice; label: "Cash"; value: 60 }
                PieSlice { id: cardSlice; label: "Card"; value: 100 }
                PieSlice { id: onlineSlice; label: "Online"; value: 40 }
            }
        }

        ChartView {
            id: barChartView
            x: 939
            y: 617
            width: 450
            height: 358
            antialiasing: true
            title: "Daily Sales"
            legend.visible: true
            legend.alignment: Qt.AlignBottom

            BarSeries {
                id: barSeries
                axisX: BarCategoryAxis { 
                    id: barXAxis
                    categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] 
                }
                
                BarSet { 
                    id: barSet
                    label: "Sales"; 
                    values: [100, 200, 150, 250, 300, 400, 350] 
                }
            }
        }

        ChartView {
            id: lineChartView
            x: 1395
            y: 617
            width: 450
            height: 358
            antialiasing: true
            title: "Sales Trend"
            legend.visible: true
            legend.alignment: Qt.AlignBottom

            LineSeries {
                id: lineSeries
                name: "Sales Trend"
                
                // Placeholder data - will be updated dynamically
                XYPoint { x: 1; y: 100 }
                XYPoint { x: 2; y: 180 }
                XYPoint { x: 3; y: 160 }
                XYPoint { x: 4; y: 220 }
                XYPoint { x: 5; y: 250 }
                XYPoint { x: 6; y: 300 }
                XYPoint { x: 7; y: 400 }
            }
        }

        // Sales table
        Column {
            x: 50
            y: 210
            width: 850
            height: 750

            Rectangle {
                width: parent.width
                height: 50
                color: "#89ced4"
                border.color: "black"
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    
                    Text { text: "Order ID"; Layout.preferredWidth: 100; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                    Text { text: "Medicine Name"; Layout.preferredWidth: 190; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                    Text { text: "Payment Method"; Layout.preferredWidth: 150; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                    Text { text: "Total Amount"; Layout.preferredWidth: 150; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                    Text { text: "Date"; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                }
            }

            ScrollView {
                width: parent.width
                height: 700
                clip: true

                ListView {
                    id: tableView
                    width: parent.width
                    model: salesModel
                    boundsBehavior: Flickable.StopAtBounds

                    delegate: Rectangle {
                        width: tableView.width
                        height: 40
                        color: index % 2 === 0 ? "#f5f5f5" : "white"
                        border.color: "#e0e0e0"
                        border.width: 1
                        
                        RowLayout {
                            anchors.fill: parent
                            spacing: 0
                            
                            Rectangle { 
                                Layout.preferredWidth: 100
                                Layout.fillHeight: true
                                color: "transparent"
                                border.color: "#e0e0e0"
                                
                                Text { 
                                    text: model.orderID
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            Rectangle { 
                                Layout.preferredWidth: 190
                                Layout.fillHeight: true
                                color: "transparent"
                                border.color: "#e0e0e0"
                                
                                Text { 
                                    text: model.medicineName
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                    width: parent.width - 10
                                }
                            }
                            
                            Rectangle { 
                                Layout.preferredWidth: 150
                                Layout.fillHeight: true
                                color: "transparent"
                                border.color: "#e0e0e0"
                                
                                Text { 
                                    text: model.paymentMethod || "Cash"
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            Rectangle { 
                                Layout.preferredWidth: 150
                                Layout.fillHeight: true
                                color: "transparent"
                                border.color: "#e0e0e0"
                                
                                Text { 
                                    text: "Rs. " + model.totalAmount
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            Rectangle { 
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                border.color: "#e0e0e0"
                                
                                Text { 
                                    text: model.date
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }
        }

        Row {
            y: 990
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                width: 170
                height: 40
                text: "Download PDF"
                font.pixelSize: 16
                background: Rectangle {
                    color: "#148273"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    // PDF functionality would be implemented here
                    messageDialog.text = "PDF download function not implemented yet."
                    messageDialog.open()
                }
            }
        }

        Button {
            id: backbutton
            x: 1795
            y: 985
            width: 95
            height: 40
            text: "Back"
            background: Rectangle {
               color: "lightgray"
               radius: 5
            }
            contentItem: Text {
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
            }
            onClicked: stackView.pop()
        }
        
        // Message dialog for notifications
        Dialog {
            id: messageDialog
            title: "Information"
            modal: true
            x: parent.width/2 - width/2
            y: parent.height/2 - height/2
            width: 300
            property string text: ""
            
            Label {
                text: messageDialog.text
                wrapMode: Text.WordWrap
                width: parent.width
            }
            
            standardButtons: Dialog.Ok
        }
    }

    ListModel {
        id: salesModel
        // Will be populated from database
    }
    
    // Function to filter sales data based on search criteria
    function filterSales() {
        // Filter by date, payment method, and search text
        let dateRange = getDateRange();
        let paymentMethod = paymentFilter.currentText !== "All" ? paymentFilter.currentText : "";
        let searchText = searchBar.text.toLowerCase();
        
        // First load all data
        dbManager.getOrdersList();
        
        // Then filter locally
        let filteredData = [];
        for (let i = 0; i < salesModel.count; i++) {
            let item = salesModel.get(i);
            
            // Check if within date range
            let itemDate = new Date(item.date);
            let dateMatch = dateRange.length === 0 || (itemDate >= dateRange[0] && itemDate <= dateRange[1]);
            
            // Check payment method
            let paymentMatch = paymentMethod === "" || item.paymentMethod === paymentMethod;
            
            // Check search text
            let textMatch = searchText === "" || 
                           item.orderID.toLowerCase().includes(searchText) || 
                           item.medicineName.toLowerCase().includes(searchText) ||
                           item.customerName.toLowerCase().includes(searchText);
            
            if (dateMatch && paymentMatch && textMatch) {
                filteredData.push(item);
            }
        }
        
        // Update model with filtered data
        salesModel.clear();
        for (let i = 0; i < filteredData.length; i++) {
            salesModel.append(filteredData[i]);
        }
        
        // Update statistics based on filtered data
        // (Simplified - would need backend support for true filtering)
        updateCharts();
    }
    
    // Helper function to get date range based on filter selection
    function getDateRange() {
        let now = new Date();
        let startDate = new Date();
        let endDate = new Date();
        
        switch (dateFilter.currentText) {
            case "Today":
                startDate.setHours(0, 0, 0, 0);
                return [startDate, endDate];
                
            case "This Week":
                let day = now.getDay(); // 0 = Sunday
                let diff = now.getDate() - day + (day === 0 ? -6 : 1); // Adjust to Monday
                startDate = new Date(now.setDate(diff));
                startDate.setHours(0, 0, 0, 0);
                return [startDate, endDate];
                
            case "This Month":
                startDate = new Date(now.getFullYear(), now.getMonth(), 1);
                return [startDate, endDate];
                
            case "Custom":
                // Would open a date picker dialog in a real implementation
                return [];
                
            default: // All Time
                return [];
        }
    }
}
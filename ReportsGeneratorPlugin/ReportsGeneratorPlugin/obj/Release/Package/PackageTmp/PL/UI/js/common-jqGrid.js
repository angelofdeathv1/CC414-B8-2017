function displayURL(cellvalue, options, rowObject) {
    var url = '<a href="' + cellvalue + '" target="_blank">' + cellvalue + '</a>';
    return url;
}

function displayImage(cellvalue, options, rowObject) {
    var edit = '<img src="../../upload_images/' + cellvalue + '" width="100"/>';
    return edit;
}

function getPercentageFormatter() {
    return { decimalSeparator: ".", thousandsSeparator: ",", decimalPlaces: 2, suffix: "%" };
}

function getCurrencyFormatter() {
    return { decimalSeparator: ".", thousandsSeparator: ",", decimalPlaces: 2, prefix: "$" };
}

function clearGridData(oGrid) {
    $(oGrid).jqGrid('clearGridData');
}

function gridHeaderAdjustment(oGrid) {
    var grid = $(oGrid), headerRow, rowHight, resizeSpanHeight;
    headerRow = grid.closest("div.ui-jqgrid-view")
            .find("table.ui-jqgrid-htable>thead>tr.ui-jqgrid-labels");
    resizeSpanHeight = 'height: ' + headerRow.height() +
                    'px !important; cursor: col-resize;';
    headerRow.find("span.ui-jqgrid-resize").each(function () {
        this.style.cssText = resizeSpanHeight;
    });
    rowHight = headerRow.height();
    headerRow.find("div.ui-jqgrid-sortable").each(function () {
        var ts = $(this);
        ts.css('top', (rowHight - ts.outerHeight()) / 2 + 'px');
    });
}
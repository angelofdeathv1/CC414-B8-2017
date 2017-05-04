function getJQGridDetail() {
    SetVisibleLoading();
    var sReport = $('#hidden_report_uuid').val();
    var arrParameters = getChildrenNestedParameters('#simple-clone');
    var sParameters = arrParameters.join(';');
    ExecReporterURLExtP(AJAX_CONTROLLER, JSON_JQGRID_STRUCT_URI + '&sNewSearch=true&bUserData=0', sReport, sParameters, 50, 1, setCustomFormatJQGrid);
}

function setCustomFormatJQGrid(d) {
    if (d.result != 'FAIL') {
        $.jgrid.gridUnload('#grid0');
        var arrColNames = [];

        $.each(d.colNames, function (i, colName) {
            arrColNames.push(colName);
        });

        d.caption = "";
        d.height = '300';
        d.shrinkToFit = true;

        $("#grid0").jqGrid(d);
        $("#grid0").jqGrid('navGrid', "#pager0", {
            nav: true, edit: false, add: false, del: false, search: false, refresh: false
        }).jqGrid('navButtonAdd', "#pager0", {
            caption: "",
            buttonicon: "fa fa-download",
            onClickButton: function () {
                var sURL = GetGrid0_Export_URL();
                window.open(sURL);
            },
            position: "first",
            title: "XLS Export",
            cursor: "pointer"
        }).jqGrid('navButtonAdd', "#pager0", {
            caption: "",
            buttonicon: "fa fa-refresh",
            onClickButton: function () {
                JqGrid0_Reload();
            },
            position: "second",
            title: "Reload Grid",
            cursor: "pointer"
        }).jqGrid('clearGridData').jqGrid('setGridParam', {
            url: GetGrid0_URL()
        });
    }
    else {
        displayErrorMessage(d);
        SetHiddenLoading();
    }
    SetHiddenLoading();
}

function displayDate(cellvalue, options, rowObject) {
    return stringToDateFormat(cellvalue, 'ddd mmm d, yyyy');
}

function JqGrid0_Actions() {
    $('#grid0').jqGrid('setGridParam', { url: GetGrid0_URL() });
}

function JqGrid0_Reload() {
    $('#grid0').jqGrid('setGridParam', { page: 1, url: GetGrid0_URL_Reload() }).trigger("reloadGrid");
    JqGrid0_Actions();
}

function GetGrid0_URL() {
    var sReport = $('#hidden_report_uuid').val();
    var arrParameters = getChildrenNestedParameters('#simple-clone');
    var sParameters = arrParameters.join(';');
    return getReporterURLP(AJAX_CONTROLLER, JSON_JQDATAGRID_URI, sReport, sParameters, 0, 0) + '&sNewSearch=false';
}

function GetGrid0_URL_Reload() {
    var sReport = $('#hidden_report_uuid').val();
    var arrParameters = getChildrenNestedParameters('#simple-clone');
    var sParameters = arrParameters.join(';');
    return getReporterURLP(AJAX_CONTROLLER, JSON_JQDATAGRID_URI, sReport, sParameters, 0, 0) + '&sNewSearch=true';
}

function GetGrid0_Export_URL() {
    var sReport = $('#hidden_report_uuid').val();
    var arrParameters = getChildrenNestedParameters('#simple-clone');
    var sParameters = arrParameters.join(';');
    return getReporterURLP(AJAX_CONTROLLER, JSON_EXPORT_URI, sReport, sParameters, 0, 1);
}

function gridHeaderAdjustment(oGrid, arrColNames) {
    $.each(arrColNames, function (i, colName) {
        $(oGrid).jqGrid("setLabel", colName, "", { "text-align": "center" });
    });
}
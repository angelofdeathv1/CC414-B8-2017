function getJQGridDetail() {
    sParameters = '';
    ExecReporterURLExtP(AJAX_CONTROLLER,JSON_JQGRID_STRUCT_URI + '&sNewSearch=true&bUserData=0', '7E7FA2EF5EE34315C5D753111E59D65A', sParameters, 50, 1, setCustomFormatJQGrid);
}

function setCustomFormatJQGrid(d) {
    if (d.result != 'FAIL') {

        var arrColNames = [];

        $.each(d.colNames, function (i, colName) {
            arrColNames.push(colName);
        });

        d.caption = "";

        d.colModel[0].align = 'right';
        d.colModel[1].align = 'left';
        d.colModel[2].align = 'left';
        d.colModel[3].align = 'left';
        d.colModel[4].align = 'left';

        d.colModel[0].width = 30;
        d.colModel[1].width = 150;
        d.colModel[2].width = 60;
        d.colModel[3].width = 200;

        d.colNames[0] = 'ID';
        d.colNames[1] = 'UUID';
        d.colNames[2] = 'APPLICATION';
        d.colNames[3] = 'PROCEDURE';
        d.colNames[4] = 'CONNECTION';
       
        d.height = '500px';
        d.shrinkToFit = true;

        var oButtons = { align: 'center', formatter: displayButtons, sortable: false, width: 40 };
        d.colNames.push('');
        d.colModel.push(oButtons);

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
        });
        $("#grid0").jqGrid('clearGridData');
        gridHeaderAdjustment('#grid0', arrColNames);
        JqGrid0_Actions();
    }
    else {
        displayErrorAlert(d);
        SetHiddenLoading();
    }
    SetHiddenLoading();
}

function displayButtons(cellvalue, options, rowObject) {
    var remove = "<button type='button' id='btn_search' class='btn btn-info' onclick='JqGrid_QuoteDetail(" + options.rowId + ")'><i class='fa fa-pencil'></i></button>"
    return remove;
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

function JqGrid_QuoteDetail(rowId) {
    var sReportUUID = $("#grid0").jqGrid('getCell', rowId, 'UUID_RPT');
    $.colorbox({
        iframe: true,
        href: '/PL/admin/forms/reporter-form.aspx?sReportUUID=' + sReportUUID,
        width: "50%",
        height: "90%",
        onClosed: function () {
            $('#grid0').jqGrid('setGridParam', {url: GetGrid0_URL_Reload() }).trigger("reloadGrid");
            JqGrid0_Actions();
        }
    });
}

function createConfiguration() {
    $.colorbox({
        iframe: true,
        href: '/PL/admin/forms/reporter-form.aspx?sReportUUID=',
        width: "50%",
        height: "90%",
        onClosed: function () {
            $('#grid0').jqGrid('setGridParam', { page: 1, url: GetGrid0_URL_Reload() }).trigger("reloadGrid");
            JqGrid0_Actions();
        }
    });
}

function GetGrid0_URL() {
    var sParameters = '';
    return getReporterURLP(AJAX_CONTROLLER,JSON_JQDATAGRID_URI, '7E7FA2EF5EE34315C5D753111E59D65A', sParameters, 0, 0) + '&sNewSearch=false';
}

function GetGrid0_URL_Reload() {
    var sParameters = '';
    return getReporterURLP(AJAX_CONTROLLER,JSON_JQDATAGRID_URI, '7E7FA2EF5EE34315C5D753111E59D65A', sParameters, 0, 0) + '&sNewSearch=true';
}

function GetGrid0_Export_URL() {
    var sParameters = '';
    return getReporterURLP(AJAX_CONTROLLER, JSON_EXPORT_URI, '7E7FA2EF5EE34315C5D753111E59D65A', sParameters, 0, 1);
}

function gridHeaderAdjustment(oGrid, arrColNames) {
    $.each(arrColNames, function (i, colName) {
        $(oGrid).jqGrid("setLabel", colName, "", { "text-align": "center" });
    });
}
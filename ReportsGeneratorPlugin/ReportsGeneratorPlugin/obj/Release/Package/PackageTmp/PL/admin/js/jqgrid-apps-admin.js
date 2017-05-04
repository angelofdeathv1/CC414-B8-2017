function getJQGridDetail() {
    sParameters = '';
    ExecReporterURLExt(JSON_JQGRID_STRUCT_JSONP_URI + '&sNewSearch=true&bUserData=0', 134, sParameters, 50, 1, setCustomFormatJQGrid);
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

        d.colModel[0].width = 40;
        d.colModel[1].width = 300;
       

        d.colNames[0] = 'ID';
        d.colNames[1] = 'APPLICATION';

        d.height = '500px';
        d.shrinkToFit = true;

        var oButtons = { align: 'center', formatter: displayButtons, sortable: false, width: 40 };
        d.colNames.push('');
        d.colModel.push(oButtons);

        $("#grid0").jqGrid(d);
        $("#grid0").jqGrid('navGrid', "#pager0", { nav: true, edit: false, add: false, del: false, search: false }).jqGrid('navButtonAdd', "#pager0", {
            caption: "",
            buttonicon: "fa fa-download",
            onClickButton: function () {
                var sURL = GetGrid0_Export_URL();
                window.open(sURL);
            },
            position: "first",
            title: "XLS Export",
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

function JqGrid_QuoteDetail(rowId) {
    var nItemID = $("#grid0").jqGrid('getCell', rowId, 'ID_ITEM');
    $.colorbox({
        iframe: true,
        href: '/modules/quotes/item-detail.aspx?nItemID=' + nItemID,
        width: "70%",
        height: "60%"
    });
}

function JqGrid_Search() {
    $('#grid0').jqGrid('setGridParam', { url: GetHeaderSearch() }).trigger('reloadGrid');
}

function GetGrid0_URL() {
    var sParameters = '';
    return getReporterURL(JSON_JQDATAGRID_URI, 134, sParameters, 0, 0) + '&sNewSearch=false';
}

function GetGrid0_Export_URL() {
    var sParameters = '';
    return getReporterURL(JSON_EXPORT_URI, 134, sParameters, 0, 1);
}

function gridHeaderAdjustment(oGrid, arrColNames) {
    $.each(arrColNames, function (i, colName) {
        $(oGrid).jqGrid("setLabel", colName, "", { "text-align": "center" });
    });
}
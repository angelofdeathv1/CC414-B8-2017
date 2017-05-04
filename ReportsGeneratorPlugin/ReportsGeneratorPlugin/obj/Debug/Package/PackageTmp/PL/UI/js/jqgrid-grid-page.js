function getJQGrid() {
    ShowLoading();
    var sAction = 'sAction=getJQGridStructure';
    var oParameters = sAction + '&nReportID=' + $('#hfReportID').val() + '&sReportUUID=' + $('#hfReportUUID').val() + '&sParameters=' + $('#hfParameters').val() + '&sNewSearch=' + $('#hfNewSearch').val() + "&nHeight=" + $('#hfHeight').val();
    var nRows = $('#hfRows').val();
    if (nRows != '') {
        oParameters += "&rows=" + nRows;
    }
    $.ajax({
        type: 'POST',
        url: 'Controller.aspx',
        data: oParameters,
        dataType: 'json',
        success: setJQGrid
    });
}

function setJQGrid(o) {
    if (o.result != 'FAIL') {
        var arrColNames = [];
        var myGrid = $('#grid0');

        $.each(o.colNames, function (i, colName) {
            arrColNames.push(colName);
        });

        o.caption = '';
        o.rownumbers = true;

        myGrid.jqGrid(o).jqGrid('navGrid', '#pager0', {
            nav: true, edit: false, add: false, del: false, search: false
        }).jqGrid('navGrid', "#pager0").jqGrid('navButtonAdd', '#pager0', {
            caption: '',
            buttonicon: 'fa fa-download',
            onClickButton: excelExport,
            position: 'first',
            title: 'XLS export',
            cursor: 'pointer'
        }).jqGrid('setGridParam', {
            url: GetGrid0_URL()
        });
        gridHeaderAdjustment('#grid0', arrColNames);
    } else {
        viewError(o.error);
    }
    HideLoading();
}

function JqGrid_Error(response) {
    $('#grid0').clearGridData();
}

function JqGrid0_Actions() {
    jQuery('#grid0').jqGrid('setGridParam', { url: GetGrid0_URL() });
}

function GetGrid0_URL() {
    var sRows = '';
    var nRows = $('#hfRows').val();
    if (nRows != '') {
        sRows = "&rows=" + nRows;
    }
    return "Controller.aspx?sAction=getDataGrid&nReportID=" + $('#hfReportID').val() + "&sReportUUID=" + $('#hfReportUUID').val() + "&sParameters=" + $('#hfParameters').val() + sRows;
}

function Search() {
    var grid = jQuery("#grid0");
    var theurl = GetGrid0_URL() + "&sNewSearch=true";
    grid.jqGrid('setGridParam', { url: theurl, page: 1 }).trigger('reloadGrid');
}

function viewError(msg) {
    if (msg == '') {
        $("#divError").html('').hide();
    }
    else {
        var template = '<div class="panel-heading"><h3 class="panel-title">Error</h3></div><div class="panel-body">' + msg + '</div>';
        $("#divError").html(template).show();
    }
}

function excelExport() {
    var sParameters = "&nReportID=" + $('#hfReportID').val() + '&sReportUUID=' + $('#hfReportUUID').val() + "&sParameters=" + $('#hfParameters').val() + "&sNewSearch=" + $('#hfNewSearch').val() + "&nHeight=" + $('#hfHeight').val();
    iExcel.location.replace("Controller.aspx?sAction=getRawDataExport" + sParameters + "&ms=" + new Date().getTime());
}

function ShowLoading() {
    $.blockUI({
        css: {
            border: 'none',
            padding: '15px',
            backgroundColor: '#000',
            '-webkit-border-radius': '10px',
            '-moz-border-radius': '10px',
            opacity: .5,
            color: '#fff'
        }
    });
}

function HideLoading() {
    $.unblockUI();
}

function gridHeaderAdjustment(oGrid, arrColNames) {
    $.each(arrColNames, function (i, colName) {
        $(oGrid).jqGrid("setLabel", colName, "", { "text-align": "center" });
    });
}
function getConfiguration() {
    SetVisibleLoading();
    var sParameters = $('#hidden_report_uuid').val();
    if (sParameters !== '') {
        $("#txt_uuid").prop("readonly", true);
        ExecReporterExtP(AJAX_CONTROLLER, AJAX_PARAMETERS, '7E7FA2EF5EE34315C5D753111E59D65A', sParameters, setConfiguration);
    } else {
        SetHiddenLoading();
    }
}

function setConfiguration(o, anotherObject) {
    if (o.result != 'FAIL') {
        var oQuote = o.data[0];
        $('#txt_uuid').val(oQuote.UUID_RPT);
        $('#combo_application').val(oQuote.ID_RPT_APPLICATION);
        $('#combo_connection').val(oQuote.ID_CONNECTION);
        $('#txt_source').val(oQuote.RPT_DATASOURCE_QRY);
    } else {
        displayErrorMessage(o);
    }
    SetHiddenLoading();
    $(".addParameter").bind("click", buttonAddVendorItem);
    $(".deleteParameter").bind("click", buttonDeleteVendorItem);
}

function getReport() {
    viewError('');
    setGeneratedURL();
    getJQGridDetail();
}

function buttonAddVendorItem() {
    var nParentID = getParentControlIndex(this.id, '_');
    $('#simple-clone').triggerHandler('clone.cloneya', [$('#clonable_' + nParentID)]);
}

function buttonDeleteVendorItem() {
    var nParentID = getParentControlIndex(this.id, '_');
    $('#simple-clone').triggerHandler('delete.cloneya', [$('#clonable_' + nParentID)]);
}

function getControlIndex(oControlID, sSeparator) {
    var sIndex = oControlID.substring(oControlID.indexOf(sSeparator) + 1, oControlID.length);
    var nIndex = '';
    if (sIndex != '') {
        nIndex = parseInt(sIndex) || 0;
    }
    return nIndex;
}

function getParentControlIndex(oControlID, sSeparator) {
    var oParentControlID = $('#' + oControlID).parent().parent().attr('id');
    var sIndex = oParentControlID.substring(oParentControlID.indexOf(sSeparator) + 1, oParentControlID.length);
    var nIndex = '';
    if (sIndex != '') {
        nIndex = parseInt(sIndex) || 0;
    }
    return nIndex;
}

function getControlIndex(oControlID, sSeparator) {
    var sIndex = oControlID.substring(oControlID.indexOf(sSeparator) + 1, oControlID.length);
    var nIndex = '';
    if (sIndex != '') {
        nIndex = parseInt(sIndex) || 0;
    }
    return nIndex;
}

function getChildrenNested(oDivID) {
    var arrChildrenID = $(oDivID).children(".toclone").map(function () {
        var sAttribute = $(this).attr('id');
        var attr = sAttribute.substring(sAttribute.indexOf('_') + 1, sAttribute.length);
        return attr
    });
    return arrChildrenID
}

function getChildrenNestedParameters(oDivID) {
    var arrChildrenID = $(oDivID).children(".toclone").map(function () {
        var sAttribute = $(this).attr('id');
        var attr = sAttribute.substring(sAttribute.indexOf('_') + 1, sAttribute.length);
        var sVendorID = $('#txt_parameter' + attr).val();
        return sVendorID
    });
    return arrChildrenID.toArray()
}

function setGeneratedURL() {
    var sReportID = $('#hidden_report_uuid').val();
    var arrParameters = getChildrenNestedParameters('#simple-clone');
    var sParameters = arrParameters.join(';');

    var COMMON_PARAMS = 'sReportUUID={ID}&sParameters={PARAMS}';
    var sMainParameters = COMMON_PARAMS.replace(/{ID}/ig, sReportID);
    sMainParameters = sMainParameters.replace(/{PARAMS}/ig, sParameters);

    var sJsonURL = $('#hidden_request_url').val() + '/PL/Controller.aspx?sAction=getRawData&' + sMainParameters;
    var sGridURL = $('#hidden_request_url').val() + '/PL/GridPage.aspx?' + sMainParameters + '&sNewSearch=true';
    var sExportURL = $('#hidden_request_url').val() + '/PL/Controller.aspx?sAction=getRawDataExport&' + sMainParameters;

    $('#link_json').html(sJsonURL);
    $('#link_json').prop("href", sJsonURL)
    $('#link_grid').html(sGridURL);
    $('#link_grid').prop("href", sGridURL)
    $('#link_export').html(sExportURL);
    $('#link_export').prop("href", sExportURL)
}
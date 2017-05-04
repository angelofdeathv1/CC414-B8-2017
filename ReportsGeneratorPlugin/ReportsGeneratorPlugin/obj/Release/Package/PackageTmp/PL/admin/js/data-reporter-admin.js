function getComboApplications() {
    SetVisibleLoading();
    var sParameters = "";
    sParameters += '&sidx=1&sord=asc';
    ExecReporterExtP(AJAX_CONTROLLER, AJAX_PARAMETERS, '973D47BC88C048C8E983E57D2A3EFB12', sParameters, setComboApplications);
}

function setComboApplications(o, anotherObject) {
    if (o.result != 'FAIL') {
        var combo = $('#combo_application');
        $.each(o.data, function (i, item) {
            combo.append($('<option>', {
                value: item.ID_RPT_APPLICATION,
                text: item.APPLICATION_NAME
            }));
        });
    } else {
        displayErrorMessage(o);
    }
    getComboConnections();
}

function getComboConnections() {
    var sParameters = "";
    sParameters += '&sidx=1&sord=asc';
    ExecReporterExtP(AJAX_CONTROLLER, AJAX_PARAMETERS, 'A9ADC9BFA7DB43DFC8EE54BCFB89D0BD', sParameters, setComboConnections);
}

function setComboConnections(o, anotherObject) {
    if (o.result != 'FAIL') {
        var combo = $('#combo_connection');
        $.each(o.data, function (i, item) {
            combo.append($('<option>', {
                value: item.ID_CONNECTION,
                text: item.NAME
            }));
        });
    } else {
        displayErrorMessage(o);
    }
    getConfiguration();
}

function getConfiguration() {
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
}

function saveConfiguration() {
    var sParameters = $('#txt_uuid').val() + ';' + $('#txt_source').val() + ';' + $('#combo_connection').val() + ';' + $('#combo_application').val();
    ExecReporterExtP(AJAX_CONTROLLER, AJAX_PARAMETERS, 'B90FAC55DF194481A6B1D5AA690F5A45', sParameters, verifyIfConfigurationSaved);
}

function verifyIfConfigurationSaved(o) {
    if (o.result == 'OK' && o.data[0].RESULT != '-1') {
        addSuccess('Configuration saved:' + o.data[0].UUID_RPT);
        $("#txt_uuid").val(o.data[0].UUID_RPT);
        $("#txt_uuid").prop("readonly", true);
    } else {
        displayErrorMessage(o);
    }
}
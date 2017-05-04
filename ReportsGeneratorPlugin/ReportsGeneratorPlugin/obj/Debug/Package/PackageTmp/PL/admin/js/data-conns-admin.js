function getConnection() {
    SetVisibleLoading();
    var sParameters = $('#hidden_connection_id').val();
    if (sParameters !== '') {
        ExecReporterExtP(AJAX_CONTROLLER, AJAX_PARAMETERS, 'A9ADC9BFA7DB43DFC8EE54BCFB89D0BD', sParameters, setConnection);
    } else {
        SetHiddenLoading();
    }
}

function setConnection(o, anotherObject) {
    if (o.result != 'FAIL') {
        var oQuote = o.data[0];
        $('#txt_id').val(oQuote.ID_CONNECTION);
        $('#txt_name').val(oQuote.NAME);
    } else {
        displayErrorMessage(o);
    }
    SetHiddenLoading();
}

function saveConfiguration() {
    if (validaRequeridos('rq', '1') > 0) {
        return;
    }
    SetVisibleLoading();
    var sConnection = $('#txt_connection').val();
    sConnection = sConnection.replace(/ /g, "");
    var sParameters = $('#txt_id').val() + ';' + $('#txt_name').val() + ';' + sConnection + ';' + $('#txt_user').val() + ';' + $('#txt_password').val();
    ExecReporterExtP(AJAX_CONTROLLER, AJAX_PARAMETERS, 'A6063AB08305488B9105202E90196959', sParameters, verifyIfConfigurationSaved);
}

function verifyIfConfigurationSaved(o) {
    if (o.result == 'OK' && o.data[0].RESULT != '-1') {
        addSuccess('Connection saved:' + o.data[0].ID_CONNECTION);
        $("#txt_id").val(o.data[0].ID_CONNECTION);
    } else {
        displayErrorMessage(o);
    }
    SetHiddenLoading();
}
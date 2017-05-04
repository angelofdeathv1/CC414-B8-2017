function WindowOpen(w, h, jsp, iframe) {
    var LeftPosition = (screen.width) ? (screen.width - w) / 2 : 0;
    var TopPosition = (screen.height) ? (screen.height - h) / 2 : 0;
    settings = 'height=' + h + ',width=' + w + ',top=' + TopPosition + ',left=' + LeftPosition + ',scrollbars=yes,dependent=0,resizable=yes,status=0,dialog=YES,modal=YES';
    newWindow = window.open(jsp, iframe, settings);
    newWindow.focus();
}

var inputmsg = null;
function viewError(msg) {
    if (inputmsg != null && typeof inputmsg != 'undefined') {
        //document.getElementById(inputmsg).innerHTML = msg;//template;//msg;
        if (msg == "") {
            $("#divError").html('').hide();
        }
        else {
            var template = '<div class="panel panel-danger "><div class="panel-heading"><h4 class="panel-title">Error</h4></div><div class="panel-body">' + msg + '</div></div>';
            $("#divError").html(template).show();
        }
        return;
    }
    else {
        if (msg != '')
            alert(msg);
    }
}

function SetVisibleLoading() {
    try {
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
    } catch (ee) {
        viewError("SetVisibleLoading");
    }
}

function SetHiddenLoading() {
    try {
        $.unblockUI();
    } catch (ee) {
        viewError("SetHiddenLoading");
    }
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

function validaRequeridos(attribute, value) {
    var required = 0;
    $("input[type='text'], textarea, input[type='hidden'], select, input[type='password']").each(
        function (index) {
            var input = $(this);
            if (input.attr(attribute) === value) {
                input.css('background-color', '');
                if (input.val() == '') {
                    input.css('background-color', '#FFCCCC');
                    required++;
                }
            }
        }
    );
    return required;
}

function GetInputValues() {
    var parameters = "";
    $("input[type='text'], textarea, input[type='hidden'], select, input[type='password']").each(
            function (index) {

                var input = $(this);
                if (input.attr('id') != '__VIEWSTATE') {
                    var valor = input.val();

                    parameters += "&" + input.attr('id') + "=" + (valor == '' ? '' : escapeTxt(valor)); // escapeTxt(getDefault(input.val()));
                }

            }
        );
    return parameters;
}

var htmlTemplate = null;
function LoadContent(url, callbackfunc, moredata) {

    if (typeof htmlTemplate == 'undefined' || htmlTemplate == null) {
        $.ajax({
            mimeType: 'text/html; charset=utf-8', // ! Need set mimeType only when run from local file
            url: url,
            type: 'GET',
            mdata: moredata,
            fcallback: callbackfunc,
            success: function (data) {
                if (typeof this.fcallback == "function") this.fcallback(data, this.mdata);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            },
            dataType: "html",
            async: false
        });
    }
    else {
        if (typeof callbackfunc == "function")
            callbackfunc(htmlTemplate);
    }
}

function closeLighbox() {
    setTimeout($.colorbox.close, 100);
}

function addCommas(nStr) {
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}

//.keydown
function onlyNumbers(e) {
    // Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13/*, 110, 190*/]) !== -1 ||
        // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) ||
        // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
        // let it happen, don't do anything
        return;
    }
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
}

function escapeTxt(os) {
    if (typeof os !== 'string') { return os; } //FCFix
    var ns = '';
    var t;
    var chr = '';
    var cc = '';
    var tn = '';
    for (i = 0; i < 256; i++) {
        tn = i.toString(16);
        if (tn.length < 2) tn = "0" + tn;
        cc += tn;
        chr += unescape('%' + tn);
    }
    cc = cc.toUpperCase();
    os.replace(String.fromCharCode(13) + '', "%13");
    String.prototype.replace(String.fromCharCode(13) + '', "%13");
    for (q = 0; q < os.length; q++) {
        t = os.substr(q, 1);
        for (i = 0; i < chr.length; i++) {
            if (t == chr.substr(i, 1)) {
                t = t.replace(chr.substr(i, 1), "%" + cc.substr(i * 2, 2));
                i = chr.length;
            }
        }
        ns += t;
    }
    return ns;

}

function dateTimeReviver(value) {
    var a;
    if (typeof value === 'string') {
        a = /\/Date\((\d*)\)\//.exec(value);
        if (a) {
            return new Date(+a[1]);
        }
    }
    return value;
}

function DefaultFormat(date, includetime) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    var vmonth = date.getMonth() + 1;
    vmonth = vmonth < 10 ? "0" + vmonth : vmonth;
    var vday = date.getDate();
    vday = vday < 10 ? "0" + vday : vday;
    return vmonth + "-" + vday + "-" + date.getFullYear() + (includetime === true ? " " + strTime : "");
}

function addAlert(message) {
    var template = '<div class="panel panel-danger alert"><div class="panel-heading"><h4 class="panel-title">Error</h4></div><div class="panel-body"><button type="button" class="close" data-dismiss="alert">&times;</button>' + message + '</div></div>';
    $('#alerts').append(template);
}

function addSuccess(message) {
    var template = '<div class="panel panel-success alert "><div class="panel-heading"><h4 class="panel-title">Success!</h4></div><div class="panel-body"><button type="button" class="close" data-dismiss="alert">&times;</button>' + message + '</div></div>';
    $('#alerts').append(template);
    /* $("#alerts").fadeTo(2000, 500).slideUp(500, function () {
         $("#alerts").alert('close');
     });*/
}

function displayErrorAlert(o, section) {
    try {
        addAlert('Error on: ' + o.data[0].SOURCE + '. ' + o.data[0].MESSAGE);
    } catch (err) {
        addAlert('Error on: ' + o.error + '.');
    } finally {
        SetHiddenLoading();
        scrollToSection(section);
    }
}

function displayErrorMessage(o, section) {
    try {
        viewError('Error on: ' + o.data[0].SOURCE + '. ' + o.data[0].MESSAGE);
    } catch (err) {
        viewError('Error on: ' + o.error + '.');
    } finally {
        SetHiddenLoading();
        scrollToSection(section);
    }
}

function scrollToSection(section) {
    if (section !== undefined) {
        $(document).scrollTop($(section).offset().top);
    }
}

function isDomainUserRegistered() {
    SetVisibleLoading();
    ExecReporterURLExt(JSON_JQGRID_STRUCT_JSONP_URI + '&sNewSearch=true&bUserData=0', 93, $('#hidden_domain_user').val(), 150, 1, getJQGridDetail);
}

function post(path, parameters) {
    var form = $('<form></form>');
    form.attr("method", "post");
    form.attr("action", path);
    $.each(parameters, function (key, value) {
        var field = $('<input></input>');

        field.attr("type", "hidden");
        field.attr("name", key);
        field.attr("value", value);

        form.append(field);
    });

    $(document.body).append(form);
    form.submit();
}

function jsonToDateFormat(sJSONDate, sFormat) {
    if (sJSONDate === undefined) {
        return '';
    }

    var dCreationDate = new Date(parseInt(sJSONDate.substr(6)));
    var sDate = Date.Format(dCreationDate, sFormat);
    return sDate;
}

function stringToDateFormat(sJSONDate, sFormat) {
    if (sJSONDate === undefined) {
        return '';
    }

    var dCreationDate = new Date(sJSONDate);
    var sDate = Date.Format(dCreationDate, sFormat);
    return sDate;
}
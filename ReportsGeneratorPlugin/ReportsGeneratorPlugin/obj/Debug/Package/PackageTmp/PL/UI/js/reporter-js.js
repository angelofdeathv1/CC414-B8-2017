function ExecReporterExt(nReportID, sReportParams, fDisplayFunc, oAdditionalObject) {
    var urlReporter = REPORTER.replace(/{ID}/ig, nReportID);
    urlReporter = urlReporter.replace(/{PARAMS}/ig, sReportParams);
    urlReporter += "&ms=" + new Date().getTime();
    viewError("");
    crossDomainAjaxExt(urlReporter, fDisplayFunc, oAdditionalObject);
}

function ExecReporterExtP(sReportURL, sReportURLParams, nReportID, sReportParams, fDisplayFunc, oAdditionalObject) {
    var urlReporter = sReportURLParams.replace(/{ID}/ig, nReportID);
    urlReporter = urlReporter.replace(/{PARAMS}/ig, sReportParams);
    sReportURL += "?ms=" + new Date().getTime();
    ajaxRequestCORSP(sReportURL, urlReporter, fDisplayFunc, oAdditionalObject);
}

function ExecReporterURLExt(sReportURL, nReportID, sReportParams, nHeight, bUserData, fDisplayFunc, oAdditionalObject) {
    var sURLReporter = getReporterURL(sReportURL, nReportID, sReportParams, nHeight, bUserData);
    viewError("");
    crossDomainAjaxExt(sURLReporter, fDisplayFunc, oAdditionalObject);
}

function getReporterURL(sReportURL, nReportID, sReportParams, nHeight, bUserData) {
    var sURLReporter = sReportURL.replace(/{ID}/ig, nReportID);
    sURLReporter = sURLReporter.replace(/{PARAMS}/ig, sReportParams);
    sURLReporter = sURLReporter.replace(/{H}/ig, nHeight);
    sURLReporter = sURLReporter.replace(/{UD}/ig, bUserData);
    sURLReporter += "&ms=" + new Date().getTime();
    return sURLReporter;
}

function getReporterURLP(sReportURL, sReportURLParams, nReportID, sReportParams, nHeight, bUserData) {
    var sURLReporter = sReportURLParams.replace(/{ID}/ig, nReportID);
    sURLReporter = sURLReporter.replace(/{PARAMS}/ig, sReportParams);
    sURLReporter = sURLReporter.replace(/{H}/ig, nHeight);
    sURLReporter = sURLReporter.replace(/{UD}/ig, bUserData);
    sReportURL += "?ms=" + new Date().getTime();
    return sReportURL+'&'+sURLReporter;
}

function ExecReporterURLExtP(sReportURL, sReportURLParams, nReportID, sReportParams, nHeight, bUserData, fDisplayFunc, oAdditionalObject) {
    viewError("");
    var sURLReporter = sReportURLParams.replace(/{ID}/ig, nReportID);
    sURLReporter = sURLReporter.replace(/{PARAMS}/ig, sReportParams);
    sURLReporter = sURLReporter.replace(/{H}/ig, nHeight);
    sURLReporter = sURLReporter.replace(/{UD}/ig, bUserData);
    sReportURL += "?ms=" + new Date().getTime();
    ajaxRequestCORSP(sReportURL, sURLReporter, fDisplayFunc, oAdditionalObject);
}

function ajaxRequestJSONP(sURL, fSuccessCallback, oAdditionalObject) {
    $.ajax({
        url: sURL, //+"&callback=?",
        dataType: 'jsonp',
        type: 'GET',
        jsonp: 'callback',
        otherObj: oAdditionalObject,
        thecallback: fSuccessCallback,
        success: function (data) {
            var oJSON = $.parseJSON(data);
            this.thecallback(oJSON, this.otherObj);
        }
    });
}

function ajaxRequestCORS(sURL, fSuccessCallback, oAdditionalObject) {
    $.ajax({
        url: sURL,
        cache: false,
        type: "POST",
        otherObj: oAdditionalObject,
        thecallback: fSuccessCallback,
        success: function (data, success) {
            var oJSON = $.parseJSON(data);
            this.thecallback(oJSON, this.otherObj);
        }
    });
}

function ajaxRequestCORSP(sURL, oParameters, fSuccessCallback, oAdditionalObject) {
    $.ajax({
        url: sURL,
        dataType: 'json',
        cache: false,
        type: "POST",
        data: oParameters,
        otherObj: oAdditionalObject,
        thecallback: fSuccessCallback,
        success: function (data, success) {
            this.thecallback(data, this.otherObj);
        }
    });
}

function crossDomainAjaxExt(sUrl, fSuccessCallback, oAdditionalObject) {
    //JSONP IE7,8,9; CORS everything else.
    if (navigator.userAgent.indexOf('MSIE') != -1 &&
             parseInt(navigator.userAgent.match(/MSIE ([\d.]+)/)[1], 10) < 10) {
        ajaxRequestJSONP(sUrl, fSuccessCallback, oAdditionalObject);
    }
    else {
        ajaxRequestCORS(sUrl, fSuccessCallback, oAdditionalObject);
    }
}
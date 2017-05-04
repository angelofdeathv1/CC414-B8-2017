<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GridPage.aspx.cs" Inherits="ReportsGeneratorPlugin.PL.GridPage" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <title>Reports</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!--[if lt IE 9]>
        <script type="text/javascript" src="UI/js/html5shiv.js"></script>
        <script type="text/javascript" src="UI/js/respond.min.js"></script>
     <![endif]-->

    <link href="UI/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="UI/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="UI/js/JQGrid-bootstrap/css/ui.jqgrid-bootstrap.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <input type="hidden" id="hfReportID" value="<%=hfReportID %>" />
            <input type="hidden" id="hfReportUUID" value="<%=hfReportUUID %>" />
            <input type="hidden" id="hfParameters" value="<%=hfParameters %>" />
            <input type="hidden" id="hfNewSearch" value="<%=hfNewSearch %>" />
            <input type="hidden" id="hfHeight" value="<%=hfHeight %>" />
            <input type="hidden" id="hfRows" value="<%=hfRows %>" />

            <div class="col-md-12">
                <div id="divError" style="display: none;" class="panel panel-danger">
                    <div class="panel-body">
                        Panel content
                    </div>
                    <div class="panel-footer">
                        Panel footer
                    </div>
                </div>
                <div id="divDetails">
                    <table id="grid0" class="table table-hover table-condensed">
                    </table>
                    <div id="pager0">
                    </div>
                </div>
            </div>
        </div>
        <iframe id="iExcel" frameborder="0" marginheight="0" marginwidth="0" scrolling="no"
            name="iExcel" width="0" height="0"></iframe>
    </div>

    <script src="UI/js/jquery.min.js" type="text/javascript"></script>
    <script src="UI/js/jquery-migrate.min.js"></script>
    <script src="UI/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="UI/js/jquery.blockui.js" type="text/javascript"></script>

    <script src="UI/js/JQGrid-bootstrap/js/i18n/grid.locale-en.js" type="text/javascript"></script>
    <script src="UI/js/JQGrid-bootstrap/js/jquery.jqGrid.min.js" type="text/javascript"></script>
    <script src="UI/js/jqgrid-grid-page.js" type="text/javascript"></script>

    <script type="text/javascript">
        $.jgrid.defaults.responsive = true;
        $.jgrid.defaults.styleUI = 'Bootstrap';
        $(document).ready(function () {
            getJQGrid();
        });
    </script>
</body>
</html>

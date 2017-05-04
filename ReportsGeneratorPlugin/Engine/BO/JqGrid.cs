using System;
using System.Collections.Generic;

namespace Engine.BO
{
    [Serializable]
    public class JqGridData
    {
        public const int ROWS_PER_PAGE = 10;

        public string page { get; set; }
        public string total { get; set; }
        public string records { get; set; }
        public Dictionary<string, string> userdata { get; set; }
        public List<JqGridDetail> rows { get; set; }

        public static void calcula_pagina(int iTotalRows, int iPage, int iRowsPerPage, out int init_index, out int final_index, out int ipagestotal)
        {
            int rowperpage = iRowsPerPage;
            int irowstotal = iTotalRows;

            ipagestotal = irowstotal / rowperpage;
            ipagestotal += (irowstotal % rowperpage > 0 ? 1 : 0);

            init_index = iPage * rowperpage - rowperpage;
            final_index = (init_index + rowperpage > irowstotal ? irowstotal : init_index + rowperpage);
        }
    }

    [Serializable]
    public class JqGridStructure
    {
        /*public int width { get; set; }*/
        public int rowNum { get; set; }
        public int height { get; set; }
        public string caption { get; set; }
        public string pager { get; set; }
        public string datatype { get; set; }
        public string[] colNames { get; set; }
        public string url { get; set; }
        public string mtype { get; set; }
        public bool altRows { get; set; }
        public bool shrinkToFit { get; set; }
        public bool hidegrid { get; set; }
        public bool viewrecords { get; set; }
        public bool autowidth { get; set; }
        /*public object gridComplete { get; set; }
        public object loadError { get; set; }*/

        public List<JqGridModel> colModel { get; set; }

        public JqGridStructure()
        {
            //rowNum = JqGridData.ROWS_PER_PAGE;
            datatype = "json";
            pager = "#pager0";
            mtype = "POST";
            viewrecords = true;
            hidegrid = false;
            shrinkToFit = false;
            caption = "";
            altRows = true;
            height = 300;
            autowidth = true;
            /*gridComplete = new JRaw("function(e) {alert(e)}");
            loadError=new JRaw("JqGrid_Error");*/
        }
    }

    [Serializable]
    public class JqGridDetail
    {
        public string id { get; set; }
        public string[] cell { get; set; }
    }

    [Serializable]
    public class JqGridDef
    {
        public string[] colNames { get; set; }
        public JqGridModel[] colModel { get; set; }
    }

    public class JqGridModel
    {
        public string name { get; set; }
        public int width { get; set; }
        public string align { get; set; }
        public bool sortable { get; set; }
        public bool hidden { get; set; }
        public string index { get; set; }

        public JqGridModel()
        {
            align = "right";
            hidden = false;
        }
    }

}

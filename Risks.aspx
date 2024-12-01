<%-- _lcid="1049" _version="16.0.10337" _dal="1" --%>
<%-- _LocalBinding --%>
<%@ Page language="C#" MasterPageFile="~masterurl/default.master"    Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage,Microsoft.SharePoint,Version=16.0.0.0,Culture=neutral,PublicKeyToken=71e9bce111e9429c" meta:progid="SharePoint.WebPartPage.Document"  %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Import Namespace="Microsoft.SharePoint" %> <%@ Assembly Name="Microsoft.Web.CommandUI, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ContentPlaceHolderId="PlaceHolderPageTitle" runat="server">

	<SharePoint:ListItemProperty Property="BaseName" maxlength="40" runat="server"/>

</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderAdditionalPageHead" runat="server">
	<meta name="GENERATOR" content="Microsoft SharePoint" />
	<meta name="ProgId" content="SharePoint.WebPartPage.Document" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="CollaborationServer" content="SharePoint Team Web Site" />
	<SharePoint:ScriptBlock runat="server">
	var navBarHelpOverrideKey = &quot;WSSEndUser&quot;; </SharePoint:ScriptBlock>
<SharePoint:StyleBlock runat="server">
body #s4-leftpanel {
	display:none;
}
.s4-ca {
	margin-left:0px;
}
a[Risks] {
    display : none;
    visibility: hidden;
}

#DeltaPlaceHolderPageTitleInTitleArea{
    display : none;
    visibility: hidden;


}</SharePoint:StyleBlock>
	<link rel="stylesheet" type="text/css" href="https://project.cti.ru/PWA/htmcss/css/bootstrap.min.css" />
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderSearchArea" runat="server">
	<SharePoint:DelegateControl runat="server"
		ControlId="SmallSearchInputBox"/>
</asp:Content>

<asp:Content ContentPlaceHolderId="PlaceHolderPageDescription" runat="server">

	<SharePoint:ProjectProperty Property="Description" runat="server"/>

</asp:Content>

<asp:Content ContentPlaceHolderId="PlaceHolderMain" runat="server">
	<div class="ms-hide">
	<WebPartPages:WebPartZone runat="server" title="loc:TitleBar" id="TitleBar" AllowLayoutChange="false" AllowPersonalization="false" Style="display:none;"><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone>
  </div>
  <table class="ms-core-tableNoSpace ms-webpartPage-root" width="100%">
				<tr>
					<td id="_invisibleIfEmpty" name="_invisibleIfEmpty" valign="top" width="100%"> 
					<WebPartPages:WebPartZone runat="server" Title="loc:FullPage" ID="FullPage" FrameType="TitleBarOnly" IsVisible="False"><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone> </td>
				</tr>
				<SharePoint:ScriptBlock runat="server">
				if(typeof(MSOLayout_MakeInvisibleIfEmpty) == &quot;function&quot;) 
				{MSOLayout_MakeInvisibleIfEmpty();}</SharePoint:ScriptBlock>
		</table>
		<div name="ReportBody" runat="server" id="ReportBody"/>
		
		
 <script type="text/jscript" src="https://project.cti.ru/PWA/htmcss/js/bootstrap.bundle.min.js" ></script>

		
</asp:Content>
<script type="text/c#" runat="server">


        protected void Page_Load(Object sender, EventArgs e)
        {
            
            ReportBody.InnerHtml=PrintTable();
        }
       public static string cases(SqlConnection SqlConn)
        {
            string html = "<div > <ul class=\"nav nav-tabs\" id=\"myTab\" role=\"tablist\">"+
"<li class=\"nav-item\" role=\"presentation\">"+
"<button class=\"nav-link active\" id=\"problem-tab\" data-bs-toggle=\"tab\" data-bs-target=\"#Problems\" type=\"button\" role=\"tab\" aria-controls=\"problems\" aria-selected=\"true\">Проблемы"+
"</button></li>"+
"<li class=\"nav-item\" role=\"presentation\">"+
"<button class=\"nav-link\" id=\"risks-tab\" data-bs-toggle=\"tab\" data-bs-target=\"#Risks\" type=\"button\" role=\"tab\" aria-controls=\"risks\" aria-selected=\"false\">Риски"+
"</button></li></ul>"+
"<div class=\"tab-content\" id=\"TabContent\">"+
"<div class=\"tab-pane fade show active\" id=\"Problems\" role=\"tabpanel\" aria-labelledby=\"problem-tab\"><h2>Проблемы</h2>"+
"<ul class=\"nav nav-pills mb-3\" id=\"pr-pills-tab\" role=\"tablist\">"+
"<li class=\"nav-item\" role=\"presentation\">"+
"<button class=\"nav-link active\" id=\"pr-pills-all-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#pr-pills-all\" type=\"button\" role=\"tab\" aria-controls=\"pr-pills-all\" aria-selected=\"true\">Все"+
"</button></li>"+
"<li class=\"nav-item\" role=\"presentation\">"+
"<button class=\"nav-link\" id=\"pr-pills-other-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#pr-pills-other\" type=\"button\" role=\"tab\" aria-controls=\"pr-pills-other\" aria-selected=\"false\">Общий"+
"</button></li>"+
"<li class=\"nav-item\" role=\"presentation\">"+
"<button class=\"nav-link\" id=\"pr-pills-telekom-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#pr-pills-telekom\" type=\"button\" role=\"tab\" aria-controls=\"pr-pills-telekom\" aria-selected=\"false\">ТИРС"+
"</button></li>"+
"<li class=\"nav-item\" role=\"presentation\">"+
"<button class=\"nav-link\" id=\"pr-pills-vimpelkom-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#pr-pills-vimpelkom\" type=\"button\" role=\"tab\" aria-controls=\"pr-pills-vimpelkom\" aria-selected=\"false\">Вымпелком"+
"</button></li></ul>"+
"<div class=\"tab-content\" id=\"pr-pills-tabContent\">"+
"<div class=\"tab-pane fade show active\" id=\"pr-pills-all\" role=\"tabpanel\" aria-labelledby=\"pr-pills-all-tab\"><h3>Все проблемы</h3>"+
      TableList(SqlConn, "Проблема","Все") +
            "</div>"+
            "<div class=\"tab-pane fade\" id=\"pr-pills-other\" role=\"tabpanel\" aria-labelledby=\"pr-pills-other-tab\"><h3>Общий проблемы</h3>"+
 TableList(SqlConn, "Проблема","Общие")+
            "</div>"+
            "<div class=\"tab-pane fade\" id=\"pr-pills-telekom\" role=\"tabpanel\" aria-labelledby=\"pr-pills-telekom-tab\"><h3>ТИРС проблемы</h3>"+
 TableList(SqlConn, "Проблема","ТИРС")+
            "</div>" +
            "<div class=\"tab-pane fade\" id=\"pr-pills-vimpelkom\" role=\"tabpanel\" aria-labelledby=\"pr-pills-vimpelkom-tab\"><h3>Вымпелком проблемы</h3>"+
             TableList(SqlConn, "Проблема","Вымпелеком")+
            "</div></div>" +
            "</div>" +
            "<div class=\"tab-pane fade\" id=\"Risks\" role=\"tabpanel\" aria-labelledby=\"risks-tab\"><h2>Риски</h2>" +
            "<ul class=\"nav nav-pills mb-3\" id=\"risks-pills-tab\" role=\"tablist\">" +
            "<li class=\"nav-item\" role=\"presentation\">" +
            "<button class=\"nav-link active\" id=\"risks-pills-all-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#risk-pills-all\" type=\"button\" role=\"tab\" aria-controls=\"risk-pills-all\" aria-selected=\"true\">Все </button></li>" +
            "<li class=\"nav-item\" role=\"presentation\"><button class=\"nav-link\" id=\"risk-pills-all-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#risk-pills-other\" type=\"button\" role=\"tab\" aria-controls=\"risk-pills-other\" aria-selected=\"false\">Общий    </button></li>" +
            "<li class=\"nav-item\" role=\"presentation\"><button class=\"nav-link\" id=\"risk-pills-telekom-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#risk-pills-telekom\" type=\"button\" role=\"tab\" aria-controls=\"risk-pills-telekom\" aria-selected=\"false\">ТИРС </button> </li>" +
            "<li class=\"nav-item\" role=\"presentation\"> <button class=\"nav-link\" id=\"risk-pills-vimpelkom-tab\" data-bs-toggle=\"pill\" data-bs-target=\"#risk-pills-vimpelkom\" type=\"button\" role=\"tab\" aria-controls=\"risk-pills-vimpelkom\" aria-selected=\"false\">Вымпелком</button></li>" +
            "</ul>" +
            "<div class=\"tab-content\" id=\"risk-pills-tabContent\">" +
            "<div class=\"tab-pane fade show active\" id=\"risk-pills-all\" role=\"tabpanel\" aria-labelledby=\"risk-pills-all-tab\"><h3>Все риски</h3>" +
            TableList(SqlConn, "Риск","Все")+
            "</div>" +
            "<div class=\"tab-pane fade\" id=\"risk-pills-other\" role=\"tabpanel\" aria-labelledby=\"risk-pills-other-tab\"><h3>Общий риски</h3>" +
            TableList(SqlConn, "Риск","Общие")+
            "</div>" +
            "<div class=\"tab-pane fade\" id=\"risk-pills-telekom\" role=\"tabpanel\" aria-labelledby=\"risk-pills-telekom-tab\"><h3>ТИРС риски</h3>" +
            TableList(SqlConn, "Риск","ТИРС")+
            "</div>" +
            "<div class=\"tab-pane fade\" id=\"risk-pills-vimpelkom\" role=\"tabpanel\" aria-labelledby=\"risk-pills-vimpelkom-tab\"><h3> Вымпелком риски</h3>" +
            TableList(SqlConn, "Риск","Вымпелеком")+
            "</div>" +
            "</div></div></div></div></div>";
            return html;
        }

       public static string QueryStr(string prjtype, string prjstat, string dstatus)
        {
                        string department = "";
            string projectevents="";
            string solution = "";


            switch(prjstat)
            {
                case "Общий": department = "= N'Общий'"; break;
                case "ТИРС": department = "= N'ТИРС'"; break;
                case "Вымпелеком": department = "= N'Вымпелеком'"; break;
                default:  department = "IS NOT NULL"; break;
            }
            switch(prjtype)
            {
                case "Проблема":
                    {
                        projectevents = "N'Проблема' ";
                        solution = " ,UR.ContingencyPlan as 'Plan' ";

                        break;
                    }
                case "Риск":
                    {
                        projectevents = "N'Риск' ";
                        solution = " ,UR.MitigationPlan as 'Plan' ";

                        break;
                    }
            }
            string SqlQur = "SELECT UR.title " +
                          ", UR.Description  " +
                          ", UR.Status  " +
                          ", UR.AssignedToResource " +
                          ", UR.Exposure  " +
                          ", UR.Cost  " +
                          ", UR.CreatedDate " +
                          ", UR.DueDate " +
                          solution;
            SqlQur +=     ", Up.ЛИД as 'lid'" +
                          ",  Up.[Название ЛИДа] as 'lidname'"+  
                          ", UR.RiskID " +
                          ", UP.ProjectWorkspaceInternalHRef " +
                          ", UR.ProjectUID "+
                          " FROM pjrep.MSP_EpmProject_UserView UP " +
                          "INNER JOIN pjrep.MSP_WssRiskToRiskLinks_UserView UR " +
                          "ON UP.ProjectUID = UR.ProjectUID "+
                          "WHERE Ur.Category Like "+projectevents+
                     //     " AND [Статус проекта] IN (N'Детальное планирование',N'Реализация')"+
                          " AND up.[Отделы проекта] "+department+" "+
  //                        "AND [Статус проекта] IN (N'Детальное планирование',N'Реализация')"+
                          "AND UR.Status = N'"+dstatus+"'";
            return SqlQur;
        }



        public static string TableData(DataTable dtable, string status)
        {
            string html="";
           string css_alert="";
            switch(status){
               case "В работе": {
               			css_alert="btn-warning";
               			break;
               			}
               case "Мониторинг": {
                       css_alert="btn-info";
               			break;
               			}
               case "Закрыт": {
                        css_alert="btn-success";
               			break;
               			}
               			
            
            }
            for (int i = 0; i < dtable.Rows.Count; i++)
            {
                html += "<tr class=\"border\">";
                html += "<td class=\"align-middle text-center border\" stype=\"max-width:80px \">" +
                	"<div class =\"btn-group-vertical btn-group-sm  gap-2 col-6 d-grid \" style=\"width: 100%\">"+
                	  "<a href=\"" + GetProjectLink(dtable.Rows[i]["ProjectUID"].ToString()) + "&ret=0\">"+
                             "<button type=\"button\" class=\"btn btn-primary btn-sm\" data-bs-toggle=\"tooltip\" data-bs-placement=\"top\" data-bs-html=\"true\" title=\"К проекту &#171;"+
                                 dtable.Rows[i]["lidname"].ToString() +"&#187;\" >"+
                                 dtable.Rows[i]["Lid"].ToString()+
                             "</button>"+
                      "</a>" +
                      "<a href=\""+GetRiskLink(dtable.Rows[i]["ProjectWorkspaceInternalHRef"].ToString(),dtable.Rows[i]["RiskID"].ToString()) +"\" >"+
                            "<button type=\"button\" class=\"btn "+css_alert+" btn-sm\" data-bs-placement=\"top\" title=\"К событию &#171;"+dtable.Rows[i]["title"].ToString() +"&#187; \">"+
                                 dtable.Rows[i]["Status"].ToString()+
                            "</button>"+
                      "</a>" +
                    "</div>" +
                    "</td>";
                html += "<td class=\"align-middle border\" >"+dtable.Rows[i]["Description"].ToString()+"</td>";
                html += "<td class=\"align-middle border\" >"+dtable.Rows[i]["Plan"].ToString()+"</td>";
                html += "<td class=\"align-middle text-center border\" >"+dtable.Rows[i]["AssignedToResource"].ToString()+"</td>";
                html += "<td class=\"align-middle text-center border\" >" + String.Format("{0:c0}", Convert.ToDecimal(dtable.Rows[i]["Cost"].ToString()))  + "</td>";
                try
                {
                    html += "<td class=\"align-middle text-center border\" >" + String.Format("{0:D}", Convert.ToDateTime(dtable.Rows[i]["CreatedDate"].ToString())) + "</td>";
                }
                catch
                {
                    html += "<td class=\"align-middle text-center border\" > Отсутствует </td>";
                }
                try
                {
                    html += "<td class=\"align-middle text-center border\" >" + String.Format("{0:D}", Convert.ToDateTime(dtable.Rows[i]["DueDate"].ToString())) + "</td>";
                }
                catch
                {
                    html += "<td class=\"align-middle text-center border\" > Отсутствует </td>";
                }
               // html += "<td class=\"align-middle text-center border\" >"+dtable.Rows[i]["Status"].ToString()+"</td>";
               // html += "<td class=\"align-middle text-center border\" >" +
               //     dtable.Rows[i]["Lid"].ToString()+"</td>";

                html+= "</tr>";


            }
            return html;
        }

      public  static string TableList(SqlConnection SqlConn, string PrjEvents,string location )
        {
                       string html = "<div style=\"font-size:14px\"  >";
            html+="<table class=\"table border \" id=\"actiontale\">";
            html += "<thead><tr >" +
                    "<td width='180px'  class=\"align-middle\"  title='Переходы'>&nbsp;</td>" +
                    "<td width='30%' font-size='10px' class=\"align-middle\"  title='Подробное описание события'>Описание события</td>";
            switch(PrjEvents){
                case "Проблема":
                    {
                        html += "<td width='35%'  class=\"align-middle\" title='План решения проблемы'>План решения проблемы</td>";
                        ;

                        break;
                    }
                case "Риск":
                    {
                        html +=  "<td width='35%'  class=\"align-middle\" title='План минимизации риска'>План минимизации риска</td>";

                        break;
                    }
            }
            html +="<td  width='80' class=\"align-middle text-center \" title='Ответсвенный за событие'>Ответственный</td>" +

                    "<td  width='130' class=\"align-middle text-center \" title='Значение насколько событие влияет на бюджет проека'>Стоимость</td>" +
                    "<td  width='130' class=\"align-middle text-center \" title='Дата когда событие становистя неактуальным'>Дата открытия</td>"+
                    "<td  width='130' class=\"align-middle text-center \" title='Дата когда событие становистя неактуальным'>Дата закрытия</td>";
            //html +="<td width='150' class=\"align-middle text-center \" title='Статус события'>Статус</td>";

            //html +="<td  width='150' class=\"align-middle text-center \"  title='Лид проекта'>ЛИД</td>";
            html +="</tr></thead>";

            /////
            ///
            string[] dstatus = { "В работе", "Мониторинг", "Закрыт" };
            string SQLqs = "";
            foreach (string stat in dstatus)
            {
                SQLqs = QueryStr(PrjEvents, location, stat);

                SqlDataAdapter myCmd = new SqlDataAdapter(SQLqs, SqlConn);
                DataTable dt = new DataTable();
                myCmd.Fill(dt);
                DataTable dt1 = dt;
                html +=TableData(dt1,stat);
                //add rows
            }
                html += "</tbody></table></div>";           

            return html;
        }

        public static string GetProjectLink(string ProjectUID)
        {
            string Url= "https://project.cti.ru/PWA/Project%20Detail%20Pages/StatusReport.aspx?ProjUid="+ProjectUID;
            return Url;

        }
        public static string GetRiskLink(string HRef, string RiskID )
        {

            string Url=HRef+"/Lists/Risks/DispForm.aspx?ID="+RiskID;
            return Url;

        }


      public  static string PrintTable()
        {
            string QCS = ConfigurationManager.ConnectionStrings["PWAConnectionString"].ConnectionString;
            SqlConnection myConn = new SqlConnection(QCS);
            return cases(myConn);
        }
        

</script>


<%-- _lcid="1049" _version="16.0.10337" _dal="1" --%><%-- _LocalBinding --%>
<%@ Page language="C#" MasterPageFile="~masterurl/default.master"    Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage,Microsoft.SharePoint,Version=16.0.0.0,Culture=neutral,PublicKeyToken=71e9bce111e9429c" meta:progid="SharePoint.WebPartPage.Document"  %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Import Namespace="Microsoft.SharePoint" %><%@ Assembly Name="Microsoft.Web.CommandUI, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ContentPlaceHolderId="PlaceHolderPageTitle" runat="server">
	<SharePoint:listitemproperty Property="BaseName" maxlength="40" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderAdditionalPageHead" runat="server">
	<meta name="GENERATOR" content="Microsoft SharePoint" />
	<meta name="ProgId" content="SharePoint.WebPartPage.Document" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="CollaborationServer" content="SharePoint Team Web Site" />
	<SharePoint:scriptblock runat="server">
	var navBarHelpOverrideKey = &quot;WSSEndUser&quot;; </SharePoint:ScriptBlock>
<SharePoint:styleblock runat="server">
	body #s4-leftpanel {
	display:none;
}
.s4-ca {
	margin-left:0px;
} </SharePoint:StyleBlock>
	<link rel="stylesheet" type="text/css" href="../htmcss/main.css" />

	<link rel="stylesheet" type="text/css" href="../htmcss/css/bootstrap.min.css" />

</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderSearchArea" runat="server">
	<SharePoint:delegatecontrol runat="server"
		ControlId="SmallSearchInputBox"/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderPageDescription" runat="server">
	<SharePoint:ProjectProperty Property="Description" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderMain" runat="server">
	<div class="ms-hide">
	<WebPartPages:WebPartZone runat="server" title="loc:TitleBar" id="TitleBar" AllowLayoutChange="false" AllowPersonalization="false" Style="display:none;"><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone>
  </div>
 
<!-- Вывод данных на страницу -->   
<div name="StatusReport" id="StatusReport" class="content">  
<p/> 
           <div name="ReportBody" runat="server" id="ReportBody" />
</div>
 <script type="text/jscript" src="https://someserver/PWA/htmcss/js/bootstrap.bundle.min.js" ></script>
</asp:Content>
   <script language="C#" runat="server">

        class StatusReport
        {

            SqlConnection sqlConn;  // Подключение к БД
            SqlDataAdapter uDataAdapter; // 
            int isTrouble;     //   Критическая проблема в проекте
            int varTime;      // Отставание(полож) опережение (отриц)
            Decimal varBudjet; // отклонение по бюджету (отриц - экономия)
            Decimal EAC;       // Утвержденный бюджет проекта: (EAC) 
            Decimal BAC;      // Прогнозный бюджет проекта: (BAC)   
            public DataSet reportData; // Все данные отчета
            String siteRootName; // Корневой адрес сайта
            String ProjectUID;   // UID Проекта со страницы
                                 //      public String[] PrjsUID;   // UID Проектов при выборке
            public List<string> PrjsUID; // UID Проектов при выборке
                                         //   String[] cases;      //Портфели проектов
            List<string> Portfolio;  //Портфели проектов
                                     //   Decimal BudjetOverLimit; // Превышение бюджета
                                     //   String BudjetOverLimits; // Превышение бюджета text
            Decimal DayOverLimit;    // Превышение по срокам
            String DayOverLimits;    // Превышение по срокам
            public String StopDeal;        //Веха остановки сделки
            public String Techsupport;
            public String StartDeal;
            //Byte TrobleFlag;        //Критическая проблема
            String SQLConString;
            // int TroubleCount;           //Количество проблем
            // int RisksCount;          //Количество рисков
            Dictionary<char, string> ConvertedLetters = new Dictionary<char, string>
    {
        {'а', "a"},{'б', "b"},{'в', "v"},{'г', "g"},{'д', "d"},{'е', "e"},{'ё', "yo"},{'ж', "zh"},{'з', "z"},
        {'и', "i"},{'й', "j"},{'к', "k"},{'л', "l"},{'м', "m"},{'н', "n"},{'о', "o"},{'п', "p"},{'р', "r"},
        {'с', "s"},{'т', "t"},{'у', "u"},{'ф', "f"},{'х', "h"},{'ц', "c"},{'ч', "ch"},{'ш', "sh"},{'щ', "sch"},
        {'ъ', "j"},{'ы', "i"},{'ь', "j"},{'э', "e"},{'ю', "yu"},{'я', "ya"},{'А', "A"},{'Б', "B"},{'В', "V"},{'Г', "G"},
        {'Д', "D"},{'Е', "E"},{'Ё', "Yo"},{'Ж', "Zh"},{'З', "Z"},{'И', "I"},{'Й', "J"},{'К', "K"},{'Л', "L"},{'М', "M"},
        {'Н', "N"},{'О', "O"},{'П', "P"},{'Р', "R"},{'С', "S"},{'Т', "T"},{'У', "U"},{'Ф', "F"},{'Х', "H"},{'Ц', "C"},
        {'Ч', "Ch"},{'Ш', "Sh"},{'Щ', "Sch"},{'Ъ', "J"},{'Ы', "I"},{'Ь', "J"},{'Э', "E"},{'Ю', "Yu"},{'Я', "Ya"},{' ',"_" },{'/',"_" },
        {'\\',"_" },{'+',"_" },{'-',"_" },{'.',"_" },{',',"_" },{';',"_" },{'?',"_" },{'!',"_" },{'\'',"_" },{'\"',"_" },
        {'*',"_" },{'@',"_" },{'%',"_" },{'#',"_" },{'(',"_" },{')',"_" },{'{',"_" },{'}',"_" },{'[',"_" },{']',"_" },{'&',"_" },
        {'~',"_" },{'`',"_" },{'$',"_" },{'^',"_" }
    };
            /// <summary>
            /// чсписок рабочих проектов
            /// </summary>
            /// <param name="PUID"></param>
            public void setProjUID(string PUID)
            {

                this.ProjectUID = PUID;
                this.PrjsUID.Add(PUID);
            }
            /// <summary>
            /// очистка списка рабочих проектов
            /// </summary>
            public void clearProjUID()
            {
                PrjsUID.Clear();

            }



            /// <summary>
            /// Строка подключения
            /// Удалить
            /// Добавляет к глобальной переменную класса
            /// </summary>
            /// 
            public void setQstring()
            {
                string QCS = "server = someserver; uid=someuser; pwd=somepass; database=somedb";
                SqlConnection myConn = new SqlConnection(QCS);

            }



            /// <summary>
            /// Генерирует URL ссылки на собитие(проблема, риск)
            /// </summary>
            /// <param name="HRef">Корневой узел* из БД</param>
            /// <param name="RiskID">Номер события на узле проекта</param>
            /// <returns></returns>
            /// 
            public string GetRiskLink(string HRef, string RiskID)
            {

                string Url = HRef + "/Lists/Risks/DispForm.aspx?ID=" + RiskID;
                return Url;

            }
            public string ConvertToLatin(string source)
            {
                var result = new StringBuilder();
                foreach (var letter in source)
                {
                    result.Append(ConvertedLetters[letter]);
                }
                return result.ToString();


            }

            /// <summary>
            /// Поулчает список портфелей
            /// </summary>
            public void getCases()
            {
                // todo: Процедура получения портфелей
                QueryString("Portfolio");
            }




            public string getFilter(List<string> ProjectIDs)
            {
                string queue = string.Empty;

                queue = "(";
                int PrjCount = ProjectIDs.ToArray().Length;
                //     QueueFilter += Convert.ToString(PrjCount);
                if (PrjsUID.ToArray().Length > 0)
                {
                    queue += "N'" + ProjectIDs[0] + "'";
                    if (PrjCount > 1)
                    {
                        for (int cnt = 1; cnt < PrjCount; cnt++)
                        {
                            queue += ", N'" + ProjectIDs.ToArray()[cnt] + "'";
                        }
                    }
                    
                }

                queue += ")";

                return queue;
            }


            /// <summary>
            /// Генерация SQL запросов
            /// </summary>
            /// <param name="dtable">ИМя запроса</param>
            /// <returns>Возвращает запрос по типу данных</returns>
            public string QueryString(string dtable)
            {
                string[] strepquerry;
                int queuenum = 0;
                string QueueFilter = string.Empty;
                switch (dtable)
                {
                    case "PassPort": queuenum = 0;
                        QueueFilter = getFilter(PrjsUID);
                        break;
                    case "Milestone": queuenum = 1;
                        QueueFilter = getFilter(PrjsUID);
                        break;
                    case "WssTrouble": queuenum = 2;
                        QueueFilter = getFilter(PrjsUID);
                        break;
                    case "WssRisk": queuenum = 3;
                        QueueFilter = getFilter(PrjsUID);
                        break;
                    case "TaskOld": queuenum = 4;
                        QueueFilter = getFilter(PrjsUID);
                        break;
                    case "TaskTodo": queuenum = 5;
                        QueueFilter = getFilter(PrjsUID);
                        break;
                    case "ProjActive": queuenum = 6; break;
                    case "Portfolio": queuenum = 7; break;
                    case "Dealtype": queuenum = 8; break;
                    case "PMManager": queuenum = 9; break;
                    case "Activetype": queuenum = 10; break;
                    case "Contractor": queuenum = 11; break;
                    case "PM": queuenum = 12; break;
                    case "Sale": queuenum = 13; break;
                    case "LidInCases": queuenum = 14;

                        QueueFilter = getFilter(PrjsUID);  //List<string>
                        break;
                    default: queuenum = 0; break;

                }








                strepquerry = new string[] {
         //// Данные паспорта проекта PassPort:0
         ///
             "SELECT" +
             " UV.[Название ЛИДа] as 'LeadName'" +
             ",UV.ProjectDescription	as 'ProjectDescription'" +
             ",UV.Заказчик	as 'Customer'" +
             ",UV.ЛИД	as 'LeadID'" +
             ",UV.РП	as 'PM'" +
             ",UV.Сейл as 'Sales'"+
             ",Cast(UV.Выручка as int) as 'Proceeds'" +
             ",UV.Подрядчики	as 'Contractor'" +
             ",UV.ГИП as 'GIP'" +
             ",UV.ProjectPercentCompleted as 'ProjectPercentWorkCompleted'" +
             ",UV.[Общий статус проекта] as 'ProjectGeneralStatus'" +
             ",CAST( ISNULL(UV.[Оборудование материалы лицензии План], 0 ) as int)  AS 'ApprovedBudgetForTheSupply'" + //Бюджет на поставку - План
             ",CAST( ISNULL(UV.[Стоимость времени сотрудников План], 0 ) as int) AS 'ApprovedBudgetForWorks'" + //Бюджет на работы - План
             ",CAST( ISNULL(UV.[Работы услуги План], 0 ) as int) AS 'ApprovedContractorBudget'" +//
             ",CAST( ISNULL(UV.[Утвержденный бюджет на прочие расходы], 0 ) as int)  AS 'ApprovedBudgetForMiscellaneousExpenses'" +//
             ",CAST( ISNULL(UV.[Прогнозный бюджет на поставку], 0 ) as int) AS 'ForecastBudgetForDelivery'" + //
             ",CAST( ISNULL(UV.[Прогнозный бюджет на подрядчиков], 0 ) as int) AS 'ForecastBudgetForContractors'" +//Прогнозный бюджет на подрядчиков
             ",CAST( ISNULL(UV.[Прогнозный бюджет на прочие расходы], 0 ) as int)  AS 'ForecastBudgetForOtherExpenses'" +//
             ",CAST( ISNULL(UV.[Прогнозный бюджет на трудозатраты], 0 ) as int) As 'ForecastBudgetForWork'"+ //
             ",CAST(UV.[Трудозатраты План] as int) as 'ApprovedLaborCosts'" + //
             ",CAST(UV.ProjectWork as int) as	'ProjectWork'" + //
             ",CAST(UV.ProjectActualWork as int) as 'ProjectActualWork'" + //
             ",CAST(UV.[Оборудование материалы лицензии Факт] as int) AS 'ActualDeliveryCosts'" + //Затраты на поставку - Факт
             ",CAST(UV.[Работы услуги Факт] as int) AS 'ActualCostsContractors'" + //Затраты на подрядчиков - Факт
             ",CAST(UV.[Фактические затраты на прочие расходы] as int) AS 'ActualCostsOtherExpenses'" + //
             ",CAST(UV.[Стоимость времени сотрудников Факт] as int) AS 'ActualCostsWork'" + //Затраты на работы - Факт
             ",UV.[Комментарий по бюджету] AS 'budjetcoment'" + //
             ",UV.ProjectWorkspaceInternalHRef " + //
             ",UV.[Критическая проблема] as 'CriticalIssues'"+ //
             ",UV.[Архивация] as 'Archiving'"+ //
             ",UV.[Портфель проекта] as 'ProjectPortfolio'"+ //
             ",UV.[Комментарий по отклонениям от базового плана] as 'CommentsOnDeviationsFromBasicPlan'"+ //
             ",UV.[Дата заключения договора] as 'DateOfConclusionContract' "+ //
             ",UV.ProjectUID "+ //
             ",UV.ProjectFinishDate  AS 'ProjectFinishDate'" + //
             ",UV.ProjectBaseline0FinishDate  AS  'ProjectBaseline0FinishDate'"+ //
             ",uv.ProjectModifiedDate"+ //
             ",uv.[Стоимость денег План] AS 'MoneyValuePlan'"+ //
             ",uv.[Стоимость денег Факт] AS 'MoneyValueFact'"+ //
             ",uv.[Штрафы план] AS 'FinePlan'"+ //
             ",uv.[Штрафы факт] AS 'FineFact'"+ //
             " FROM pjrep.MSP_EpmProject_UserView UV WHERE ProjectUID In "+QueueFilter, //

         ////// Список вех по проекам Milestone:1
         ///
             "SELECT TaskIndex "+
             ",TaskName"+
             ",TaskBaseline0FinishDate"+
             ",TaskFinishDate"+
             ",TaskActualFinishDate"+
             ",ProjectUID "+
             ",TaskFinishVariance/8 as 'TaskFinishVariance'"+
             ",[КЛЮЧЕВЫЕ ВЕХИ (CTI) - КОММЕНТАРИИ] as 'CTIMilestoneComment'"+
             "FROM pjrep.MSP_EpmTask_UserView "+
             "WHERE  TaskIsMilestone =1  AND [КЛЮЧЕВАЯ ВЕХА]=1 AND ProjectUID In "+QueueFilter+
             "ORDER BY TaskIndex;",

        //// Проблемы в проекте WssTrouble:2
        ///
             "SELECT tbl.Title as Title " +
             ",tbl.Description as Description " +
             ",tbl.AssignedToResource as AssignedTo " +
             ",tbl.ContingencyPlan as ContingencyPlan " +
             ",tbl.Exposure as Exposure " +         //Влияние
             ",tbl.Cost as Cost " +     // Стоимость
             ",tbl.CostExposure as CostExposure " +   // нагрузка на бюджет
             ",tbl.Probability" +            // Вероятность
             ",tbl.Category as Category " +
             ",tbl.ProjectUID "+
             ",tbl.Status as Status " +
             "FROM pjrep.MSP_WssRisk tbl " +
             "WHERE Category=N'Проблема' " +
             "AND tbl.status IN (N'В работе',N'Мониторинг') " +
             "AND tbl.ProjectUID In "+QueueFilter,

         //// Риски в проекте WssRisk:3
         ///
             "SELECT tbl.Title as Title " +
             ",tbl.Description as Description " +
             ",tbl.AssignedToResource as AssignedTo " +
             ",tbl.MitigationPlan  as MitigationPlan " +
             ",tbl.Exposure as Exposure " +
             ",tbl.Cost as Cost " +
             ",tbl.CostExposure as CostExposure " +
             ",tbl.Probability" +            // Вероятность
             ",tbl.Category as Category " +
             ",tbl.Status as Status " +
             ",tbl.ProjectUID "+
             "FROM pjrep.MSP_WssRisk tbl " +
             "WHERE Category=N'Риск' " +
             "AND tbl.status IN (N'В работе',N'Мониторинг') " +
             "AND tbl.ProjectUID In "+QueueFilter,

         //// Задачи на эту неделю TaskOld:4
         ///
             "SELECT TaskIndex " +
             ",TaskName " +
             ",ProjectUID "+
             "FROM pjrep.MSP_EpmTask_UserView " +
             "WHERE " +
             "DATEDIFF(week, TaskFinishDate, GETDATE()) = 0 AND " +
             "TaskPercentCompleted =100 " +
             "AND TaskIsSummary<>1 " +
             "AND ProjectUID In "+QueueFilter,

         //// Задачи за прошлую неделю TaskTodo:5
         ///
             "SELECT 	TaskIndex " +
             ",TaskName " +
             ",ProjectUID "+
             " FROM pjrep.MSP_EpmTask_UserView " +
             "WHERE DATEDIFF(week, TaskFinishDate, GETDATE()) = -1 " +
             "AND TaskPercentCompleted<100 " +
             "AND TaskIsSummary<>1 AND ProjectUID In "+QueueFilter,

         ///// Не архивные проекты ProjActive:6
         ///
            "SELECT " +
            "UV.ProjectUID " +
            ",UV.Архивация " +
            "FROM pjrep.MSP_EpmProject_UserView UV " +
            "WHERE UV.[Архивация] NOT In (N'Да')",

        //// Портфель Portfolio:7
        ///
            "SELECT UV.[Отделы проекта] AS portfolio " +
            "FROM pjrep.MSP_EpmProject_UserView UV " +
            "WHERE uv.[Отделы проекта] <>'-' " +
            " GROUP BY uv.[Отделы проекта]",

         ////    Вид сделки Dealtype:8
         
             "SELECT UV.[Вид сделки] " +
             "FROM pjrep.MSP_EpmProject_UserView UV " +
             "WHERE uv.[Вид сделки] IS NOT NULL " +
             "GROUP BY uv.[Вид сделки]",
        ////  Руководитель ПО PMManager:9
             "SELECT UV.[Руководитель ПО] " +
             "FROM pjrep.MSP_EpmProject_UserView UV " +
             "WHERE uv.[Руководитель ПО] IS NOT NULL " +
             " GROUP BY uv.[Руководитель ПО]",
         ////    Тип активности Activetype:10
         ///
             "SELECT UV.[Тип активности] " +
             "FROM pjrep.MSP_EpmProject_UserView UV " +
             "WHERE uv.[Тип активности] IS NOT NULL " +
             " GROUP BY uv.[Тип активности]",
        /////   Заказчик Contractor:11
        ///
            "SELECT UV.[Заказчик] "+
             "FROM pjrep.MSP_EpmProject_UserView UV " +
             "WHERE uv.[Заказчик] IS NOT NULL " +
             " GROUP BY uv.[Заказчик]",
        ////     РП PM:12
        ///
            "SELECT UV.[РП]" +
            "FROM pjrep.MSP_EpmProject_UserView UV " +
            "WHERE uv.[РП] IS NOT NULL " +
            " GROUP BY uv.[РП]",
        ////     Сейл Sale:13
        ///
            "SELECT UV.[Сейл]" +
            "FROM pjrep.MSP_EpmProject_UserView UV " +
            "WHERE uv.[Сейл] IS NOT NULL " +
            " GROUP BY uv.[Сейл]",
        //////
        /// Проекты в портфелях lidincases: 14
        ///

             "SELECT UV.[Отделы проекта] AS portfolio " +
             ",ProjectUID "+
            "FROM pjrep.MSP_EpmProject_UserView UV " +
            "WHERE uv.[Отделы проекта] <>'-' " +
            " ORDER BY uv.[Отделы проекта]",

            };


                return strepquerry[queuenum];

            }



            /// <summary>
            /// Заполняет Данные потаблично
            /// </summary>
            /// <param name="dtable">Имя таблицы</param>
            public void PullData(string dtable)
            {
                string SQLqs = QueryString(dtable);
                SqlDataAdapter uDataAdapter = new SqlDataAdapter(SQLqs, sqlConn);
                DataTable dt = new DataTable();
                uDataAdapter.Fill(dt);
                dt.TableName = dtable;
                reportData.Tables.Add(dt);
            }



            /// <summary>
            /// /Project Problem notification
            /// </summary>
            /// <returns>
            /// Возращает кусок html кода с базовыми показателями проболем в проекте
            /// </returns>
            public string putProjProbNot()
            {

                return "html";
            }

            public DataTable GetMinestones(String ProjUID, String Minestones)
            {
                String SQLqs = "SELECT    CAST(UT.TaskFinishVariance / 8 AS int) as 'TaskFinishVariance'" +
                               ",UT.TaskBaseline0FinishDate" +
                               ",UT.TaskFinishDate" +
                               ",UT.TaskName" +
                               ",UT.ProjectUID" +
                               " FROM pjrep.MSP_EpmTask_UserView UT" +
                               " WHERE" +
                               " Ut.TaskIsMilestone=1 AND ut.[КЛЮЧЕВАЯ ВЕХА]=1" +
                               " AND Ut.ProjectUID='" + ProjUID + "'" +
                               "  AND   UT.TaskName LIKE N'%" + Minestones + "%'";

                SqlDataAdapter uDataAdapter = new SqlDataAdapter(SQLqs, sqlConn);
                DataTable dt = new DataTable();
                uDataAdapter.Fill(dt); return dt;

            }
            /// <summary>
            /// Заполнение глоб. переменных - для инфоблока
            /// </summary>
            /// 



            public string CritProject(string ProjID)
            {
                DataView DView = new DataView();
                string Html = "";
                DView.Table = reportData.Tables["PassPort"];
                DView.RowFilter = "ProjectUID = '" + ProjID + "'";
                if (DView[0]["CriticalIssues"].ToString() == "Да")
                {
                    Html += "<div class=\"text-danger fw-bolder\"> Критическая проблема</div>"; // Критическая пробелма
                }
                else
                {
                    Html += "<div class=\"text-black-50 text-opacity-25 \"> Критическая проблема</div>"; // Нет критической пробелмы
                    Html += "";
                };

                return Html;
            }

            public string RisksCount(string ProjID)
            {
                DataView DView = new DataView();
                string Html = "";
                int Count;

                DView.Table = reportData.Tables["WssRisk"];
                DView.RowFilter = "ProjectUID = '" + ProjID + "'";

                Count = DView.Table.Rows.Count;


                if (Count == 0)
                {
                    Html += "<span class=\"text-primary fw-bold\">Активные Риски: " + Count + "</span>";
                }
                else
                {
                    Html += "<span class=\"text-warning fw-bold\">Активные Риски: " + Count + "</span>";
                }



                return Html;
            }

            public string TroubleCount(string ProjID)
            {
                DataView DView = new DataView();
                string Html = "";
                int Count;
                DView.Table = reportData.Tables["WssTrouble"];
                DView.RowFilter = "ProjectUID = '" + ProjID + "'";
                Html += CritProject(ProjID);
                try
                {
                    Count = DView.Table.Rows.Count;
                }
                catch
                {
                    Count = 0;
                }

                if (Count == 0)
                {
                    Html += "<span class=\"text-primary fw-bold\">Активные Проблемы: " + Count + "</span>";
                }
                else
                {
                    Html += "<span class=\"text-danger fw-bold\">Активные Проблемы: " + Count + "</span>";
                }

                return Html;
            }


            public string TimeOverLimit(string ProjID)
            {
                DataView DView = new DataView();
                DView.Table = reportData.Tables["PassPort"];
                DView.RowFilter = "ProjectUID = '" + ProjID + "'";
                DataTable taskparam = GetMinestones(ProjID, StopDeal);

                string Html = "";
                int Variance;
                try
                {
                    Variance = Convert.ToInt32(taskparam.Rows[0]["TaskFinishVariance"].ToString());
                }
                catch
                {
                    Variance = 0;
                }


                if (Variance < 0)
                {
                    Html += "<span class=\"text-success fw-bold\">Опережение сроков на : " + Math.Abs(Variance) + "д.</span>";
                }
                else
                {
                    if (Variance == 0)
                    {
                        Html += "<span class=\"text-primary fw-bold\"> Плановое завершение: </span>";
                    }
                    else
                    {
                        if (Variance < 5)
                        {
                            Html += "<span class=\"text-warning fw-bold\"> Отставание от сроков на: " + Variance + "д.</span>";
                        }
                        else
                        {
                            Html += "<span class=\"text-danger fw-bold\"> Отставание от сроков на: " + Variance + "д.</span>";
                        }
                    }
                }

                return Html;
            }
            public string BudjetOverLimit(string ProjID)
            {
                String Html = "";
                DataView DView = new DataView();
                DView.Table = reportData.Tables["PassPort"];

                EAC = Convert.ToDecimal(DView[0]["ApprovedBudgetForTheSupply"].ToString()) +
                     Convert.ToDecimal(DView[0]["ApprovedBudgetForWorks"].ToString()) +
                     Convert.ToDecimal(DView[0]["ApprovedContractorBudget"].ToString()) +
                     Convert.ToDecimal(DView[0]["ApprovedBudgetForMiscellaneousExpenses"].ToString());


                BAC = Convert.ToDecimal(DView[0]["ForecastBudgetForDelivery"].ToString()) +
                      Convert.ToDecimal(DView[0]["ForecastBudgetForContractors"].ToString()) +
                      Convert.ToDecimal(DView[0]["ForecastBudgetForOtherExpenses"].ToString()) +
                      Convert.ToDecimal(DView[0]["ForecastBudgetForWork"].ToString());
                Decimal DifBudjet = BAC - EAC;
                Decimal Preceed;

                if (DView[0]["Proceeds"].Equals(DBNull.Value)) Preceed = 0; else Preceed = Convert.ToDecimal(DView[0]["Proceeds"].ToString());
                Preceed = Preceed / 10;
                if (DifBudjet < 0) Html += "<span class=\"text-success fw-bold\">Экономия : " + String.Format("{0:c0}", Math.Abs(DifBudjet)) + "</span>";
                else
                {
                    if (DifBudjet == 0) { Html += "<span class=\"text-primary fw-bold\">В Бюджете "; }
                    else if (DifBudjet <= Preceed) { Html += "<span class=\"text-warning fw-bold\">Небольшое превышение: " + String.Format("{0:c0}", DifBudjet) + "</span>"; }
                    else { Html += "<span class=\"text-danger fw-bold\">Превышение бюджета: " + String.Format("{0:c0}", DifBudjet) + "</span>"; }
                }
                return Html;
            }


            public void get__Alert(string ProjID)
            { // Заменена - проверить и удалить
                DataView DView = new DataView();
                DataView DView_t = new DataView();
                DataView DView_r = new DataView();
                DView.Table = reportData.Tables["PassPort"];
                DView_t.Table = reportData.Tables["WssTrouble"];
                DView_r.Table = reportData.Tables["WssRisk"];

                DView.RowFilter = "ProjectUID = '" + ProjID + "'";
                //   Decimal ApprovedBudjet;
                //   Decimal ForecastBudjet;
                Decimal DayOverLimit;    // Превышение по срокам
                                         //Критическая проблема
                if (reportData.Tables["PassPort"].Columns["CriticalIssues"].Caption == "Да")
                {
                    isTrouble = 1;
                }
                else
                {
                    isTrouble = 0;
                };
                EAC = Convert.ToDecimal(DView[0]["ApprovedBudgetForTheSupply"].ToString()) +
                      Convert.ToDecimal(DView[0]["ApprovedBudgetForWorks"].ToString()) +
                      Convert.ToDecimal(DView[0]["ApprovedContractorBudget"].ToString()) +
                      Convert.ToDecimal(DView[0]["ApprovedBudgetForMiscellaneousExpenses"].ToString());


                BAC = Convert.ToDecimal(DView[0]["ForecastBudgetForDelivery"].ToString()) +
                      Convert.ToDecimal(DView[0]["ForecastBudgetForContractors"].ToString()) +
                      Convert.ToDecimal(DView[0]["ForecastBudgetForOtherExpenses"].ToString()) +
                      Convert.ToDecimal(DView[0]["ForecastBudgetForWork"].ToString());

                /*     BudjetOverLimit = EAC - BAC;
                     Decimal Preceed = 0;
                     if (DView[0]["Proceeds"].Equals(DBNull.Value)) { Preceed = 0; }
                     else
                     {
                         Preceed = Convert.ToDecimal(DView[0]["Proceeds"].ToString());
                     };
                     if (BudjetOverLimit < 0) BudjetOverLimits = "Экономия : " + BudjetOverLimit;
                     else
                     {
                         if (BudjetOverLimit == 0) { BudjetOverLimits = "В Бюджете : "; }
                         else if (BudjetOverLimit <= Preceed / 10) { BudjetOverLimits = "Небольшое превышение: " + BudjetOverLimit; }
                         else { BudjetOverLimits = "За пределами бюджета: " + BudjetOverLimit; }

                     }

     */

                DayOverLimit = 0;
            }



            /// <summary>
            /// Собирает DIV блок для страницы
            /// </summary>
            /// <returns>возвращяет HTML Инфоблока</returns>
            public string PrintInfoBlock(string ProjUID)
            {
                string cssstat = "alert-success";
                string AriaLabel = "Success:";


                var values = new object[4];
                values[0] = TroubleCount(ProjUID).ToString();
                values[1] = TimeOverLimit(ProjUID).ToString();
                values[2] = RisksCount(ProjUID).ToString();
                values[3] = BudjetOverLimit(ProjUID).ToString();

                string Page = string.Format(@"<div> <div> <table> <tr><td>{0}</td> <td></td><td>{1}</td></tr><tr><td>{2}</td><td></td><td>{3}</td></tr></table> </div>	</div>", values);



                return Page;
            }



            /// <summary>
            /// Генерирует Первый блок Статус-Отчета
            /// </summary>
            /// <returns></returns>
            /// 
            public string getFirstBlock(string ProjID)
            {
                DataView DView = new DataView();

                DView.Table = reportData.Tables["PassPort"];
                DView.RowFilter = "ProjectUID = '" + ProjID + "'";

                string html = "<div class =\"blockheader\"><h2>";
                if (DView[0]["LeadName"].Equals(DBNull.Value)) html += ""; else {
                
                html+="<a href=\"https://someserver/PWA/project%20detail%20pages/statusreport.aspx?projuid=";
                html+= DView[0]["ProjectUID"];
                html+="&ret=0\">";
                //ProjID
                // /project%20detail%20pages/statusreport.aspx?projuid=fce03704-d1e0-ec11-9892-dca2666d210e&ret=0
                
                html += DView[0]["LeadName"];
                               
                html+="</a>";
                } //(DView[0]["LeadName"].

                html += " </h2></div> " +
                " <div class =\"blockheader\"> " +
            //    " <div class=\"bg-light\"> " + PrintInfoBlock(ProjID) + "</div></div>" +
                //   PrintInfoBlock(ProjID) +

                "<div class =\"blockheader\"><h3>1. Общая информация</h3></div>" +
                " <div class=\"blockbody\">" +
                "<div class=\"subblock2\">";

                html += "<span class=\"ulabel\">ЛИД: </span>";
                if (DView[0]["LeadID"].Equals(DBNull.Value)) html += ""; else html += DView[0]["LeadID"];
                html += " <br>" +
        "<span class=\"ulabel\">Заказчик:</span> ";
                if (DView[0]["Customer"].Equals(DBNull.Value)) html += ""; else html += DView[0]["Customer"];

                html += "<br> " +
        "<span class=\"ulabel\">Сейл:</span> ";
                if (DView[0]["Sales"].Equals(DBNull.Value)) html += ""; else html += DView[0]["Sales"];


                html += "<br>" + "<span class=\"ulabel\">РП:</span> ";
                if (DView[0]["PM"].Equals(DBNull.Value)) html += ""; else html += DView[0]["PM"];

                html += "<br><span class=\"ulabel\">Подрядчики:</span> ";
                if (DView[0]["Contractor"].Equals(DBNull.Value)) html += ""; else html += DView[0]["Contractor"];
                html += "<br>" +
                "<span class=\"ulabel\">ГИП:</span> ";

                if (DView[0]["GIP"].Equals(DBNull.Value)) html += ""; else html += DView[0]["GIP"];
                html += "<br>" +
                 "<span class=\"ulabel\">Стоимость договора:</span> ";

                if (DView[0]["Proceeds"].Equals(DBNull.Value)) html += ""; else html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["Proceeds"].ToString()));
                html += "<br>" +
                 "<span class=\"ulabel\">Выполнение:</span> ";

                if (DView[0]["ProjectPercentWorkCompleted"].Equals(DBNull.Value)) html += ""; else html += DView[0]["ProjectPercentWorkCompleted"];
                html += "%</p>" +
                "</div>" +
                 "<div class=\"subblock2\">" +
                 "<span class=\"ulabel\">Описание проекта:</span>" +
                 "<p class=\"ucoment_text\">";

                if (DView[0]["ProjectDescription"].Equals(DBNull.Value)) html += ""; else html += DView[0]["ProjectDescription"];
                html += "</p>" +
               "</div></div>" +
                "<div class=\"blockbody\">" +
                "<span class=\"ulabel\">Общий статус проекта:</span>" +
                "<p class=\"ucoment_text\">";

                if (DView[0]["ProjectGeneralStatus"].Equals(DBNull.Value)) html += ""; else html += DView[0]["ProjectGeneralStatus"];
                html += "</p>";
                // "</div>" +

                html += "<div align=\"right\" width=\"90%\">" +
                "Обновлено: " +
                String.Format("{0:d}", Convert.ToDateTime(
                    DView[0]["ProjectModifiedDate"].ToString())) + "г.";
                html += "</div>";
                html += "</div>";
                     html += "</div>";
                return html;
            }
            public string getSecondBlock(string ProjID)
            {
                string stopdeal = "Обязательства перед заказчиком выполнены";
                string startDeal = "Договор с заказчиком заключен";
                string startTechSupp = "Проект передан на ТП-Гарантию";

                DataView DView1 = new DataView();
                DView1.Table = reportData.Tables["PassPort"];
                DView1.RowFilter = "ProjectUID = '" + ProjID + "'";
                DataTable dtstopDeal = GetMinestones(ProjID, stopdeal);
                DataTable dtstartDeal = GetMinestones(ProjID, startDeal);
                DataTable dtstartTechSupp = GetMinestones(ProjID, startTechSupp);


                String Html;
                Html = "<div class=\"blockheader\">" +
                        "<h3>2. Соблюдение сроков проекта</h3>" + " </div>";
                Html += "<div class=\"blockbody\">" +
                        "<div class=\"subblock\">" +
                        "<span class=\"ulabel\">Дата заключения договора: </span>";

                /*  if (DView1[0]["DateOfConclusionContract"].Equals(DBNull.Value))
                      Html += "";
                  else
                      Html += String.Format("{0:d}", Convert.ToDateTime(DView1[0]["DateOfConclusionContract"].ToString())) + "г.";
  */
                try
                {
                    Html += String.Format("{0:d}", Convert.ToDateTime(
                    dtstartDeal.Rows[0]["TaskBaseline0FinishDate"].ToString())) + "г.";
                }
                catch
                {
                    Html += "";
                }


                Html += "<br>" +
                "<span class=\"ulabel\">Дата окончания по договору: </span>";

                try
                {
                    Html += String.Format("{0:d}", Convert.ToDateTime(
                    dtstopDeal.Rows[0]["TaskBaseline0FinishDate"].ToString())) + "г.";
                }
                catch
                {
                    Html += "";
                }



                Html += "<br> </div>" +
                "<div class=\"subblock\">" +
                "<span class=\"ulabel\">Дата прогнозного окончания: </span> ";




                try
                {
                    Html += String.Format("{0:d}", Convert.ToDateTime(
                    dtstopDeal.Rows[0]["TaskFinishDate"].ToString())) + "г.";
                }
                catch
                {
                    Html += "";
                }

                Html += "<br><span class=\"ulabel\">Отставание: </span>";
                try
                {
                    Html += dtstopDeal.Rows[0]["TaskFinishVariance"].ToString() + " д.";
                }
                catch
                {
                    Html += "";
                }
                Html += "</div>" +
            //      "<div class=\"subblock\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>" +
            "</div>";

                DataView DView2 = new DataView();
                DView2.Table = reportData.Tables["Milestone"];
                // DView2.Table.Columns["ProjectUID"].
                DView2.RowFilter = "ProjectUID = '" + ProjID + "'";
                DView2.Table.Columns["TaskIndex"].ColumnName = "№";
                DView2.Table.Columns["TaskName"].ColumnName = "Наименование Вехи";
                DView2.Table.Columns["TaskBaseline0FinishDate"].ColumnName = "Базовое окончание";

                DView2.Table.Columns["TaskFinishDate"].ColumnName = "Прогнозное окончание";
                DView2.Table.Columns["TaskActualFinishDate"].ColumnName = "Фактическое окончание";
                DView2.Table.Columns["TaskFinishVariance"].ColumnName = "Смещение";
                DView2.Table.Columns["CTIMilestoneComment"].ColumnName = "Коментарий";
                DView2.Table.Columns.Remove("ProjectUID");




                Html += "<div class=\"blockbody\">" +
                   " <div>";

                Html += "<table class=\" caption-top table table-bordered\"" +

                   "style=\"width=90%\"" +

                    "id=\"Mileslists\" > " +
                "<caption> Ключевые вехи </caption>";

                Html += "<thead class=\" \"><tr class=\"table-primary\">";
                //  for (int i = 0; i < DView2.Table.Columns.Count; i++)
                //      Html += "<th scope=\"col\">" + DView2.Table.Columns[i].ColumnName + "</th>";
                Html += "<th scope=\"col\"  style=\"width:30px\">" + DView2.Table.Columns[0].ColumnName + "</th>";
                Html += "<th scope=\"col\">" + DView2.Table.Columns[1].ColumnName + "</th>";
                Html += "<th scope=\"col\" style=\"width:80px\">" + DView2.Table.Columns[2].ColumnName + "</th>";
                Html += "<th scope=\"col\" style=\"width:80px\">" + DView2.Table.Columns[3].ColumnName + "</th>";
                Html += "<th scope=\"col\" style=\"width:80px\">" + DView2.Table.Columns[4].ColumnName + "</th>";
                Html += "<th scope=\"col\" style=\"width:80px\">" + DView2.Table.Columns[5].ColumnName + "</th>";
                Html += "<th scope=\"col\">" + DView2.Table.Columns[6].ColumnName + "</th>";
                Html += "</tr></thead>" +
                        "<tbody  class=\"table-striped\">";

                if (DView2.Table.Rows.Count > 0)
                {
                    for (int i = 0; i < DView2.Table.Rows.Count; i++)
                    {
                        Html += "<tr >";
                        //String.Format("{0:D}", Convert.ToDateTime(dtable.Rows[i]["DueDate"].ToString()))
                        Html += "<th scope=\"row\">" +
                            DView2.Table.Rows[i]["№"].ToString() + "</th>";
                        Html += "<td>" +
                            DView2.Table.Rows[i]["Наименование Вехи"].ToString() + "</td>";
                        Html += "<td>";
                        try
                        {
                            Html += String.Format("{0:d}",
                                    Convert.ToDateTime(
                                        DView2.Table.Rows[i]["Базовое окончание"].ToString()));
                        }
                        catch
                        {
                            Html += "";
                        }

                        Html += "</td>";
                        Html += "<td>";
                        //    try
                        //   {
                        //       Html += String.Format("{0:D}", Convert.ToDateTime(
                        ////            DView2.Table.Rows[i]["Прогнозное окончание"].ToString()));
                        ////    }
                        //    catch
                        //    {
                        //        Html += "";
                        //    }
                        Html += DView2.Table.Rows[i]["Прогнозное окончание"] != null ? String.Format("{0:d}", Convert.ToDateTime(DView2.Table.Rows[i]["Прогнозное окончание"].ToString())) : "";
                        Html += "</td>";
                        Html += "<td>";

                        try
                        {
                            Html += String.Format("{0:d}", Convert.ToDateTime(
                               DView2.Table.Rows[i]["Фактическое окончание"].ToString()));
                        }
                        catch
                        {
                            Html += "";
                        }
                        Html += "</td>";

                        Html += "<td>";

                        Html += Convert.ToInt32(Convert.ToDecimal(DView2.Table.Rows[i]["Смещение"].ToString())) + "</td>";
                        Html += "<td>" +
                            DView2.Table.Rows[i]["Коментарий"] + "</td>";


                        Html += "</tr>";
                    }
                }
                else
                {
                    Html += "<tr  scope=\"col\"><td colspain=\"" + DView2.Table.Columns.Count + "\">" +
                            "Вехи не обозначены" +
                            "</td></tr>";
                }

                Html += "</table>";
                Html += "</div> </div>";



                Html += "<div class=\"blockbody\">" +
                       "<span class=\"ulabel\">Комментарий по отклонению от базового плана:</span>" +
                       "<p class=\"ucoment_text\">" +
                       reportData.Tables["PassPort"].Rows[0]["CommentsOnDeviationsFromBasicPlan"] +
                       "</p>" +
                       "</div>";

                return Html;
            }


            public string getThirdBlock(string ProjID)
            {
                DataView DView = new DataView();
                DView.Table = reportData.Tables["PassPort"];
                DView.RowFilter = "ProjectUID = '" + ProjID + "'";
                String Html = "<div class=\"blockheader\">" +
                    "<h3>3. Соблюдение бюджета проекта</h3>" +
                    "</div>" +
                    "<div class=\"blockbody\">" +
                    "<p><span class=\"ulabel\">Утвержденный бюджет проекта: (EAC)</span> <span> " +
                    String.Format("{0:c0}", Convert.ToDecimal(this.EAC)) +
                    " без НДС.</span></p>" +
                    "<p><span class=\"ulabel\">Прогнозный бюджет проекта: (BAC)</span> <span> " +
                    String.Format("{0:c0}", Convert.ToDecimal(this.BAC)) +
                    " без НДС.</span></p></div>" +
                    "<div class=\"blockbody\">" +
                    "<div class=\"subblock_2\">" +
                    "<div class=\"sbheader bg-info\">" +
                    "<span>Оборудование, материалы, лицензии</span></div>" +
                    "<div class=\"sbbody\">" +
                    "<div class=\"sb2\">" +
                    "<div class=\"sb2header bg-light\">" +
                    "<span>План</span></div>" +
                    "<div class=\"sb2body\">" +
                    "<span>";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ApprovedBudgetForTheSupply"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "&nbsp;</span></div>" +
                "</div></div>";
                /*        Html += "<div class=\"sbbody\">" +
                         "<div class=\"sb2\">" +
                         "<div class=\"sb2header bg-light\">" +
                         "<span>Прогнозный бюджет</span></div>" +
                         "<div class=\"sb2body\">" +
                         "<span>";
                         try
                         {
                             Html +=
                                 String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ForecastBudgetForDelivery"].ToString()));
                         }
                         catch
                         {
                             Html += "";
                         }
                         Html += "&nbsp;</span></div>" +
                             "</div></div>" ;
                             */
                Html += "<div class=\"sbbody\">" +
                   "<div class=\"sb2\">" +
                   "<div class=\"sb2header bg-light\">" +
                   "<span>Факт</span>" +
                   "</div>" +
                   "<div class=\"sb2body\">" +
                   "<span>";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ActualDeliveryCosts"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "&nbsp;</span></div>" +
                "</div></div></div>" +
                "<div class=\"subblock\">" +
                "<div class=\"sbheader bg-info\">" +
                "<span>Стоимость времени сотрудников</span>" +
                "</div>" +
                "<div class=\"sbbody\">" +
                "<div class=\"sb2\">" +
                "<div class=\"sb2header bg-light\">" +
                "<span>План</span>" +
                "</div>" +
                "<div class=\"sb2body\">" +
                "<span>";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ApprovedBudgetForWorks"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "&nbsp;</span></div>" +
                "<div class=\"sb2body\">" +
                "<span> ";
                try
                {
                    Html += String.Format("{0:N0}", Convert.ToInt32(DView[0]["ApprovedLaborCosts"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "ч.</span>" +
        " </div></div></div>" +
        "<div class=\"sbbody\">" +
        "<div class=\"sb2\">" +
        "<div class=\"sb2header bg-light\">" +
        "<span>Прогноз</span>" +
                        "</div>" +
        "<div class=\"sb2body\">" +
        "<span> ";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ForecastBudgetForWork"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "&nbsp;</span></div>" +
                "<div class=\"sb2body\">" +
                "<span> ";
                try
                {
                    Html += String.Format("{0:N0}", Convert.ToInt32(DView[0]["ProjectWork"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "ч.</span></div></div></div>" +
                "<div class=\"sbbody\">" +
                "<div class=\"sb2\">" +
                "<div class=\"sb2header bg-light\">" +
                "<span>Факт</span>" +
                "</div>" +
                "<div class=\"sb2body\">" +
                "<span> ";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ActualCostsWork"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "&nbsp;</span></div>" +
                "<div class=\"sb2body\">" +
                "<span> ";
                try
                {
                    Html += String.Format("{0:N0}", Convert.ToInt32(DView[0]["ProjectActualWork"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "ч.</span></div></div></div></div>" +
                "<div class=\"subblock_2\">" +
                "<div class=\"sbheader bg-info\">" +
                "<span>Работы/Услуги</span></div>" +
                "<div class=\"sbbody\">" +
                "<div class=\"sb2\">" +
                "<div class=\"sb2header bg-light\">" +
                "<span>План</span></div>" +
                "<div class=\"sb2body\">" +
                "<span> ";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ApprovedContractorBudget"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += "&nbsp;</span></div></div></div>" +
                "<div class=\"sbbody\">" +
                "<div class=\"sb2\">";
                /*  Html += "<div class=\"sb2header bg-light\">" +
                  "<span>Прогнозный бюджет</span></div>" +
                  "<div class=\"sb2body\">" +
                  "<span> ";
                  try
                  {
                      Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ForecastBudgetForContractors"].ToString()));
                  }
                  catch
                  {
                      Html += "";
                  }
                  Html += "&nbsp;</span></div>;
                  */
                Html += "</div></div>";

                Html += "<div class=\"sbbody\">" +
                "<div class=\"sb2\">" +
                "<div class=\"sb2header bg-light\"><span>Факт</span></div>" +
                "<div class=\"sb2body\"><span>";
                try
                {
                    Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ActualCostsContractors"].ToString()));
                }
                catch
                {
                    Html += "";
                }
                Html += " &nbsp;</span></div></div></div></div>";
                /*      //////////////////////////////////////////////
                      Html +="<div class=\"subblock\">" +
                      "<div class=\"sbheader bg-info\">" +
                      "<span>Прочие расходы</span></div>" +
                      "<div class=\"sbbody\">" +
                      "<div class=\"sb2\">" +
                      "<div class=\"sb2header bg-light\">" +
                      "<span>Утвержденный бюджет</span></div>" +
                      "<div class=\"sb2body\">" +
                      "<span> ";
                      try
                      {
                          Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ApprovedBudgetForMiscellaneousExpenses"].ToString()));
                      }
                      catch
                      {
                          Html += "";
                      }
                      Html += "&nbsp;</span></div></div></div>" +
                      "<div class=\"sbbody\">" +
                      "<div class=\"sb2\">" +
                      "<div class=\"sb2header bg-light\">" +
                      "<span>Прогнозный бюджет</span></div>" +
                      "<div class=\"sb2body\">" +
                      "<span> ";
                      try
                      {
                          Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ForecastBudgetForOtherExpenses"].ToString()));
                      }
                      catch
                      {
                          Html += "";
                      }
                      Html += "&nbsp;</span></div></div></div>" +
                      "<div class=\"sbbody\">" +
                      "<div class=\"sb2\">" +
                      "<div class=\"sb2header bg-light\"><span>Фактические затраты</span></div>" +
                      "<div class=\"sb2body\"> <span>";
                      try
                      {
                          Html += String.Format("{0:c0}", Convert.ToDecimal(DView[0]["ActualCostsOtherExpenses"].ToString()));

                      }
                      catch
                      {
                          Html += "";
                      }
                      Html += " &nbsp;</span></div></div></div></div>";
                      */
                Html += "</div>" +
                "<div class=\"blockbody\">" +
                "<span class=\"ulabel\">Комментарий по отклонению от бюджета проекта:</span>" +
                "<p class=\"ucoment_text\">" +
                DView[0]["budjetcoment"] +
                "</p></div>";

                return Html;
            }
            public string getFourthBlock(string ProjID)
            {
                DataView DView1 = new DataView();
                DataView DView2 = new DataView();
                //  case "TaskOld": queuenum = 3; break;
                //   case "TaskTodo": queuenum = 4; break;
                DView1.Table = reportData.Tables["TaskOld"];
                DView1.RowFilter = "ProjectUID = '" + ProjID + "'";
                DView2.Table = reportData.Tables["TaskTodo"];
                DView2.RowFilter = "ProjectUID = '" + ProjID + "'";


                String Html = "<div class=\"blockheader\" >" +
                        "<h3>4. Контроль выполения работ</h3>" +
                        "</div>" +
                        "<div class=\"blockbody\">" +
                        "<div class=\"w-75 p-3\">" +
                        "<table " +
                        "class=\" caption-top table table-bordered\" " +
                        ">" +
                        "<caption>Сделано за прошлую неделю</caption>" +
                        "<thead>" +
                        "<tr class=\"table-primary\">" +
                        "<th style=\"width:40px\"scope=\"col\">№</th>" +
                        "<th scope=\"col\">Задачи</th>" +
                        "</tr></thead><tbody>";

                if (DView1.Table.Rows.Count > 0)
                {
                    for (int dv1idx = 0; dv1idx < DView1.Table.Rows.Count; dv1idx++)
                    {
                        Html += "<tr><th>" +
                                     DView1.Table.Rows[dv1idx]["TaskIndex"] +
                                "</th>" +
                                "<td>" +
                                     DView1[dv1idx]["TaskName"].ToString() +
                                "</td></tr>";
                    }
                }
                else
                {
                    Html += "<tr  align=\"left\"><td colspan=\"2\">Нет задач завершенных на прошлой неделе</td></tr>";
                }

                Html += "</tbody></table></div></div>";
                Html += "<div class=\"blockbody\"> " +
                    "<div class=\"w-75 p-3\">" +
                "<table class=\" caption-top table table-bordered\" id=\"Todo\" >" +
                "<caption> План на текущую неделю </caption>" +
                "<thead><tr class=\"table-primary\" > " +
                "<th  style=\"width:40px\" scope=\"col\">№</th>" +
                "<th scope=\"col\">Задачи</th>" +
                "</tr></thead><tbody>";


                if (DView2.Table.Rows.Count > 0)
                {
                    for (int dv2idx = 0; dv2idx < DView2.Table.Rows.Count; dv2idx++)
                    {
                        Html += "<tr align=\"left\"><th class=\"row\">" +
                                       DView2[dv2idx]["TaskIndex"].ToString() +
                                "</td>" +
                                "<td>" +
                                       DView2[dv2idx]["TaskName"].ToString() +
                                "</td></tr>";
                    }
                }
                else
                {
                    Html += "<tr><td colspan=\"2\">Нет задач на эту неделю</td></tr>";
                }
                Html += "</tbody></table></div></div>";

                return Html;
            }

            public string getFithBlock(string ProjID)
            {

                DataView DView1 = new DataView();
                DataView DView2 = new DataView();

                DView1.Table = reportData.Tables["WssTrouble"];
                DView1.RowFilter = "ProjectUID = '" + ProjID + "'";
                DView2.Table = reportData.Tables["WssRisk"];
                DView2.RowFilter = "ProjectUID = '" + ProjID + "'";

                String Html = "<div class=\"blockheader\">" +
                        "<h3>5. Риски и проблемы</h3>" +
                        "</div>" +
                        "<div class=\"blockbody\">" +
                        "<div>" +
                        "<table class=\" caption-top table table-bordered\"  id=\"Troubles\" >" +
                        "<caption>Проблемы в проекте</caption>" +
                        "<thead><tr class=\"table-primary\">" +
                        "<th scope=\"col\">Краткое описание проблемы</th>" +
                        "<th scope=\"col\">Описание проблемы</th>" +
                        "<th scope=\"col\">Мероприятия по решению проблемы</th>" +
                        "<th scope=\"col\">Ответственный</th></tr></thead>" +
                        "<tbody>";

                if (DView1.Table.Rows.Count > 0)
                {
                    for (int dv2idx = 0; dv2idx < DView1.Table.Rows.Count; dv2idx++)
                    {
                        Html += "<tr align=\"left\">" +
                            "<td>" + DView1[dv2idx]["Title"].ToString() + "</td>" +
                            "<td>" + DView1[dv2idx]["Description"].ToString() + "</td>" +
                            "<td>" + DView1[dv2idx]["ContingencyPlan"].ToString() + "</td>" +
                            "<td>" + DView1[dv2idx]["AssignedTo"].ToString() + "</td>" +
                                "</tr>";

                    }
                }
                else
                {
                    Html += "<tr><td colspan=\"4\">Нет активных Проблем</td></tr>";
                }

                Html += "</tbody>" +
                "</table> </div></div>";
                Html += "<div class=\"blockbody\"> <div>" +
                " <table class=\" caption-top table table-bordered\"  id=\"Risks\">" +
                "<caption>Риски в проекте</caption><thead>" +
                "<tr class=\"table-primary\" >" +
                "<th scope=\"col\">Краткое описание риска</th>" +
                "<th scope=\"col\">Описание Риска</th>" +
                "<th scope=\"col\">Мероприятия по минимизации риска</th>" +
                "<th scope=\"col\">Ответственный</th></tr></thead><tbody>";
                if (DView2.Table.Rows.Count > 0)
                {
                    for (int dv2idx = 0; dv2idx < DView2.Table.Rows.Count; dv2idx++)
                    {
                        Html += "<tr align=\"left\">" +

                            "<td>" + DView2[dv2idx]["Title"].ToString() + "</td>" +
                            "<td>" + DView2[dv2idx]["Description"].ToString() + "</td>" +
                            "<td>" + DView2[dv2idx]["MitigationPlan"].ToString() + "</td>" +
                            "<td>" + DView2[dv2idx]["AssignedTo"].ToString() + "</td>" +
                          "</tr>";
                    }
                }
                else
                {
                    Html += "<tr><td colspan=\"4\">Нет активных рисков</td></tr>";
                }


                Html += "</tbody></table></div>";

                return Html;
            }


            /// <summary>
            /// Получение активных проектов
            /// </summary>
            /// <param name="ProjUID"></param>
            /// 

            public List<string> getProjectCases(string CaseName)
            {
                List<string> CaseProjects =new List<string>() ;

                DataView DView = new DataView();

                DView.Table = reportData.Tables["LidInCases"];


                ///     view.RowFilter = "City = 'Berlin'";
                ///  view.RowStateFilter = DataViewRowState.ModifiedCurrent;
                ///  view.Sort = "CompanyName DESC";


                DView.RowFilter = "portfolio = '" + CaseName+"'";
                DView.Sort = "portfolio DESC";
                foreach (DataRowView drv in DView) {
                    CaseProjects.Add(drv["ProjectUID"].ToString());

                }


                return CaseProjects;
            }

            public string printCases(string casename)
            {
                string sPage = string.Empty;
                List<string> cases;
                cases = getProjectCases(casename);//Убрать список уже есть


                foreach (string ProgUId in cases)
                {
                    sPage += "<div class=\"Block\" name=\"SRBlok1\" id=\"SRBlok1\">";
                    sPage+=getFirstBlock(ProgUId);
					sPage+="</div>";
                }
                sPage += cases.Count.ToString();

                return sPage;
            }
            public void getActiveProjects(string ProjUID)
            {

            }

            public static string ConvertDataTableToHTML(DataView DV)
            {
                String html;

                //add header row
                html = "<thead><tr>";
                for (int i = 0; i < DV.Table.Columns.Count; i++)
                    html += "<td>" + DV.Table.Columns[i].ColumnName + "</td>";
                html += "</tr></thead>" +
                        "<tbody>";
                //add rows
                if (DV.Table.Rows.Count > 0)
                {
                    for (int i = 0; i < DV.Table.Rows.Count; i++)
                    {
                        html += "<tr>";
                        for (int j = 0; j < DV.Table.Columns.Count; j++)
                            html += "<td>" + DV.Table.Rows[i][j].ToString() + "</td>";
                        html += "</tr>";
                    }
                }
                else
                {
                    html += "<tr><td colspain=\"" + DV.Table.Columns.Count + "\">" +
                            "Вехи не обозначены" +
                            "</td></tr>";
                }
                html += "</tbody></table>";
                return html;
            }

            /// <summary>
            /// Инициатор класса
            /// </summary>
            /// 
            public StatusReport(string ConnString)
            {
                this.sqlConn = new SqlConnection(ConnString);
                this.sqlConn.ConnectionString = ConnString;
                this.Portfolio = new List<string>();
                this.PrjsUID = new List<string>();
                this.PrjsUID = new List<string>();
                this.Portfolio = new List<string>();
                //     SqlCommand cmd = new SqlCommand();
                this.reportData = new DataSet();
            }
            public StatusReport(string ConnString, List<string> ProjID)
            {
                this.sqlConn = new SqlConnection(ConnString);
                this.Portfolio = new List<string>();
                this.PrjsUID = new List<string>();
                this.PrjsUID=ProjID;
                this.sqlConn.ConnectionString = ConnString;

                this.reportData = new DataSet();
            }

        }


        protected void Page_Load(Object sender, EventArgs e)
        {

            ///
            /// Настройка класса


            List<string> ProjID = new List<string>();


            ProjID.Add(Request.QueryString["ProjUid"]);
            //ProjID = "15f93dd2-6bfe-eb11-9671-683e26c70d5c";

            string sPage = "<div  style=\"font-size:14px\"  id=\"content\"> ";

            string DBConString = "server=someservert; uid=someuser; pwd=somepass; database=somedb";
            // string DBConString = ConfigurationManager.ConnectionStrings["PWAConnectionString"].ConnectionString;
            StatusReport sReport = new StatusReport(DBConString, ProjID);
            sReport.StopDeal = "Обязательства перед заказчиком выполнены";

            sReport.StartDeal = "Договор с заказчиком заключен";
            sReport.Techsupport = "Проект передан на ТП-Гарантию";



            ///
            ///  загрузка данных
            ///
            //    sReport.PullData("PassPort");
            sReport.PullData("LidInCases");
            sReport.PullData("Portfolio");
      

            ///
            ///  представление данных
            ///
            DataView DView = new DataView();
            DView.Table = sReport.reportData.Tables["Portfolio"];

            sPage += "<nav>";
            sPage += "<div class=\"nav nav-tabs\" id=\"nav-tab\" role=\"tablist\">";
            DataTable tCases = sReport.reportData.Tables["Portfolio"];
            string key = string.Empty;
            string keylat = string.Empty;
            for (int cix = 0; cix < DView.Count; cix++)
            {
                //  sPage+= row.ToString(); DView[0]["ApprovedBudgetForTheSupply"].ToString()
                key = DView[cix]["portfolio"].ToString();
                keylat = sReport.ConvertToLatin(key.ToLower());
                sPage += "<button class=\"nav-link";
                if (cix == 0) { sPage += " active "; }
                sPage +="\" id=\"nav-" +   ////  active
                keylat +
                "-tab\" data-bs-toggle=\"tab\" data-bs-target=\"#nav-" +
                keylat +
                "\" type=\"button\" role=\"tab\" aria-controls=\"nav-" + keylat + "\" aria-selected=\"true\">" +
                key +
                "</button>";
            }

            sPage += "</div>";
            sPage += "</nav>";
            sPage +="<div class=\"tab-content\" id=\"nav-tabContent\">";
           
            for (int cix = 0; cix < DView.Count; cix++) {
                key = DView[cix]["portfolio"].ToString();
                keylat = sReport.ConvertToLatin(key.ToLower());
                sPage += " <div class=\"tab-pane ";
                if (cix == 0) { sPage += " show active "; }
                sPage += " fade\" id=\"nav-" + keylat + "\" role=\"tabpanel\" aria-labelledby=\"nav-" + keylat + "-tab\">";
                sReport.PrjsUID  = sReport.getProjectCases(key);
                sReport.PullData("PassPort");

              //  sPage += "<div class=\"Block\" name=\"SRBlok1\" id=\"SRBlok1\">";

                sPage += sReport.printCases(key);
                //    sPage += sReport.getFirstBlock(ProjID);
             //   sPage += "</div>";//Block
                sPage += "</div>";//nav-
                sReport.reportData.Tables.Remove("PassPort");
            }
            sPage += "</div>"; //nav-tabContent



            ReportBody.InnerHtml = sPage;


        }

    </script>




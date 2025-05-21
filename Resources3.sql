SELECT
    (
	 SELECT  ResourceName 	
	 from [pjrep].[MSP_EpmResource_UserView]  
	 where [pjrep].[MSP_EpmResource_UserView].[ResourceUID] = merbduv.[ResourceUID]) as ResourceName,
	   CategoryWorks AS 'Категория ТрЗТ',
       [Projectname],
	   [TaskName],
	   CAST(CAST((CAST(YEAR(merbduv.TimeByDay) AS VARCHAR(4))+'-'+ CAST(MONTH(merbduv.TimeByDay) AS VARCHAR(2))+'-1') AS VARCHAR(10)) AS DATE) AS MonthDate,
  --     merbduv.Capacity as [ResourceCapacity],
       ISNULL(AssignmentTable.AllocatedCapacity,0) as [AllocatedCapacity],
	   AssignmentTable2.MonthCapacity,
       (SELECT [Подразделения] FROM [pjrep].MSP_EpmResource_UserView WHERE [pjrep].MSP_EpmResource_UserView.ResourceUID = merbduv.ResourceUID ANd [Подразделения] is not NULL)	 as [Division],
       (SELECT  EpmResUV.ResourceNTAccount FROM [pjrep].MSP_EpmResource_UserView EpmResUV WHERE EpmResUV.ResourceUID = merbduv.ResourceUID )	 as [ResourceNTAccoun]

				-------//---------
       FROM
         [pjrep].MSP_EpmResourceByDay_UserView merbduv
       LEFT OUTER JOIN
	   ----------------------
(SELECT
	CAST(CAST(CAST(YEAR(resbd.TimeByDay)AS VARCHAR(4))+'-'+CAST(MONTH(resbd.TimeByDay)AS VARCHAR(2))+'-1' AS VARCHAR(10)) AS DATE) AS MonthDate,
	mer.ResourceUID,
	sum(resbd.Capacity) AS MonthCapacity
FROM
	[pjrep].MSP_EPMResourceByDay_UserView resbd
	JOIN [pjrep].MSP_EPMResource mer
		ON resbd.ResourceUID = mer.ResourceUID
GROUP BY
	CAST(CAST(CAST(YEAR(resbd.TimeByDay)AS VARCHAR(4))+'-'+CAST(MONTH(resbd.TimeByDay)AS VARCHAR(2))+'-1' AS VARCHAR(10)) AS DATE),
	mer.ResourceUID
	) AS AssignmentTable2
	ON AssignmentTable2.ResourceUID = merbduv.ResourceUID
      AND AssignmentTable2.MonthDate = CAST(CAST((CAST(YEAR(merbduv.TimeByDay) AS VARCHAR(4))+'-'+ CAST(MONTH(merbduv.TimeByDay) AS VARCHAR(2))+'-1') AS VARCHAR(10)) AS DATE)
	   -------------------------
	    LEFT OUTER JOIN
	   ------------------------
       (
         SELECT
             MSP_EpmAssignment_UserView.ResourceUID, 
			 CAST(CAST((CAST(YEAR(AssBdUv.TimeByDay) AS VARCHAR(4))+'-'+ 
					CAST(MONTH(AssBdUv.TimeByDay) AS VARCHAR(2))+'-1') AS VARCHAR(10)) AS DATE) AS MonthDate,

             SUM(AssBdUv.AssignmentCombinedWork) as [AllocatedCapacity],
             [pjrep].MSP_EpmProject_UserView.[категория трудозатрат] as CategoryWorks,
			 [pjrep].MSP_EpmProject_UserView.ProjectName as ProjectName,
			[pjrep].MSP_EpmTask_UserView.TaskName as TaskName

           FROM
             [pjrep].MSP_EpmAssignment_UserView 
           INNER JOIN
                 [pjrep].MSP_EpmAssignmentByDay_UserView AssBdUv
              ON MSP_EpmAssignment_UserView.AssignmentUID = AssBdUv.AssignmentUID
                 AND MSP_EpmAssignment_UserView.ProjectUID = AssBdUv.ProjectUID
                AND MSP_EpmAssignment_UserView.TaskUID = AssBdUv.TaskUID
			Inner join
				[pjrep].MSP_EpmProject_UserView
				on			
				MSP_EpmAssignment_UserView.ProjectUID = [pjrep].MSP_EpmProject_UserView.ProjectUID
			Inner join
				[pjrep].MSP_EpmTask_UserView
				on			
				AssBdUv.TaskUID = [pjrep].MSP_EpmTask_UserView.TaskUID			
	     
             WHERE
               AssBdUv.TimeByDay BETWEEN
                 CONVERT(DATETIME, DATEADD(month, - 2, CURRENT_TIMESTAMP), 102)
                 AND CONVERT(DATETIME, DATEADD(month, 6, CURRENT_TIMESTAMP), 102)
             GROUP BY
                [pjrep].MSP_EpmAssignment_UserView.ResourceUID,
				CAST(CAST((CAST(YEAR(AssBdUv.TimeByDay) AS VARCHAR(4))+'-'+ 
					CAST(MONTH(AssBdUv.TimeByDay) AS VARCHAR(2))+'-1') AS VARCHAR(10)) AS DATE),
				[pjrep].MSP_EpmProject_UserView.[категория трудозатрат],
				[pjrep].MSP_EpmProject_UserView.ProjectName,
				[pjrep].MSP_EpmTask_UserView.TaskName
				
			
          ) AS AssignmentTable
                   ON AssignmentTable.ResourceUID = merbduv.ResourceUID
                      AND AssignmentTable.MonthDate = CAST(CAST((CAST(YEAR(merbduv.TimeByDay) AS VARCHAR(4))+'-'+ CAST(MONTH(merbduv.TimeByDay) AS VARCHAR(2))+'-1') AS VARCHAR(10)) AS DATE)

 --------------
          WHERE
              (merbduv.TimeByDay > CONVERT(DATETIME, DATEADD(month, - 1, CURRENT_TIMESTAMP), 102))
    AND (merbduv.TimeByDay < CONVERT(DATETIME, DATEADD(month, 12, CURRENT_TIMESTAMP), 102)) 
	
	GROUP BY 
	merbduv.ResourceUID,
	CategoryWorks,
	CAST(CAST((CAST(YEAR(merbduv.TimeByDay) AS VARCHAR(4))+'-'+ CAST(MONTH(merbduv.TimeByDay) AS VARCHAR(2))+'-1') AS VARCHAR(10)) AS DATE),
	ProjectName,
	TaskName,
    merbduv.Capacity,
	AssignmentTable2.MonthCapacity,
	AssignmentTable.AllocatedCapacity
	order by AssignmentTable.AllocatedCapacity desc
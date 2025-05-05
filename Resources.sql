SELECT
    (
	 SELECT 
	     ResourceName
	   from [pjrep].[MSP_EpmResource_UserView]  
       where [pjrep].[MSP_EpmResource_UserView].[ResourceUID] = [pjrep].[MSP_EpmResourceByDay_UserView].[ResourceUID]) as [ResourceName],
             [pjrep].[MSP_EpmResourceByDay_UserView].TimeByDay as [Date],
             [pjrep].MSP_EpmResourceByDay_UserView.Capacity as [ResourceCapacity],
             ISNULL(AssignmentTable.AllocatedCapacity,0) as [AllocatedCapacity],
		    [Projectname],
			[TaskName],
             [pjrep].MSP_EpmResourceByDay_UserView.Capacity-ISNULL(AssignmentTable.AllocatedCapacity,0) as [Availability], 
             (
				SELECT [Подразделения]
				from [pjrep].MSP_EpmResource_UserView 
				where [pjrep].MSP_EpmResource_UserView.ResourceUID = [pjrep].MSP_EpmResourceByDay_UserView.ResourceUID ANd [Подразделения] is not NULL)	 as [Division]

				-------//---------
       FROM
         [pjrep].MSP_EpmResourceByDay_UserView 
       LEFT OUTER JOIN
	   ----------------------

	   -------------------------
       (
         SELECT
             MSP_EpmAssignment_UserView.ResourceUID, 
	
             SUM([pjrep].MSP_EpmAssignmentByDay_UserView.AssignmentCombinedWork) as [AllocatedCapacity],
             [pjrep].MSP_EpmAssignmentByDay_UserView.TimeByDay,
			 [pjrep].MSP_EpmProject_UserView.ProjectName as ProjectName,
			 [pjrep].MSP_EpmTask_UserView.TaskName  as TaskName
			 
           FROM
             [pjrep].MSP_EpmAssignment_UserView 
           INNER JOIN
                 [pjrep].MSP_EpmAssignmentByDay_UserView
              ON MSP_EpmAssignment_UserView.AssignmentUID = [pjrep].MSP_EpmAssignmentByDay_UserView.AssignmentUID
                 AND MSP_EpmAssignment_UserView.ProjectUID = [pjrep].MSP_EpmAssignmentByDay_UserView.ProjectUID
                AND MSP_EpmAssignment_UserView.TaskUID = [pjrep].MSP_EpmAssignmentByDay_UserView.TaskUID
			Inner join
				[pjrep].MSP_EpmProject_UserView
				on			
				MSP_EpmAssignment_UserView.ProjectUID = [pjrep].MSP_EpmProject_UserView.ProjectUID
			Inner join
				[pjrep].MSP_EpmTask_UserView
				on			
				MSP_EpmAssignment_UserView.ProjectUID = [pjrep].MSP_EpmTask_UserView.ProjectUID			

             WHERE
               MSP_EpmAssignmentByDay_UserView.TimeByDay BETWEEN
                 CONVERT(DATETIME, DATEADD(month, - 2, CURRENT_TIMESTAMP), 102)
                 AND CONVERT(DATETIME, DATEADD(month, 6, CURRENT_TIMESTAMP), 102)
             GROUP BY
                [pjrep].MSP_EpmAssignment_UserView.ResourceUID,
                [pjrep].MSP_EpmAssignmentByDay_UserView.TimeByDay,
				[pjrep].MSP_EpmProject_UserView.ProjectName,
				[pjrep].MSP_EpmTask_UserView.TaskName
			
          ) AS AssignmentTable
                   ON AssignmentTable.ResourceUID = MSP_EpmResourceByDay_UserView.ResourceUID
                      AND AssignmentTable.TimeByDay = MSP_EpmResourceByDay_UserView.TimeByDay
          WHERE
              (MSP_EpmResourceByDay_UserView.TimeByDay > CONVERT(DATETIME, DATEADD(month, - 2, CURRENT_TIMESTAMP), 102))
    AND (MSP_EpmResourceByDay_UserView.TimeByDay < CONVERT(DATETIME, DATEADD(month, 3, CURRENT_TIMESTAMP), 102)) 
	

	

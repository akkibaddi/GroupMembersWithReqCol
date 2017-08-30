public class GroupMembersController {

    // selected group whose members to view
    public ID groupId { get; set; }
    
    // provide group name to show on page
    public Group selectedGroup {
        get {
            return [
				SELECT
                	id, name
                FROM
                	group
                WHERE
                	id = :groupId
            ];
        }
    }
    
    // list of all active group members
    public List<User> groupMembers {
        get {
            return [
            	SELECT
                	id, firstName, lastName, userRole.name, lastLoginDate
                FROM
                	user
                WHERE
                	id IN ( SELECT userOrGroupId FROM groupmember WHERE groupId = :groupId )
                	AND
                	isActive = true
            ];
        }
    }
    
    /**
     * Controller
     */
    public GroupMembersController() {
        groupId = ApexPages.currentPage().getParameters().get('groupId');
    }
    
    public PageReference refresh() {
        return null;
    }
    
    // picklist of groups whose members to view
    public List<SelectOption> getgroupOptions() {
        
        List<SelectOption> options = new List<SelectOption>();

        options.add( new SelectOption( '', '- Select -' ) );
        for ( Group grp : [
            SELECT
            	id, name
            FROM
            	group
           	WHERE
            	type = 'Regular'
           	ORDER BY
            	name
        ] ) {
            options.add( new SelectOption( grp.id, grp.name ) );
        }
        
        return options;
    }
    
}
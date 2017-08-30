@isTest
private class GroupMembersControllerTest {
 
    @isTest
    static void test_refresh() {

        GroupMembersController controller = new GroupMembersController();
        
        Test.startTest();
        
        PageReference ref = controller.refresh();
        
        Test.stopTest();
        
        System.assert( ref == null );
        
    }
    
    @isTest
    static void test_get_queue_info() {
     
        Group grp = null;
        GroupMember groupMember = null;

        // avoid DML mixed operation exception
        // http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {

            grp = new Group();
            grp.name = 'Test Queue 1';
            grp.developerName = 'Test_Queue_1';
            grp.type = 'Regular';

            insert grp;
            
            groupMember = new GroupMember();
            groupMember.userOrGroupId = UserInfo.getUserId();
            groupMember.groupId = grp.id;
            
            insert groupMember;
            
        }
        
        PageReference pageRef = Page.QueueMembersListPage;

        Test.setCurrentPage( pageRef );
        
        ApexPages.currentPage().getParameters().put( 'groupId', grp.id );
        
        QueueMembersController controller = new QueueMembersController();
        
        Test.startTest();
        
		List<SelectOption> options = controller.getGroupOptions();
        
        List<User> groupMembers = controller.groupMembers;
        
        Group selectedgrp = controller.selectedGroup;
        
        Test.stopTest();
            
        System.assert( options.size() > 0 );
        
        Boolean isFound = false;
        for ( SelectOption option : options ) {
            if ( option.getLabel() == 'Test Queue 1' ) {
                isFound = true;
            }
        }
        System.assert( isFound );
        
        System.assert( selectedgrp != null );
        System.assertEquals( grp.id, controller.groupId );
        System.assertEquals( grp.id, selectedgrp.id );
        
        System.assert( groupMembers.size() > 0 );
        
        isFound = false;
        for ( User usr : groupMembers ) {
            if ( usr.id == groupMember.userOrGroupId ) {
                isFound = true;
            }
        }
        System.assert( isFound );
        
    }
    
}
<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_SFDC_Support_that_a_new_case_is_created</fullName>
        <description>Notify SFDC Support that a new case is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>aruna.narayanan@listertechnologies.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Case_Created</template>
    </alerts>
    <alerts>
        <fullName>Notify_change_in_Status</fullName>
        <ccEmails>tricentiscrmsupport@listertechnologies.com</ccEmails>
        <description>Notify change in Status</description>
        <protected>false</protected>
        <recipients>
            <field>Name_of_the_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_in_Case_Status</template>
    </alerts>
    <rules>
        <fullName>Change in status</fullName>
        <actions>
            <name>Notify_change_in_Status</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Status ) ,  CONTAINS(RecordType.Name, &apos;Tricentis Support&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To notify SFDC support that a new case is created</fullName>
        <actions>
            <name>Notify_SFDC_Support_that_a_new_case_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Tricentis Support</value>
        </criteriaItems>
        <description>To notify SFDC support that a new case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

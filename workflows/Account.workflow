<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_account_has_been_created</fullName>
        <description>New account has been created</description>
        <protected>false</protected>
        <recipients>
            <recipient>b.teuschler@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Alerts/New_Account</template>
    </alerts>
    <alerts>
        <fullName>cs_owner_is_changed</fullName>
        <description>cs owner is changed</description>
        <protected>false</protected>
        <recipients>
            <field>CSM_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/cs_owner</template>
    </alerts>
    <rules>
        <fullName>New account</fullName>
        <actions>
            <name>New_account_has_been_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When a new account is being created an e-mail should be sent to the SFDC admin.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send email to cs owner</fullName>
        <actions>
            <name>cs_owner_is_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email Alert to the CS owner</description>
        <formula>OR( 
AND( 
NOT( ISBLANK( CSM_Owner__c ) 
) , 
ISNEW() 
), 
AND( NOT( 
ISBLANK( CSM_Owner__c ) 
) , 
ISCHANGED( CSM_Owner__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

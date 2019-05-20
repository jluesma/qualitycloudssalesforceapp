<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Opportunity_Close_Date_in_the_past</fullName>
        <description>Alert Opportunity Close Date in the past</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/Alert_Close_Date_Today</template>
    </alerts>
    <alerts>
        <fullName>Another_Closed_Opportunity</fullName>
        <description>Another Closed Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>s.weber@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Big_deal_won</fullName>
        <description>Big deal won</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/Alert_Big_deal_won</template>
    </alerts>
    <alerts>
        <fullName>Closed_deal_re_opened</fullName>
        <description>Closed deal re-opened</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/closed_Opportunity_re_opened</template>
    </alerts>
    <alerts>
        <fullName>New_Opportunity_2Created_100_000_Euros</fullName>
        <description>New Opportunity Created &gt;= 100,000 Euros</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>New_Opportunity_Created_100_000_Euros</fullName>
        <description>New Opportunity Created &gt;= 100,000 Euros</description>
        <protected>false</protected>
        <recipients>
            <recipient>s.weber@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>New_Opportunity_Created_1_100_000_Euros</fullName>
        <description>New Opportunity Created &gt;= 100,000 Euros</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Oh_No_We_Lost_this_Opportunity</fullName>
        <description>Oh No! We &quot;Lost this Opportunity&quot;</description>
        <protected>false</protected>
        <recipients>
            <recipient>f.fuchsberger@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>s.johri@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>w.platz@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/Alert_Opportunity_Lost</template>
    </alerts>
    <alerts>
        <fullName>Oh_No_We_Lost_this_Opportunity3</fullName>
        <description>Oh No! We &quot;Lost this Opportunity&quot;</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>s.weber@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Opp_Lost_AMS</fullName>
        <description>Opp Lost AMS</description>
        <protected>false</protected>
        <recipients>
            <recipient>s.weber@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/Alert_Opportunity_Lost</template>
    </alerts>
    <alerts>
        <fullName>Opp_Lost_APAC</fullName>
        <description>Opp Lost APAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>d.weissboeck@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>t.hadorn@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/Alert_Opportunity_Lost</template>
    </alerts>
    <alerts>
        <fullName>Yae_Another_opportunity_Won</fullName>
        <description>Yae! Another opportunity Won!</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Yae_Another_opportunity_Won2</fullName>
        <description>Yae! Another opportunity Won!</description>
        <protected>false</protected>
        <recipients>
            <recipient>leadsadmin@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>s.weber@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>lost_Opportunity_Notification_EMEA</fullName>
        <description>lost Opportunity Notification EMEA</description>
        <protected>false</protected>
        <recipients>
            <recipient>f.fuchsberger@tricentis.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Alerts/Alert_Opportunity_Lost</template>
    </alerts>
    <fieldUpdates>
        <fullName>ACV_to_50000</fullName>
        <description>Set ACV to 50000</description>
        <field>Annual_contract_value__c</field>
        <formula>(50000)</formula>
        <name>ACV to 50000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccountStatus</fullName>
        <description>Account status gets updated when opportunity stage changes to closed won</description>
        <field>Status__c</field>
        <literalValue>Existing-Active</literalValue>
        <name>AccountStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Won_Date</fullName>
        <field>Closed_Won_Date__c</field>
        <formula>NOW()</formula>
        <name>Closed Won Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>License_Type</fullName>
        <field>License_Type__c</field>
        <literalValue>Subscription</literalValue>
        <name>License Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Last_Stage_Before_Closed_Lost</fullName>
        <field>Last_Stage_before_Closed_Lost__c</field>
        <formula>TEXT(PRIORVALUE( StageName ))</formula>
        <name>Populate Last Stage Before Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subscription_term_in_years</fullName>
        <field>Subscription_Term__c</field>
        <literalValue>3</literalValue>
        <name>Subscription term in years</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Big Deal won Alert</fullName>
        <actions>
            <name>Big_deal_won</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Annual_contract_value__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;EUR 50,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Won</value>
        </criteriaItems>
        <description>Trigers when an Opportunity is close (won), and the acv &gt; 50K</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed Won</fullName>
        <actions>
            <name>AccountStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Won</value>
        </criteriaItems>
        <description>When Opportunity stage changes to closed won associated account status changes</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Closed%2FWon Date</fullName>
        <actions>
            <name>Closed_Won_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Closed_Won_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>High Value Opportunity Created</fullName>
        <actions>
            <name>New_Opportunity_Created_100_000_Euros</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;EUR 100,000&quot;</value>
        </criteriaItems>
        <description>When Sales rep Created Opportunity &gt;= 100,000 Euros</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Opportunity_Created_1_100_000_Euros</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>New_Opportunity_2Created_100_000_Euros</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Closed Lost Date</fullName>
        <actions>
            <name>Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Lost</value>
        </criteriaItems>
        <description>Update the Close Date to today when the opportunity stage is set to Closed/Lost</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Lost</fullName>
        <actions>
            <name>Oh_No_We_Lost_this_Opportunity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Annual_contract_value__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Lost AMS</fullName>
        <actions>
            <name>Opp_Lost_AMS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Annual_contract_value__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Geo__c</field>
            <operation>equals</operation>
            <value>AMS</value>
        </criteriaItems>
        <description>send a notification to Franz in case an Opp is lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Lost APAC</fullName>
        <actions>
            <name>Opp_Lost_APAC</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Annual_contract_value__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Geo__c</field>
            <operation>equals</operation>
            <value>APAC</value>
        </criteriaItems>
        <description>send a notification to Thomas H. &amp; Dominik in case an Opp is lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Lost EMEA</fullName>
        <actions>
            <name>lost_Opportunity_Notification_EMEA</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6 Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Annual_contract_value__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Geo__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>send a notification to Franz in case an Opp is lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Last Stage Before Closed Lost</fullName>
        <actions>
            <name>Populate_Last_Stage_Before_Closed_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will capture the stage in which the opportunity is present before moving it to closed/lost</description>
        <formula>AND (  ISCHANGED( StageName ), PRIORVALUE( StageName ) &lt;&gt; &apos;6 Closed/Lost&apos;, ISPICKVAL(StageName,&apos;6 Closed/Lost&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set ACV value to 50000</fullName>
        <actions>
            <name>ACV_to_50000</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>0 Active (SQL)</value>
        </criteriaItems>
        <description>Set ACV to 50000 as default value on Opportunities when they are created in stage 0</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead source to MQL if it is converted</fullName>
        <actions>
            <name>License_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subscription_term_in_years</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_Created_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>The Lead Source value is automatically set &quot;MQL&quot; after a lead has been converted to an Opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>closed Opportunity re-opened</fullName>
        <actions>
            <name>Closed_deal_re_opened</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>6 Closed/Won,6 Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

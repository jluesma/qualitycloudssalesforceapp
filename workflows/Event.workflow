<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Activity Type</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Event.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>created to make reporting on Poc and partner influenced Opps</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

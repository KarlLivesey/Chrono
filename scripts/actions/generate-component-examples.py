#!/usr/bin/env python3
"""Subscriber-owned examples: reusable controls followed by ordinary Chrono actions."""
from pathlib import Path
from xml.etree import ElementTree as E
NS='http://soap.sforce.com/2006/04/metadata';E.register_namespace('',NS)
BASE=Path(__file__).resolve().parents[2]/'tests/subscriber/force-app/main/default/flows'
def n(parent,name,text=None):
 el=E.SubElement(parent,'{'+NS+'}'+name)
 if text is not None:el.text=str(text)
 return el
def link(parent,name,target):n(n(parent,name),'targetReference',target)
def val(parent,value):
 typ='booleanValue' if isinstance(value,bool) else 'numberValue' if isinstance(value,(int,float)) else 'elementReference' if value.startswith('ref:') else 'stringValue'
 n(n(parent,'value'),typ,str(value).lower() if isinstance(value,bool) else str(value)[4:] if typ=='elementReference' else value)
def root(title):
 r=E.Element('{'+NS+'}Flow');n(r,'apiVersion','67.0');n(r,'interviewLabel',title+' {!$Flow.CurrentDateTime}');n(r,'label',title)
 for key,value in [('BuilderType','LightningFlowBuilder'),('CanvasMode','AUTO_LAYOUT_CANVAS')]:v=n(r,'processMetadataValues');n(v,'name',key);val(v,value)
 n(r,'processType','Flow');n(r,'status','Active');return r
def screen(r,name,label,text=None,next=None):
 s=n(r,'screens');n(s,'name',name);n(s,'label',label);n(s,'locationX',0);n(s,'locationY',0);n(s,'allowBack','true');n(s,'allowFinish','true');n(s,'allowPause','false')
 if next:link(s,'connector',next)
 if text:f=n(s,'fields');n(f,'name',name+'Text');n(f,'fieldText',text);n(f,'fieldType','DisplayText')
 return s
def component(s,name,bundle,inputs):
 f=n(s,'fields');n(f,'name',name);n(f,'extensionName','skel:'+bundle);n(f,'fieldType','ComponentInstance')
 for name,value in inputs.items():p=n(f,'inputParameters');n(p,'name',name);val(p,value)
 n(f,'isRequired','true');n(f,'storeOutputAutomatically','true')
def action(r,name,family,label,inputs,next):
 a=n(r,'actionCalls');n(a,'name',name);n(a,'label',label);n(a,'locationX',0);n(a,'locationY',0);n(a,'actionName','skel__Chrono'+family+'Action');n(a,'actionType','apex');link(a,'connector','Check'+name);link(a,'faultConnector','Fault');n(a,'flowTransactionModel','CurrentTransaction')
 for name,value in inputs.items():p=n(a,'inputParameters');n(p,'name',name);val(p,value)
 n(a,'storeOutputAutomatically','true');name=a.find('{'+NS+'}name').text
 d=n(r,'decisions');n(d,'name','Check'+name);n(d,'label','Check '+label.lower());n(d,'locationX',0);n(d,'locationY',0);link(d,'defaultConnector','Fault');n(d,'defaultConnectorLabel','Failed');rule=n(d,'rules');n(rule,'name',name+'Succeeded');n(rule,'conditionLogic','and');condition=n(rule,'conditions');n(condition,'leftValueReference',name+'.success');n(condition,'operator','EqualTo');n(n(condition,'rightValue'),'booleanValue','true');link(rule,'connector',next);n(rule,'label','Succeeded')
def finish(r,stem,start='Choose',error='{!$Flow.FaultMessage}'):
 screen(r,'Fault','Example could not continue','<p>'+error+'</p><p>Use Previous to correct the input or configuration.</p>')
 s=n(r,'start');n(s,'locationX',0);n(s,'locationY',0);link(s,'connector',start)
 r[:]=sorted(r,key=lambda el:el.tag)
 E.indent(r,space='  ');E.ElementTree(r).write(BASE/(stem+'.flow-meta.xml'),encoding='UTF-8',xml_declaration=True)
r=root('Chrono example 9 - Duration and partial values');s=screen(r,'Choose','Choose values','<p>Use ordinary inputs; the outputs are ISO Text. Next totals the duration through a Chrono action.</p>','Total')
for name,kind,label,value in [('Duration','duration','Elapsed duration','PT1H30M'),('Clock','time','Local time','09:30:00.000'),('Month','yearmonth','Reporting month','2026-09'),('Birthday','monthday','Annual date','--02-29')]:component(s,name,'chronoFlowValueInput',dict(kind=kind,label=label,value=value,required=True))
action(r,'Total','DurationTools','Total elapsed hours',dict(operation='total',value='ref:Duration.value',unit='hour'),'Results')
screen(r,'Results','Selected values','<p>Duration: {!Duration.value}</p><p>Total hours: {!Total.total}</p><p>Time: {!Clock.value}</p><p>Year/month: {!Month.value}</p><p>Month/day: {!Birthday.value}</p>')
finish(r,'ChronoExampleValueInputs',error='{!Total.errorMessage} {!$Flow.FaultMessage}')
r=root('Chrono example 10 - Ranges and timezone display');s=screen(r,'Choose','Choose a range','<p>The end is excluded. Next calculates elapsed time and displays the same starting instant in three zones.</p>','Elapsed')
component(s,'Range','chronoFlowRange',dict(mode='datetime',label='Meeting range',timeZoneId='Europe/London',allowTimeZoneSelection=True,dateStyle='short',required=True,startValue='2026-09-08T09:00:00.000+01:00[Europe/London]',endValue='2026-09-08T10:00:00.000+01:00[Europe/London]'))
action(r,'Elapsed','Difference','Calculate elapsed time',dict(startValue='ref:Range.startValue',endValue='ref:Range.endValue'),'Results')
s=screen(r,'Results','Range and local clocks','<p>Interval: {!Range.rangeValue}</p><p>Elapsed duration: {!Elapsed.value}</p>');component(s,'Clocks','chronoZoneDisplay',dict(value='ref:Range.startValue',timeZoneIdsText='Europe/London,America/New_York,Asia/Tokyo',dateStyle='short'))
finish(r,'ChronoExampleRange',error='{!Elapsed.errorMessage} {!$Flow.FaultMessage}')
r=root('Chrono example 11 - Available appointments');lookup=n(r,'recordLookups');n(lookup,'name','Office');n(lookup,'label','Find the London demo schedule');n(lookup,'locationX',0);n(lookup,'locationY',0);n(lookup,'assignNullValuesIfNoRecordsFound','true');link(lookup,'connector','Choose');link(lookup,'faultConnector','Fault');n(lookup,'filterLogic','and');f=n(lookup,'filters');n(f,'field','Name');n(f,'operator','EqualTo');val(f,'Chrono demo - London weekdays');n(lookup,'getFirstRecordOnly','true');n(lookup,'object','OperatingHours');n(lookup,'storeOutputAutomatically','true')
s=screen(r,'Choose','Choose an available appointment','<p>Uses the existing London demo OperatingHours record, including its linked holidays. Choices allow ten minutes before and after each appointment. Selecting a time does not save a booking.</p>','NextWorkingDay')
component(s,'Appointment','chronoFlowAvailability',dict(label='Available appointment',required=True,valueType='ZonedDateTime',value='2026-08-28T09:00:00+01:00[Europe/London]',endValue='2026-09-01T17:00:00+01:00[Europe/London]',operatingHoursId='ref:Office.Id',duration='PT30M',stepDuration='PT30M',bufferBefore='PT10M',bufferAfter='PT10M',maximumResults=100))
action(r,'NextWorkingDay','WorkingDays','Add one working calendar day',dict(valueType='ZonedDateTime',value='ref:Appointment.startValue',amount=1,operatingHoursId='ref:Office.Id',closedTimePolicy='keep'),'Results')
screen(r,'Results','Appointment and follow-up','<p>Chosen start: {!Appointment.startValue}</p><p>Chosen end: {!Appointment.selectedEndValue}</p><p>One working date later at the same schedule-local clock: {!NextWorkingDay.value}</p><p>No records have been changed.</p>')
finish(r,'ChronoExampleAppointments',start='Office',error='{!NextWorkingDay.errorMessage} {!$Flow.FaultMessage}')
r=root('Chrono example 12 - Recurrence builder');formula=n(r,'formulas');n(formula,'name','SearchEnd');n(formula,'dataType','Date');n(formula,'expression','DATE(2026, 5, 10)');s=screen(r,'Choose','Build a meeting series','<p>Preview six Sunday meetings at 01:30 London time. The March clock-change gap is skipped. Next summarises the generated Text collection with a Chrono action.</p>','Summary')
component(s,'Rule','chronoFlowRecurrence',dict(startValue='2026-03-22T01:30:00+00:00[Europe/London]',timeZoneId='Europe/London',allowTimeZoneSelection=True,rule='FREQ=WEEKLY;INTERVAL=1;COUNT=6',untilDate='ref:SearchEnd',maximumResults=100))
action(r,'Summary','CollectionTools','Summarise occurrences',dict(operation='summary',valueType='ZonedDateTime',values='ref:Rule.values'),'Results')
screen(r,'Results','Meeting series','<p>Rule: {!Rule.rule}</p><p>Occurrences: {!Summary.count}</p><p>First: {!Summary.earliestValue}</p><p>Last: {!Summary.latestValue}</p>')
finish(r,'ChronoExampleRuleBuilder',error='{!Summary.errorMessage} {!$Flow.FaultMessage}')
